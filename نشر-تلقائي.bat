@echo off
echo ======================================
echo نشر مشروع شركة الخط الأول على GitHub
echo ======================================
echo.

echo الخطوة 1: إكمال Git commit...
git commit -m "v2.1.0 - Enhanced icons and permissions system"

echo.
echo الخطوة 2: إنشاء branch رئيسي...
git branch -M main

echo.
echo ======================================
echo تم إعداد Git بنجاح!
echo ======================================
echo.
echo الخطوات التالية:
echo 1. اذهب إلى github.com وسجل دخول
echo 2. اضغط على "+" في الأعلى واختر "New repository" 
echo 3. اسم Repository: delivery-form-server
echo 4. اختر Public واضغط "Create repository"
echo 5. انسخ رابط الـ repository من الصفحة
echo 6. ارجع هنا واضغط أي مفتاح للمتابعة...
echo.
pause

echo.
set /p repo_url="الصق رابط الـ repository هنا: "

echo.
echo الخطوة 3: ربط مع GitHub...
git remote add origin %repo_url%

echo.
echo الخطوة 4: رفع الملفات...
git push -u origin main

echo.
echo ======================================
echo تم رفع المشروع على GitHub بنجاح!
echo ======================================
echo.
echo للنشر على Vercel:
echo 1. اذهب إلى vercel.com
echo 2. سجل دخول بـ GitHub  
echo 3. اضغط "New Project"
echo 4. اختر delivery-form-server
echo 5. اضغط "Deploy"
echo.
echo رابط المشروع: %repo_url%
echo.
pause
