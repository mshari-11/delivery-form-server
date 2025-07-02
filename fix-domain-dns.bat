@echo off
chcp 65001 >nul
color 0E
cls

echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ 🔧 حل مشكلة DNS للدومين: www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════╝

echo.
echo 🚨 تم اكتشاف: DNS_PROBE_FINISHED_NXDOMAIN
echo.
echo هذا يعني أن DNS Records لم يتم إعدادها بعد أو لم تنتشر
echo ══════════════════════════════════════════════════════════════════

echo.
echo 🔍 الحلول المطلوبة:
echo.
echo 1️⃣ التأكد من إعداد Vercel:
echo    ✓ فتح Vercel Dashboard
start https://vercel.com/mshari/delivery-form-mshari/settings/domains
timeout /t 2 >nul

echo    ✓ إضافة الدومين: firstlineon.com
echo    ✓ إضافة النطاق الفرعي: www.firstlineon.com

echo.
echo 2️⃣ إعداد DNS في مزود النطاق:
echo    ✓ فتح لوحة تحكم مزود النطاق
echo.
echo 📋 DNS Records المطلوبة:
echo ────────────────────────────────────────
echo Type: A
echo Name: @
echo Value: 76.76.19.19
echo TTL: Auto
echo.
echo Type: CNAME
echo Name: www
echo Value: cname.vercel-dns.com
echo TTL: Auto
echo ────────────────────────────────────────

echo.
echo 3️⃣ فحص DNS الحالي:
echo    ✓ فتح أداة فحص DNS العالمية
start https://www.whatsmydns.net/#A/firstlineon.com
timeout /t 2 >nul
start https://www.whatsmydns.net/#CNAME/www.firstlineon.com

echo.
echo 4️⃣ اختبار بديل:
echo    ✓ الموقع الحالي يعمل على: 
echo      https://delivery-form-mshari.vercel.app
start https://delivery-form-mshari.vercel.app

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo ⏱️ الوقت المتوقع للإصلاح:
echo    • بعد إعداد DNS: 10-30 دقيقة
echo    • الانتشار العالمي: حتى 24 ساعة
echo.
echo 💡 نصائح:
echo    • تأكد من صحة DNS Records
echo    • استخدم الموقع الأساسي حالياً
echo    • أعد المحاولة بعد ساعة
echo.
echo هل تريد نسخ DNS Records إلى الحافظة؟ (Y/N)
choice /C YN /N
if %ERRORLEVEL%==1 (
    echo A Record: @ = 76.76.19.19 | clip
    echo ✅ تم نسخ A Record!
    timeout /t 2 >nul
    echo CNAME Record: www = cname.vercel-dns.com | clip
    echo ✅ تم نسخ CNAME Record!
)

echo.
pause
