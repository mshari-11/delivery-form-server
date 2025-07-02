@echo off
echo ===================================
echo   رفع مشروع شركة الخط الأول
echo   نظام تسجيل مناديب التوصيل
echo ===================================
echo.

echo الخطوة 1: إعداد Git Repository...
git init
if %errorlevel% neq 0 (
    echo خطأ في إنشاء Git repository
    pause
    exit /b 1
)

echo الخطوة 2: إضافة الملفات...
git add .
if %errorlevel% neq 0 (
    echo خطأ في إضافة الملفات
    pause
    exit /b 1
)

echo الخطوة 3: عمل Commit الأول...
git commit -m "الإصدار 2.1.0 - تحديث الأيقونات ونظام الصلاحيات"
if %errorlevel% neq 0 (
    echo خطأ في عمل commit
    pause
    exit /b 1
)

echo.
echo ===================================
echo تم إعداد Git Repository بنجاح!
echo ===================================
echo.
echo الخطوات التالية (يدوياً):
echo 1. إنشاء repository جديد على GitHub
echo 2. تسجيل الدخول على github.com
echo 3. إنشاء repository بالاسم: delivery-form-server
echo 4. تشغيل الملف: push-to-github.bat
echo.
pause
