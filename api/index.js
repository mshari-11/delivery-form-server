const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const cors = require('cors');
const XLSX = require('xlsx');
const moment = require('moment');
const path = require('path');
const fs = require('fs');

const app = express();
const JWT_SECRET = 'FirstLineLogistics2025SecretKey';

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// In-memory file storage for serverless
const storage = multer.memoryStorage();
const upload = multer({ 
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: function (req, file, cb) {
    const allowedTypes = /jpeg|jpg|png|pdf/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error('نوع الملف غير مدعوم'));
    }
  }
});

// In-memory database for serverless
let db;
function initDatabase() {
  if (!db) {
    db = new sqlite3.Database(':memory:');
    
    db.serialize(() => {
      // Users table
      db.run(`CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        role TEXT DEFAULT 'employee',
        isActive INTEGER DEFAULT 1,
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
      )`);

      // Delivery registrations table
      db.run(`CREATE TABLE IF NOT EXISTS delivery_registrations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        formNumber TEXT UNIQUE NOT NULL,
        fullName TEXT NOT NULL,
        idNumber TEXT NOT NULL,
        mobileNumber TEXT NOT NULL,
        stcPayNumber TEXT NOT NULL,
        selectedApp TEXT NOT NULL,
        isPhoneVerified INTEGER DEFAULT 0,
        idCopyFile TEXT,
        licenseCopyFile TEXT,
        facePhotoFile TEXT,
        ipAddress TEXT,
        userAgent TEXT,
        status TEXT DEFAULT 'pending',
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
      )`);

      // Create default admin user
      const defaultPassword = bcrypt.hashSync('admin123', 10);
      db.run(`INSERT OR IGNORE INTO users (username, password, fullName, role) 
              VALUES ('admin', ?, 'مدير النظام', 'admin')`, [defaultPassword]);
    });
  }
  return db;
}

// Authentication middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ success: false, message: 'مطلوب تسجيل الدخول' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ success: false, message: 'رمز المصادقة غير صالح' });
    }
    req.user = user;
    next();
  });
};

// API Routes

// Login
app.post('/api/login', (req, res) => {
  const db = initDatabase();
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ 
      success: false, 
      message: 'اسم المستخدم وكلمة المرور مطلوبان' 
    });
  }

  db.get('SELECT * FROM users WHERE username = ? AND isActive = 1', [username], (err, user) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }

    if (!user || !bcrypt.compareSync(password, user.password)) {
      return res.status(401).json({ 
        success: false, 
        message: 'اسم المستخدم أو كلمة المرور غير صحيحة' 
      });
    }

    const token = jwt.sign(
      { 
        id: user.id, 
        username: user.username, 
        role: user.role,
        fullName: user.fullName 
      }, 
      JWT_SECRET, 
      { expiresIn: '24h' }
    );

    res.json({
      success: true,
      message: 'تم تسجيل الدخول بنجاح',
      token: token,
      user: {
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        role: user.role
      }
    });
  });
});

