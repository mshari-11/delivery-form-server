# دليل رفع المشروع على GitHub و Vercel

## 📋 الخطوات المطلوبة

### 🔧 1. إعداد Git Repository

#### إنشاء Repository جديد
```bash
# في مجلد المشروع
git init
git add .
git commit -m "الإصدار 2.1.0 - تحديث الأيقونات ونظام الصلاحيات"
```

#### ربط مع GitHub
```bash
# إنشاء repository جديد على GitHub أولاً، ثم:
git remote add origin https://github.com/YOUR_USERNAME/delivery-form-server.git
git branch -M main
git push -u origin main
```

### 🌐 2. إعداد Vercel

#### الطريقة الأولى - عبر GitHub (مستحسنة)
1. تسجيل الدخول على [vercel.com](https://vercel.com)
2. النقر على "New Project"
3. اختيار "Import Git Repository"
4. اختيار repository "delivery-form-server"
5. التأكد من الإعدادات:
   - **Framework Preset**: Other
   - **Root Directory**: `./`
   - **Build Command**: `npm run build` (أو تركه فارغ)
   - **Output Directory**: `public`
6. النقر على "Deploy"

#### الطريقة الثانية - عبر CLI
```bash
# تثبيت Vercel CLI
npm i -g vercel

# تسجيل الدخول
vercel login

# النشر
vercel --prod
```

### ⚙️ 3. إعدادات Vercel المتقدمة

#### متغيرات البيئة (Environment Variables)
في لوحة تحكم Vercel، إضافة:
- `NODE_ENV`: `production`
- `DATABASE_URL`: (إذا كنت تستخدم قاعدة بيانات خارجية)

#### إعدادات النطاق المخصص
1. الذهاب إلى Project Settings
2. Domains
3. إضافة النطاق المخصص

## 📁 ملفات المشروع للنشر

### ✅ الملفات المطلوبة:
- `package.json` - إعدادات Node.js
- `server.js` - الخادم الرئيسي
- `vercel.json` - إعدادات Vercel
- `public/` - الملفات الثابتة
- `README.md` - التوثيق
- `.gitignore` - ملفات Git المستثناة

### ❌ الملفات المستثناة:
- `node_modules/` - تبعيات Node.js
- `uploads/` - الملفات المرفوعة (عدا المجلدات الفارغة)
- `*.db` - ملفات قاعدة البيانات المحلية
- `.env` - متغيرات البيئة الحساسة

## 🚀 خطوات النشر السريع

### 1. التحقق من الملفات
```bash
# التحقق من الملفات المعدلة
git status

# إضافة الملفات الجديدة
git add .

# عمل commit
git commit -m "تحديث النظام - إضافة أيقونات وصلاحيات الموظفين"
```

### 2. رفع على GitHub
```bash
# رفع على GitHub
git push origin main
```

### 3. النشر على Vercel
- سيتم النشر تلقائياً عند رفع الكود على GitHub
- أو استخدام: `vercel --prod`

## 🔗 الروابط المفيدة

### GitHub
- إنشاء Repository: [github.com/new](https://github.com/new)
- توثيق Git: [git-scm.com/docs](https://git-scm.com/docs)

### Vercel
- لوحة التحكم: [vercel.com/dashboard](https://vercel.com/dashboard)
- توثيق Vercel: [vercel.com/docs](https://vercel.com/docs)

## 🛠️ استكشاف الأخطاء

### مشاكل شائعة وحلولها:

#### خطأ في Git
```bash
# إذا واجهت مشكلة في Git
git config --global user.name "اسمك"
git config --global user.email "email@example.com"
```

#### خطأ في Vercel Build
- التأكد من وجود `package.json`
- التأكد من إعدادات `vercel.json`
- مراجعة Build Logs في Vercel

#### مشكلة في الأيقونات
- التأكد من تضمين جميع ملفات CSS
- التحقق من مسارات الملفات

## 🎯 النتيجة المتوقعة

بعد النشر الناجح:
- ✅ رابط GitHub: `https://github.com/YOUR_USERNAME/delivery-form-server`
- ✅ رابط Vercel: `https://delivery-form-server.vercel.app`
- ✅ النموذج يعمل بجميع الأيقونات
- ✅ نظام الصلاحيات فعال
- ✅ التحديثات التلقائية عند تعديل الكود

## 📞 الدعم
إذا واجهت أي مشكلة، تأكد من:
1. صحة ملف `vercel.json`
2. وجود جميع الملفات المطلوبة
3. إعدادات GitHub صحيحة
4. متغيرات البيئة في Vercel

---
**تاريخ الإعداد:** 30 يونيو 2025  
**الإصدار:** 2.1.0  
**الحالة:** ✅ جاهز للنشر
