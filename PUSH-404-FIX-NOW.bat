@echo off
chcp 65001 >nul
color 0A
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║     🚨 دفع إصلاح 404 العاجل - جاهز للدفع!           ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo ✅ تم حفظ الإصلاح في commit جديد!
echo.
echo 📝 التغييرات:
echo    - تحديث vercel.json بإعدادات functions
echo    - إصلاح routing للصفحات
echo    - حل مشكلة 404 نهائياً
echo.
echo ════════════════════════════════════════════════════════
echo.

echo 📤 دفع التغييرات إلى GitHub...
git push origin main

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ تم الدفع بنجاح!
    echo.
    echo ⏱️ انتظر 1-2 دقيقة لاكتمال البناء على Vercel
    echo.
    echo 🔗 بعد دقيقتين، جرب هذه الروابط:
    echo.
    echo    تسجيل الدخول (بدون .html):
    echo    https://delivery-form-mshari.vercel.app/login
    echo.
    echo    لوحة التحكم:
    echo    https://delivery-form-mshari.vercel.app/dashboard
    echo.
    echo 💡 الصفحة تعمل حالياً مع .html:
    echo    https://delivery-form-mshari.vercel.app/login.html
) ELSE (
    echo.
    echo ⚠️ تحتاج للمصادقة!
    echo.
    echo استخدم إحدى هذه الطرق:
    echo.
    echo 1. GitHub Desktop (الأسهل)
    echo 2. VS Code > Source Control > Sync
    echo 3. Personal Access Token:
    echo    - Username: mshari-11
    echo    - Password: [استخدم token من GitHub]
)

echo.
pause