// Register delivery person
app.post('/api/register', upload.fields([
  { name: 'idCopy', maxCount: 1 },
  { name: 'licenseCopy', maxCount: 1 },
  { name: 'facePhoto', maxCount: 1 }
]), (req, res) => {
  try {
    const db = initDatabase();
    const formNumber = 'FL-REG-' + moment().format('YYYY') + '-' + Date.now();
    
    const {
      fullName, 
      idNumber, 
      mobileNumber, 
      stcPayNumber, 
      selectedApp,
      isPhoneVerified
    } = req.body;

    // Validate required fields
    if (!fullName || !idNumber || !mobileNumber || !selectedApp || !stcPayNumber) {
      return res.status(400).json({ 
        success: false, 
        message: 'البيانات الأساسية مطلوبة' 
      });
    }

    // Check phone verification
    if (!isPhoneVerified || isPhoneVerified !== 'true') {
      return res.status(400).json({ 
        success: false, 
        message: 'يجب التحقق من رقم الجوال أولاً' 
      });
    }

    // Process uploaded files
    let idCopyData = null, licenseCopyData = null, facePhotoData = null;
    
    if (req.files['idCopy']) {
      idCopyData = req.files['idCopy'][0].buffer.toString('base64');
    }
    if (req.files['licenseCopy']) {
      licenseCopyData = req.files['licenseCopy'][0].buffer.toString('base64');
    }
    if (req.files['facePhoto']) {
      facePhotoData = req.files['facePhoto'][0].buffer.toString('base64');
    }

    if (!idCopyData || !licenseCopyData || !facePhotoData) {
      return res.status(400).json({ 
        success: false, 
        message: 'جميع المستندات وصورة الوجه مطلوبة' 
      });
    }

    // Insert into database
    const sql = `INSERT INTO delivery_registrations 
      (formNumber, fullName, idNumber, mobileNumber, stcPayNumber, selectedApp, 
       isPhoneVerified, idCopyFile, licenseCopyFile, facePhotoFile, 
       ipAddress, userAgent, status) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    const values = [
      formNumber, fullName, idNumber, mobileNumber, stcPayNumber, selectedApp,
      1, idCopyData, licenseCopyData, facePhotoData,
      req.ip, req.get('User-Agent'), 'pending'
    ];

    db.run(sql, values, function(err) {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ 
          success: false, 
          message: 'خطأ في حفظ البيانات' 
        });
      }

      res.json({
        success: true,
        message: 'تم تسجيل المندوب بنجاح',
        registrationId: formNumber,
        data: {
          id: this.lastID,
          formNumber: formNumber,
          fullName: fullName,
          selectedApp: selectedApp,
          status: 'pending'
        }
      });
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ 
      success: false, 
      message: 'حدث خطأ في التسجيل' 
    });
  }
});

// Get all registrations
app.get('/api/registrations', authenticateToken, (req, res) => {
  const db = initDatabase();
  
  db.all('SELECT * FROM delivery_registrations ORDER BY createdAt DESC', (err, registrations) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }

    res.json({
      success: true,
      registrations: registrations,
      total: registrations.length
    });
  });
});

// Get statistics
app.get('/api/statistics', authenticateToken, (req, res) => {
  const db = initDatabase();
  
  db.serialize(() => {
    db.get('SELECT COUNT(*) as total FROM delivery_registrations', (err, totalResult) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
      }

      db.get('SELECT COUNT(*) as pending FROM delivery_registrations WHERE status = "pending"', (err, pendingResult) => {
        if (err) {
          return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
        }

        db.get('SELECT COUNT(*) as approved FROM delivery_registrations WHERE status = "approved"', (err, approvedResult) => {
          if (err) {
            return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
          }

          res.json({
            success: true,
            total: totalResult.total,
            pending: pendingResult.pending,
            approved: approvedResult.approved,
            rejected: totalResult.total - pendingResult.pending - approvedResult.approved
          });
        });
      });
    });
  });
});

// Update registration status
app.put('/api/registrations/:id/status', authenticateToken, (req, res) => {
  const db = initDatabase();
  const id = req.params.id;
  const { status } = req.body;
  
  if (!['pending', 'approved', 'rejected'].includes(status)) {
    return res.status(400).json({ success: false, message: 'حالة غير صحيحة' });
  }
  
  db.run('UPDATE delivery_registrations SET status = ? WHERE id = ?', 
    [status, id], function(err) {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في تحديث البيانات' });
    }
    
    if (this.changes === 0) {
      return res.status(404).json({ success: false, message: 'التسجيل غير موجود' });
    }
    
    res.json({ success: true, message: 'تم تحديث الحالة بنجاح' });
  });
});

// Export to Excel
app.get('/api/export-excel', authenticateToken, (req, res) => {
  const db = initDatabase();
  
  db.all('SELECT * FROM delivery_registrations ORDER BY createdAt DESC', (err, registrations) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }

    try {
      const exportData = registrations.map(reg => ({
        'رقم التسجيل': reg.formNumber,
        'الاسم الكامل': reg.fullName,
        'رقم الهوية': reg.idNumber,
        'رقم الجوال': reg.mobileNumber,
        'رقم STC Pay': reg.stcPayNumber,
        'التطبيق': reg.selectedApp,
        'التحقق من الجوال': reg.isPhoneVerified ? 'تم' : 'لم يتم',
        'الحالة': reg.status,
        'تاريخ التسجيل': moment(reg.createdAt).format('YYYY-MM-DD HH:mm:ss')
      }));

      const wb = XLSX.utils.book_new();
      const ws = XLSX.utils.json_to_sheet(exportData);
      
      XLSX.utils.book_append_sheet(wb, ws, 'تسجيلات المناديب');
      
      const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
      
      res.setHeader('Content-Disposition', 'attachment; filename=delivery-registrations.xlsx');
      res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      res.send(buffer);
      
    } catch (error) {
      console.error('Export error:', error);
      res.status(500).json({ success: false, message: 'خطأ في تصدير البيانات' });
    }
  });
});

// Send verification code
app.post('/api/send-verification', (req, res) => {
  const { phoneNumber } = req.body;
  
  if (!phoneNumber) {
    return res.status(400).json({ 
      success: false, 
      message: 'رقم الجوال مطلوب' 
    });
  }

  const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
  
  const tempVerificationCodes = global.tempVerificationCodes || {};
  tempVerificationCodes[phoneNumber] = {
    code: verificationCode,
    timestamp: Date.now(),
    attempts: 0
  };
  global.tempVerificationCodes = tempVerificationCodes;

  console.log(`كود التحقق لـ ${phoneNumber}: ${verificationCode}`);

  res.json({
    success: true,
    message: 'تم إرسال كود التحقق بنجاح',
    developmentCode: verificationCode
  });
});

// Verify phone
app.post('/api/verify-phone', (req, res) => {
  const { phoneNumber, code } = req.body;
  
  if (!phoneNumber || !code) {
    return res.status(400).json({ 
      success: false, 
      message: 'رقم الجوال والكود مطلوبان' 
    });
  }

  const tempVerificationCodes = global.tempVerificationCodes || {};
  const storedData = tempVerificationCodes[phoneNumber];

  if (!storedData) {
    return res.status(400).json({ 
      success: false, 
      message: 'لم يتم إرسال كود تحقق لهذا الرقم' 
    });
  }

  const now = Date.now();
  const timeDiff = now - storedData.timestamp;
  if (timeDiff > 5 * 60 * 1000) {
    delete tempVerificationCodes[phoneNumber];
    return res.status(400).json({ 
      success: false, 
      message: 'انتهت صلاحية الكود، يرجى طلب كود جديد' 
    });
  }

  if (storedData.attempts >= 3) {
    delete tempVerificationCodes[phoneNumber];
    return res.status(400).json({ 
      success: false, 
      message: 'تم تجاوز عدد المحاولات المسموح، يرجى طلب كود جديد' 
    });
  }

  if (storedData.code !== code) {
    storedData.attempts++;
    return res.status(400).json({ 
      success: false, 
      message: `كود التحقق غير صحيح. المحاولات المتبقية: ${3 - storedData.attempts}` 
    });
  }

  delete tempVerificationCodes[phoneNumber];
  
  res.json({
    success: true,
    message: 'تم التحقق من رقم الجوال بنجاح'
  });
});

// File serving endpoint
app.get('/uploads/:type/:filename', (req, res) => {
  const { type, filename } = req.params;
  
  const db = initDatabase();
  let fileColumn;
  
  switch(type) {
    case 'id-documents':
      fileColumn = 'idCopyFile';
      break;
    case 'licenses':
      fileColumn = 'licenseCopyFile';
      break;
    case 'face-photos':
      fileColumn = 'facePhotoFile';
      break;
    default:
      return res.status(404).json({ success: false, message: 'نوع الملف غير صحيح' });
  }
  
  db.get(`SELECT ${fileColumn} FROM delivery_registrations WHERE ${fileColumn} LIKE ?`, 
    [`%${filename}%`], (err, row) => {
    if (err || !row) {
      return res.status(404).json({ success: false, message: 'الملف غير موجود' });
    }
    
    try {
      const base64Data = row[fileColumn];
      const buffer = Buffer.from(base64Data, 'base64');
      
      const ext = path.extname(filename).toLowerCase();
      let contentType = 'application/octet-stream';
      
      if (['.jpg', '.jpeg'].includes(ext)) contentType = 'image/jpeg';
      else if (ext === '.png') contentType = 'image/png';
      else if (ext === '.pdf') contentType = 'application/pdf';
      
      res.setHeader('Content-Type', contentType);
      res.setHeader('Content-Disposition', `inline; filename="${filename}"`);
      res.send(buffer);
      
    } catch (error) {
      res.status(500).json({ success: false, message: 'خطأ في قراءة الملف' });
    }
  });
});

// Export for Vercel
module.exports = app;
