@echo off
chcp 65001 >nul
color 0C
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║     🔄 إعادة نشر قوية مع مسح الذاكرة المؤقتة        ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📊 الخطوات التي سيتم تنفيذها:
echo ════════════════════════════════════════════════════════
echo.
echo 1. إضافة جميع التغييرات الجديدة
echo 2. عمل commit بوصف واضح
echo 3. دفع التغييرات إلى GitHub
echo 4. إجبار Vercel على إعادة البناء
echo.
echo ⚠️  تأكد من أن لديك:
echo    - اتصال بالإنترنت
echo    - حساب GitHub مفعل
echo    - وصول لـ Vercel Dashboard
echo.
echo ════════════════════════════════════════════════════════
echo.

pause

echo.
echo 📦 إضافة جميع التغييرات...
git add -A

echo.
echo 💾 حفظ التغييرات...
git commit -m "🔧 FORCE REDEPLOY - إصلاح نهائي لمشكلة 404 مع إعدادات محسنة

- تحديث vercel.json بإعدادات redirects و rewrites
- إضافة public/_redirects
- إضافة netlify.toml كطبقة حماية إضافية
- تحديث dashboard/index.html و login/index.html
- إضافة أدوات فحص وصفحة وصول سريع"

echo.
echo 📤 دفع التغييرات إلى GitHub...
git push origin main --force-with-lease

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ تم دفع التغييرات بنجاح!
    echo.
    echo ════════════════════════════════════════════════════════
    echo.
    echo 🚀 الخطوات التالية في Vercel:
    echo ════════════════════════════════════════════════════════
    echo.
    echo 1. افتح: https://vercel.com/dashboard
    echo.
    echo 2. اختر المشروع: delivery-form-server
    echo.
    echo 3. اذهب إلى Settings > Functions
    echo.
    echo 4. اضغط على "Redeploy"
    echo.
    echo 5. اختر: "Redeploy with existing Build Cache cleared"
    echo.
    echo 6. انتظر 2-3 دقائق لاكتمال البناء
    echo.
    echo ════════════════════════════════════════════════════════
    echo.
    echo 🧪 بعد اكتمال البناء، اختبر:
    echo.
    echo ✅ https://delivery-form-server-54sv.vercel.app/login
    echo ✅ https://delivery-form-server-54sv.vercel.app/dashboard
    echo.
    echo أو افتح quick-access.html في المتصفح
) ELSE (
    echo.
    echo ❌ فشل الدفع!
    echo.
    echo 💡 جرب:
    echo    1. GitHub Desktop
    echo    2. VS Code > Source Control
    echo    3. Personal Access Token
    echo.
    echo أو شغل: setup-github-auth.bat
)

echo.
echo ════════════════════════════════════════════════════════
echo.
echo 💡 نصيحة: إذا استمرت المشكلة، جرب:
echo.
echo 1. حذف المشروع من Vercel وإعادة ربطه
echo 2. استخدام نطاق مخصص
echo 3. التواصل مع دعم Vercel
echo.
pause