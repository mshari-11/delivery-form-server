@echo off
chcp 65001 >nul
color 0E
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║       🔍 فحص شامل لإصلاحات مشكلة 404                ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📊 فحص الملفات المطلوبة...
echo ════════════════════════════════════════════════════════

echo.
echo ✅ فحص vercel.json...
if exist vercel.json (
    echo    ✓ موجود
    type vercel.json | findstr /C:"public/login.html" >nul
    if %ERRORLEVEL% EQU 0 (
        echo    ✓ يحتوي على إعدادات public الصحيحة
    ) else (
        echo    ⚠️ قد يحتاج تحديث للإشارة إلى public
    )
) else (
    echo    ❌ غير موجود!
)

echo.
echo ✅ فحص public/_redirects...
if exist public\_redirects (
    echo    ✓ موجود
) else (
    echo    ❌ غير موجود!
)

echo.
echo ✅ فحص netlify.toml...
if exist netlify.toml (
    echo    ✓ موجود
) else (
    echo    ⚠️ غير موجود (اختياري)
)

echo.
echo ✅ فحص مجلدات إعادة التوجيه...
if exist dashboard\index.html (
    echo    ✓ dashboard/index.html موجود
) else (
    echo    ❌ dashboard/index.html غير موجود!
)

if exist login\index.html (
    echo    ✓ login/index.html موجود
) else (
    echo    ❌ login/index.html غير موجود!
)

echo.
echo ════════════════════════════════════════════════════════
echo.
echo 🌐 اختبار الروابط الحالية...
echo ════════════════════════════════════════════════════════

echo.
echo 📌 الموقع الأول:
echo    https://delivery-form-mshari.vercel.app/login
echo    https://delivery-form-mshari.vercel.app/dashboard

echo.
echo 📌 الموقع الثاني:
echo    https://delivery-form-server-54sv.vercel.app/login
echo    https://delivery-form-server-54sv.vercel.app/dashboard

echo.
echo ════════════════════════════════════════════════════════
echo.
echo 💡 الحلول المتاحة:
echo ════════════════════════════════════════════════════════

echo.
echo 1. إذا كانت الروابط لا تعمل بدون .html:
echo    - استخدم FORCE-REDEPLOY.bat لإعادة النشر
echo    - أو ادفع التغييرات الجديدة إلى GitHub
echo.
echo 2. في هذه الأثناء، استخدم:
echo    - login.html بدلاً من login
echo    - dashboard.html بدلاً من dashboard
echo.
echo 3. أو افتح quick-access.html للوصول السريع
echo.

pause