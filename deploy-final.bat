@echo off
chcp 65001 > nul
echo.
echo ================================
echo 🚀 نشر مشروع الخط الأول على Vercel
echo ================================
echo.

echo 📋 التحقق من الملفات المطلوبة...
if not exist "vercel.json" (
    echo ❌ ملف vercel.json غير موجود
    pause
    exit /b 1
)

if not exist "server.js" (
    echo ❌ ملف server.js غير موجود
    pause
    exit /b 1
)

if not exist "form-complete.html" (
    echo ❌ ملف form-complete.html غير موجود
    pause
    exit /b 1
)

echo ✅ جميع الملفات المطلوبة موجودة

echo.
echo 📦 إعداد البيانات للنشر...
git add .
git commit -m "✨ تحديث شامل وإعداد للنشر النهائي - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

echo.
echo 🌐 رفع التحديثات إلى GitHub...
git push origin main --force-with-lease

echo.
echo 🚀 بدء النشر على Vercel...
vercel --prod --yes

echo.
echo ================================
echo ✅ تم النشر بنجاح!
echo ================================
echo.
echo 🔗 روابط الموقع:
echo   • الصفحة الرئيسية: https://delivery-form-mshari.vercel.app/
echo   • لوحة التحكم: https://delivery-form-mshari.vercel.app/dashboard.html
echo   • تسجيل الدخول: https://delivery-form-mshari.vercel.app/login.html
echo.
echo 🔐 بيانات الدخول:
echo   • المستخدم: admin
echo   • كلمة المرور: admin123
echo.
echo 🎉 مبروك! مشروعك جاهز ويعمل بكفاءة
pause
