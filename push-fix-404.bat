@echo off
chcp 65001 >nul
echo ========================================
echo دفع إصلاحات مشكلة 404 إلى GitHub
echo ========================================

echo.
echo التحقق من حالة Git...
git status --short

echo.
echo إضافة جميع التغييرات...
git add .

echo.
echo عمل Commit...
git commit -m "🐛 إصلاح مشكلة 404 في صفحة تسجيل الدخول - إزالة معالجات HTML وتحسين التوجيه"

echo.
echo دفع التغييرات إلى GitHub...
git push origin main

echo.
echo ========================================
echo ✅ تم دفع التغييرات بنجاح!
echo ========================================
echo.
echo Vercel سيحدث الموقع تلقائياً خلال 1-2 دقيقة
echo.
echo الروابط للتحقق:
echo - الصفحة الرئيسية: https://delivery-form-mshari.vercel.app/
echo - تسجيل الدخول: https://delivery-form-mshari.vercel.app/login
echo - لوحة التحكم: https://delivery-form-mshari.vercel.app/dashboard
echo.
echo افتح Vercel Dashboard للمتابعة:
echo https://vercel.com/dashboard
echo.
pause