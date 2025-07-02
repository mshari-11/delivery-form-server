@echo off
chcp 65001 >nul
color 0C
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║   🚨 دفع عاجل - حل نهائي لمشكلة 404                 ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📊 لديك الآن commit جديد جاهز للدفع:
echo    "إضافة ملفات إعادة توجيه لحل مشكلة 404 نهائياً"
echo.
echo ✅ التحديثات تتضمن:
echo    - مجلدات إعادة توجيه (dashboard/ و login/)
echo    - ملفات مساعدة للاختبار
echo    - صفحة روابط سريعة HTML
echo.
echo ════════════════════════════════════════════════════════
echo.

echo 📤 محاولة دفع التغييرات...
git push origin main

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 نجح الدفع!
    echo.
    echo ⏱️ انتظر 2 دقيقة ثم جرب:
    echo.
    echo ✅ https://delivery-form-mshari.vercel.app/login
    echo ✅ https://delivery-form-server-54sv.vercel.app/login
    echo.
    echo 🔗 أو افتح روابط-سريعة.html في المتصفح
) ELSE (
    echo.
    echo ⚠️ استخدم إحدى هذه الطرق للدفع:
    echo.
    echo 1️⃣ GitHub Desktop (الأسهل)
    echo    - افتح البرنامج
    echo    - اضغط Push origin
    echo.
    echo 2️⃣ VS Code
    echo    - Ctrl+Shift+G
    echo    - Sync Changes
    echo.
    echo 3️⃣ Personal Access Token
    echo    - https://github.com/settings/tokens
    echo    - Username: mshari-11
    echo    - Password: [الـ token]
)

echo.
echo ════════════════════════════════════════════════════════
echo.
pause