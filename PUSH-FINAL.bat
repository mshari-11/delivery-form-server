https://delivery-form-mshari.vercel.app/login
https://delivery-form-mshari.vercel.app/login.html@echo off
chcp 65001 >nul
color 0A
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║         🚀 دفع إصلاحات مشكلة 404 إلى GitHub          ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📊 التحقق من الحالة الحالية...
echo ────────────────────────────────────────────────
git status --short

echo.
echo 📊 الـ Commits الجاهزة للدفع (إن وجدت):
echo ────────────────────────────────────────────────
git log origin/main..HEAD --oneline 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo لا توجد commits جديدة للدفع
)

echo.
echo ════════════════════════════════════════════════════════
echo.

REM التحقق من وجود تغييرات غير محفوظة
git diff-index --quiet HEAD -- 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  يوجد تغييرات غير محفوظة!
    echo.
    echo 💾 حفظ التغييرات...
    git add .
    git commit -m "🔧 إصلاح نهائي لمشكلة routing - تحديث vercel.json"
    echo.
)

echo 🔄 بدء عملية الدفع...
echo.

echo 📤 دفع التغييرات إلى GitHub...
git push origin main

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ تم الدفع بنجاح!
    echo.
    echo 🌐 Vercel سيبدأ في البناء تلقائياً...
    echo.
    echo ⏱️  انتظر 1-2 دقيقة ثم اختبر الروابط:
    echo.
    echo 🔗 الصفحة الرئيسية:
    echo    https://delivery-form-mshari.vercel.app/
    echo.
    echo 🔗 تسجيل الدخول (المُصلحة):
    echo    https://delivery-form-mshari.vercel.app/login
    echo.
    echo 🔗 لوحة التحكم:
    echo    https://delivery-form-mshari.vercel.app/dashboard
    echo.
    echo 📊 متابعة البناء على Vercel:
    echo    https://vercel.com/dashboard
    echo.
    echo 💡 نصيحة: شغل test-after-push.bat بعد دقيقتين
) ELSE (
    echo.
    echo ❌ فشل الدفع!
    echo.
    echo 💡 حلول محتملة:
    echo.
    echo 1. استخدم GitHub Desktop
    echo 2. احصل على Personal Access Token من:
    echo    https://github.com/settings/tokens
    echo 3. استخدم VS Code
    echo.
    echo 📝 راجع setup-github-auth.bat للمساعدة
)

echo.
echo ════════════════════════════════════════════════════════
echo.
pause