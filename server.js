const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const cors = require('cors');
const session = require('express-session');
const XLSX = require('xlsx');
const { v4: uuidv4 } = require('uuid');
const moment = require('moment');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 5000;
const JWT_SECRET = 'FirstLineLogistics2025SecretKey';

// إعدادات Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(express.static('public'));
app.use(express.static('.'));
app.use('/uploads', express.static('uploads'));

// إعدادات الجلسة
app.use(session({
  secret: JWT_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false, maxAge: 24 * 60 * 60 * 1000 } // 24 ساعة
}));

// إعدادات رفع الملفات
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    let uploadPath = process.env.NODE_ENV === 'production' ? '/tmp/uploads/' : 'uploads/';
    if (file.fieldname === 'idCopy') uploadPath += 'id-documents/';
    else if (file.fieldname === 'licenseCopy') uploadPath += 'licenses/';
    else if (file.fieldname === 'facePhoto') uploadPath += 'face-photos/';
    else uploadPath += 'registrations/';
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ 
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB
  fileFilter: function (req, file, cb) {
    let allowedTypes;
    if (file.fieldname === 'facePhoto') {
      allowedTypes = /jpeg|jpg|png/;
    } else {
      allowedTypes = /jpeg|jpg|png|pdf/;
    }
    
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (mimetype && extname) {
      return cb(null, true);
    } else {
      if (file.fieldname === 'facePhoto') {
        cb(new Error('صورة الوجه يجب أن تكون: JPG, JPEG, PNG فقط'));
      } else {
        cb(new Error('الملفات المسموحة فقط: JPG, JPEG, PNG, PDF'));
      }
    }
  }
});

// إنشاء مجلدات الرفع
const uploadDirs = process.env.NODE_ENV === 'production' 
  ? ['/tmp/uploads', '/tmp/uploads/id-documents', '/tmp/uploads/licenses', '/tmp/uploads/face-photos', '/tmp/uploads/registrations']
  : ['uploads', 'uploads/id-documents', 'uploads/licenses', 'uploads/face-photos', 'uploads/registrations'];

uploadDirs.forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// إنشاء قاعدة البيانات
const dbPath = process.env.NODE_ENV === 'production' ? '/tmp/delivery_system.db' : './delivery_system.db';
const db = new sqlite3.Database(dbPath);

// إنشاء الجداول
db.serialize(() => {
  // جدول المستخدمين (الموظفين)
  db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    fullName TEXT NOT NULL,
    email TEXT,
    role TEXT DEFAULT 'employee',
    department TEXT,
    isActive INTEGER DEFAULT 1,
    lastLogin DATETIME,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // جدول تسجيل المناديب
  db.run(`CREATE TABLE IF NOT EXISTS delivery_registrations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    formNumber TEXT UNIQUE NOT NULL,
    
    -- بيانات شخصية
    fullName TEXT NOT NULL,
    idNumber TEXT NOT NULL,
    mobileNumber TEXT NOT NULL,
    stcPayNumber TEXT NOT NULL,
    
    -- تطبيق العمل
    selectedApp TEXT NOT NULL,
    
    -- التحقق الرقمي
    isPhoneVerified INTEGER DEFAULT 0,
    verificationCode TEXT,
    verificationTime DATETIME,
    
    -- الملفات المرفوعة
    idCopyFile TEXT,
    licenseCopyFile TEXT,
    facePhotoFile TEXT,
    
    -- معلومات التسجيل
    registeredBy INTEGER,
    ipAddress TEXT,
    userAgent TEXT,
    status TEXT DEFAULT 'pending',
    notes TEXT,
    
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (registeredBy) REFERENCES users (id)
  )`);

  // جدول سجل العمليات
  db.run(`CREATE TABLE IF NOT EXISTS activity_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER,
    action TEXT NOT NULL,
    target TEXT,
    details TEXT,
    ipAddress TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (userId) REFERENCES users (id)
  )`);

  // إنشاء مستخدم افتراضي (المدير)
  const defaultPassword = bcrypt.hashSync('admin123', 10);
  db.run(`INSERT OR IGNORE INTO users (username, password, fullName, role, department) 
          VALUES ('admin', ?, 'مدير النظام', 'admin', 'الإدارة')`, [defaultPassword]);
});

// دالة التحقق من المصادقة
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

// دالة تسجيل الأنشطة
const logActivity = (userId, action, target, details, ipAddress) => {
  db.run(`INSERT INTO activity_logs (userId, action, target, details, ipAddress) 
          VALUES (?, ?, ?, ?, ?)`, [userId, action, target, details, ipAddress]);
};

