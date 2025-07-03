@echo off
chcp 65001 >nul
color 0E
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║      🔧 إصلاح مشكلة 404 في كلا الموقعين             ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📌 الموقعان المتأثران:
echo    1. https://delivery-form-mshari.vercel.app/
echo    2. https://delivery-form-server-54sv.vercel.app/
echo.
echo ════════════════════════════════════════════════════════
echo.

echo ✅ الإصلاح جاهز في المشروع المحلي!
echo.
echo 📤 دفع الإصلاح إلى GitHub...
git push origin main

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ تم الدفع بنجاح!
    echo.
    echo 🔄 سيتم تحديث كلا الموقعين تلقائياً خلال 2 دقيقة
    echo.
    echo بعد التحديث ستعمل هذه الروابط:
    echo.
    echo 🌐 الموقع الأول:
    echo    https://delivery-form-mshari.vercel.app/login ✅
    echo    https://delivery-form-mshari.vercel.app/dashboard ✅
    echo.
    echo 🌐 الموقع الثاني:
    echo    https://delivery-form-server-54sv.vercel.app/login ✅
    echo    https://delivery-form-server-54sv.vercel.app/dashboard ✅
) ELSE (
    echo.
    echo ⚠️ تحتاج للمصادقة!
    echo.
    echo 💡 استخدم GitHub Desktop أو VS Code
    echo.
    echo أو احصل على Personal Access Token:
    echo https://github.com/settings/tokens
)

echo.
echo ════════════════════════════════════════════════════════
echo.
echo 📝 في هذه الأثناء، استخدم الروابط مع .html:
echo    - login.html بدلاً من login
echo    - dashboard.html بدلاً من dashboard
echo.
pause