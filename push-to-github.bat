@echo off
echo ===================================
echo   رفع المشروع على GitHub
echo ===================================
echo.

set /p username="أدخل اسم المستخدم في GitHub: "
if "%username%"=="" (
    echo يجب إدخال اسم المستخدم
    pause
    exit /b 1
)

echo الخطوة 1: ربط Repository مع GitHub...
git remote add origin https://github.com/%username%/delivery-form-server.git
if %errorlevel% neq 0 (
    echo خطأ في ربط GitHub repository
    echo تأكد من إنشاء repository على GitHub أولاً
    pause
    exit /b 1
)

echo الخطوة 2: تعيين Branch الرئيسي...
git branch -M main
if %errorlevel% neq 0 (
    echo خطأ في تعيين branch
    pause
    exit /b 1
)

echo الخطوة 3: رفع الملفات على GitHub...
git push -u origin main
if %errorlevel% neq 0 (
    echo خطأ في رفع الملفات
    echo تأكد من صحة اسم المستخدم وأنك أنشأت repository
    pause
    exit /b 1
)

echo.
echo ===================================
echo تم رفع المشروع على GitHub بنجاح!
echo ===================================
echo.
echo رابط المشروع: https://github.com/%username%/delivery-form-server
echo.
echo الخطوة التالية: النشر على Vercel
echo 1. تسجيل الدخول على vercel.com
echo 2. اختيار Import Git Repository
echo 3. اختيار المشروع من GitHub
echo 4. النقر على Deploy
echo.
pause