// Routes

// ملاحظة: تم نقل جميع معالجات HTML إلى vercel.json
// Vercel سيتعامل مع توجيه الملفات الثابتة تلقائياً

// عرض الملفات المرفوعة
app.get('/uploads/*', (req, res) => {
  const filePath = req.params[0];
  const fullPath = process.env.NODE_ENV === 'production' 
    ? path.join('/tmp/uploads', filePath)
    : path.join(__dirname, 'uploads', filePath);
  
  if (fs.existsSync(fullPath)) {
    res.sendFile(fullPath);
  } else {
    res.status(404).json({ success: false, message: 'الملف غير موجود' });
  }
});

// تسجيل الدخول
app.post('/api/login', (req, res) => {
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

    // تحديث آخر تسجيل دخول
    db.run('UPDATE users SET lastLogin = CURRENT_TIMESTAMP WHERE id = ?', [user.id]);

    // إنشاء رمز المصادقة
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

    // تسجيل النشاط
    logActivity(user.id, 'login', 'system', 'تسجيل دخول ناجح', req.ip);

    res.json({
      success: true,
      message: 'تم تسجيل الدخول بنجاح',
      token: token,
      user: {
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        role: user.role,
        department: user.department
      }
    });
  });
});

// تسجيل مندوب جديد
app.post('/api/register', upload.fields([
  { name: 'idCopy', maxCount: 1 },
  { name: 'licenseCopy', maxCount: 1 },
  { name: 'facePhoto', maxCount: 1 }
]), (req, res) => {
  try {
    const formNumber = 'FL-REG-' + moment().format('YYYY') + '-' + Date.now();
    
    const {
      fullName, 
      idNumber, 
      mobileNumber, 
      stcPayNumber, 
      selectedApp,
      isPhoneVerified
    } = req.body;

    // التحقق من البيانات المطلوبة
    if (!fullName || !idNumber || !mobileNumber || !selectedApp || !stcPayNumber) {
      return res.status(400).json({ 
        success: false, 
        message: 'البيانات الأساسية مطلوبة' 
      });
    }

    // التحقق من التحقق الرقمي
    if (!isPhoneVerified || isPhoneVerified !== 'true') {
      return res.status(400).json({ 
        success: false, 
        message: 'يجب التحقق من رقم الجوال أولاً' 
      });
    }

    // التحقق من وجود الملفات المطلوبة
    if (!req.files['idCopy'] || !req.files['licenseCopy'] || !req.files['facePhoto']) {
      return res.status(400).json({ 
        success: false, 
        message: 'جميع المستندات وصورة الوجه مطلوبة' 
      });
    }

    const registrationData = {
      formNumber,
      fullName, 
      idNumber, 
      mobileNumber, 
      stcPayNumber, 
      selectedApp,
      isPhoneVerified: 1,
      idCopyFile: req.files['idCopy'][0].filename,
      licenseCopyFile: req.files['licenseCopy'][0].filename,
      facePhotoFile: req.files['facePhoto'][0].filename,
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
      status: 'pending'
    };

    // إدراج البيانات في قاعدة البيانات
    const sql = `INSERT INTO delivery_registrations 
      (formNumber, fullName, idNumber, mobileNumber, stcPayNumber, selectedApp, 
       isPhoneVerified, idCopyFile, licenseCopyFile, facePhotoFile, 
       ipAddress, userAgent, status) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    const values = [
      registrationData.formNumber,
      registrationData.fullName,
      registrationData.idNumber,
      registrationData.mobileNumber,
      registrationData.stcPayNumber,
      registrationData.selectedApp,
      registrationData.isPhoneVerified,
      registrationData.idCopyFile,
      registrationData.licenseCopyFile,
      registrationData.facePhotoFile,
      registrationData.ipAddress,
      registrationData.userAgent,
      registrationData.status
    ];

    db.run(sql, values, function(err) {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ 
          success: false, 
          message: 'خطأ في حفظ البيانات' 
        });
      }

      // تسجيل النشاط
      logActivity(null, 'registration', 'delivery_registrations', 
        `تسجيل مندوب جديد: ${fullName}`, req.ip);

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

// جلب جميع التسجيلات (للإدارة فقط)
app.get('/api/registrations', authenticateToken, (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 50;
  const offset = (page - 1) * limit;
  const search = req.query.search || '';
  const status = req.query.status || '';

  let whereClause = '';
  let params = [];

  if (search) {
    whereClause += ' WHERE (fullName LIKE ? OR idNumber LIKE ? OR mobileNumber LIKE ? OR formNumber LIKE ?)';
    params.push(`%${search}%`, `%${search}%`, `%${search}%`, `%${search}%`);
  }

  if (status) {
    whereClause += search ? ' AND status = ?' : ' WHERE status = ?';
    params.push(status);
  }

  // عدد النتائج الإجمالي
  db.get(`SELECT COUNT(*) as total FROM delivery_registrations${whereClause}`, params, (err, countResult) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }

    // النتائج مع الترقيم
    const sql = `SELECT * FROM delivery_registrations${whereClause} ORDER BY createdAt DESC LIMIT ? OFFSET ?`;
    const queryParams = [...params, limit, offset];
    
    db.all(sql, queryParams, (err, registrations) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
      }

      const totalPages = Math.ceil(countResult.total / limit);

      res.json({
        success: true,
        registrations: registrations,
        totalPages: totalPages,
        currentPage: page,
        total: countResult.total
      });
    });
  });
});

// جلب الإحصائيات
app.get('/api/statistics', authenticateToken, (req, res) => {
  const today = moment().format('YYYY-MM-DD');
  
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

          db.get('SELECT COUNT(*) as today FROM delivery_registrations WHERE DATE(createdAt) = ?', [today], (err, todayResult) => {
            if (err) {
              return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
            }

            res.json({
              success: true,
              total: totalResult.total,
              pending: pendingResult.pending,
              approved: approvedResult.approved,
              today: todayResult.today
            });
          });
        });
      });
    });
  });
});

// جلب تفاصيل تسجيل محدد
app.get('/api/registrations/:id', authenticateToken, (req, res) => {
  const id = req.params.id;
  
  db.get('SELECT * FROM delivery_registrations WHERE id = ?', [id], (err, registration) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }
    
    if (!registration) {
      return res.status(404).json({ success: false, message: 'التسجيل غير موجود' });
    }
    
    res.json(registration);
  });
});

// تحديث حالة التسجيل
app.put('/api/registrations/:id/status', authenticateToken, (req, res) => {
  const id = req.params.id;
  const { status } = req.body;
  
  if (!['pending', 'approved', 'rejected'].includes(status)) {
    return res.status(400).json({ success: false, message: 'حالة غير صحيحة' });
  }
  
  db.run('UPDATE delivery_registrations SET status = ?, updatedAt = CURRENT_TIMESTAMP WHERE id = ?', 
    [status, id], function(err) {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في تحديث البيانات' });
    }
    
    if (this.changes === 0) {
      return res.status(404).json({ success: false, message: 'التسجيل غير موجود' });
    }
    
    // تسجيل النشاط
    logActivity(req.user.id, 'status_update', 'delivery_registrations', 
      `تحديث حالة التسجيل رقم ${id} إلى ${status}`, req.ip);
    
    res.json({ success: true, message: 'تم تحديث الحالة بنجاح' });
  });
});

// تصدير البيانات إلى Excel
app.get('/api/export-excel', authenticateToken, (req, res) => {
  db.all('SELECT * FROM delivery_registrations ORDER BY createdAt DESC', (err, registrations) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }

    try {
      // إعداد البيانات للتصدير
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

      // إنشاء ملف Excel
      const wb = XLSX.utils.book_new();
      const ws = XLSX.utils.json_to_sheet(exportData);
      
      XLSX.utils.book_append_sheet(wb, ws, 'تسجيلات المناديب');
      
      const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
      
      res.setHeader('Content-Disposition', 'attachment; filename=delivery-registrations.xlsx');
      res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      res.send(buffer);
      
      // تسجيل النشاط
      logActivity(req.user.id, 'export', 'delivery_registrations', 'تصدير البيانات إلى Excel', req.ip);
      
    } catch (error) {
      console.error('Export error:', error);
      res.status(500).json({ success: false, message: 'خطأ في تصدير البيانات' });
    }
  });
});

// سجل الأنشطة
app.get('/api/activity-logs', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ success: false, message: 'صلاحية غير كافية' });
  }

  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 100;
  const offset = (page - 1) * limit;

  const query = `
    SELECT al.*, u.fullName as userName 
    FROM activity_logs al 
    LEFT JOIN users u ON al.userId = u.id 
    ORDER BY al.timestamp DESC 
    LIMIT ? OFFSET ?
  `;

  db.all(query, [limit, offset], (err, rows) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'خطأ في قاعدة البيانات' });
    }

    res.json({ success: true, data: rows });
  });
});

// إحصائيات النظام
app.get('/api/statistics', authenticateToken, (req, res) => {
  const queries = {
    totalRegistrations: 'SELECT COUNT(*) as count FROM delivery_registrations',
    pendingRegistrations: 'SELECT COUNT(*) as count FROM delivery_registrations WHERE status = "pending"',
    approvedRegistrations: 'SELECT COUNT(*) as count FROM delivery_registrations WHERE status = "approved"',
    rejectedRegistrations: 'SELECT COUNT(*) as count FROM delivery_registrations WHERE status = "rejected"',
    todayRegistrations: 'SELECT COUNT(*) as count FROM delivery_registrations WHERE DATE(createdAt) = DATE("now")',
    appDistribution: 'SELECT selectedApp, COUNT(*) as count FROM delivery_registrations GROUP BY selectedApp'
  };

  const results = {};
  let completed = 0;
  const total = Object.keys(queries).length;

  Object.entries(queries).forEach(([key, query]) => {
    db.all(query, [], (err, rows) => {
      if (!err) {
        results[key] = key === 'appDistribution' ? rows : rows[0].count;
      }
      completed++;
      
      if (completed === total) {
        res.json({ success: true, data: results });
      }
    });
  });
});

// إرسال كود التحقق للجوال
app.post('/api/send-verification', (req, res) => {
  const { phoneNumber } = req.body;
  
  if (!phoneNumber) {
    return res.status(400).json({ 
      success: false, 
      message: 'رقم الجوال مطلوب' 
    });
  }

  // توليد كود عشوائي من 6 أرقام
  const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
  
  // حفظ الكود مؤقتاً (في بيئة الإنتاج: يُرسل SMS حقيقي)
  // هنا سنحفظه في ذاكرة مؤقتة
  const tempVerificationCodes = global.tempVerificationCodes || {};
  tempVerificationCodes[phoneNumber] = {
    code: verificationCode,
    timestamp: Date.now(),
    attempts: 0
  };
  global.tempVerificationCodes = tempVerificationCodes;

  // في بيئة الإنتاج: إرسال SMS
  console.log(`كود التحقق لـ ${phoneNumber}: ${verificationCode}`);

  res.json({
    success: true,
    message: 'تم إرسال كود التحقق بنجاح',
    // في التطوير فقط - لا تُرسل في الإنتاج
    developmentCode: verificationCode
  });
});

// التحقق من كود الجوال
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

  // التحقق من انتهاء الصلاحية (5 دقائق)
  const now = Date.now();
  const timeDiff = now - storedData.timestamp;
  if (timeDiff > 5 * 60 * 1000) {
    delete tempVerificationCodes[phoneNumber];
    return res.status(400).json({ 
      success: false, 
      message: 'انتهت صلاحية الكود، يرجى طلب كود جديد' 
    });
  }

  // التحقق من عدد المحاولات
  if (storedData.attempts >= 3) {
    delete tempVerificationCodes[phoneNumber];
    return res.status(400).json({ 
      success: false, 
      message: 'تم تجاوز عدد المحاولات المسموح، يرجى طلب كود جديد' 
    });
  }

  // التحقق من الكود
  if (storedData.code !== code) {
    storedData.attempts++;
    return res.status(400).json({ 
      success: false, 
      message: `كود التحقق غير صحيح. المحاولات المتبقية: ${3 - storedData.attempts}` 
    });
  }

  // نجح التحقق
  delete tempVerificationCodes[phoneNumber];
  
  res.json({
    success: true,
    message: 'تم التحقق من رقم الجوال بنجاح'
  });
});

// معالجة الأخطاء
app.use((error, req, res, next) => {
  console.error('Error:', error);
  
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({ 
        success: false, 
        message: 'حجم الملف كبير جداً (الحد الأقصى 10 ميجابايت)' 
      });
    }
  }
  
  res.status(500).json({ 
    success: false, 
    message: 'خطأ في الخادم' 
  });
});

// بدء تشغيل السيرفر
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 الخادم يعمل على المنفذ ${PORT}`);
  console.log(`📊 لوحة التحكم: http://0.0.0.0:${PORT}/dashboard`);
  console.log(`📝 النموذج: http://0.0.0.0:${PORT}/`);
  console.log(`🔑 تسجيل الدخول الافتراضي: admin / admin123`);
});

module.exports = app;