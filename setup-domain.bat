
@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════════════╗
echo ║   🌐 إعداد الدومين المخصص firstlineon.com  ║
echo ╚════════════════════════════════════════════╝
echo.
echo 📌 الخطوات المطلوبة:
echo.
echo 1️⃣ إضافة DNS Records في لوحة تحكم الدومين:
echo    • A Record: @ → 76.76.19.19
echo    • CNAME: www → cname.vercel-dns.com
echo    • CAA: @ → 0 issue "letsencrypt.org"
echo.
echo 2️⃣ إضافة الدومين في Vercel Dashboard:
echo    • افتح: https://vercel.com/mshari/delivery-form-mshari/settings/domains
echo    • اضغط "Add Domain"
echo    • أدخل: www.firstlineon.com
echo    • اتبع التعليمات
echo.
echo 3️⃣ انتظر 5-10 دقائق للتفعيل
echo.
echo ─────────────────────────────────────────────
echo.
echo هل تريد فتح Vercel Dashboard الآن؟ (Y/N)
choice /C YN /N
if %ERRORLEVEL%==1 (
    echo.
    echo 🌐 جاري فتح Vercel Dashboard...
    start https://vercel.com/mshari/delivery-form-mshari/settings/domains
)
echo.
echo هل تريد نسخ DNS Records إلى الحافظة؟ (Y/N)
choice /C YN /N
if %ERRORLEVEL%==1 (
    echo A Record: @ → 76.76.19.19 | clip
    echo ✅ تم نسخ A Record إلى الحافظة!
    echo.
    pause
    echo CNAME: www → cname.vercel-dns.com | clip
    echo ✅ تم نسخ CNAME Record إلى الحافظة!
    echo.
    pause
    echo CAA: @ → 0 issue "letsencrypt.org" | clip
    echo ✅ تم نسخ CAA Record إلى الحافظة!
)
echo.
echo 📋 للمساعدة، افتح domain-setup-guide.md
echo.
pause
