@echo off
chcp 65001 >nul
color 0C
cls

echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ 🚨 الإعداد الفوري للدومين - URGENT SETUP                      ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo ⚡ تحديث: الدومين firstlineon.com غير مُعرَّف في DNS بعد
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🔥 المطلوب الآن - خطوات إجبارية:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 1️⃣ افتح Vercel Dashboard:
echo    🌐 https://vercel.com/dashboard
echo.
echo 2️⃣ اذهب إلى Settings → Domains
echo.
echo 3️⃣ أضف الدومين: www.firstlineon.com
echo.
echo 4️⃣ اختر إحدى الطريقتين:
echo.
echo    ┌─ الطريقة الأولى (السهلة) ─┐
echo    │ استخدام Vercel Nameservers │
echo    │ - تغيير NS في مزود النطاق │
echo    │ - نسخ nameservers من Vercel │
echo    └─────────────────────────────┘
echo.
echo    ┌─ الطريقة الثانية (اليدوية) ─┐
echo    │ استخدام A/CNAME Records     │
echo    │ - إضافة A record للجذر     │
echo    │ - إضافة CNAME للـ www       │
echo    └─────────────────────────────┘
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🎯 القيم المطلوبة للإعداد:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 🌐 Domain: firstlineon.com
echo 🌐 WWW: www.firstlineon.com
echo.
echo 📋 DNS Records المطلوبة (إذا اخترت الطريقة الثانية):
echo ─────────────────────────────────────────────────────────
echo   Type: A
echo   Name: @ (أو firstlineon.com)
echo   Value: 76.76.19.61 (أو القيمة من Vercel)
echo.
echo   Type: CNAME
echo   Name: www
echo   Value: cname.vercel-dns.com
echo ─────────────────────────────────────────────────────────
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🛠️ أدوات سريعة:
echo ═══════════════════════════════════════════════════════════════════════

echo.
echo [1] فتح Vercel Dashboard
echo [2] فتح أدوات DNS الخارجية
echo [3] بدء المراقبة التلقائية
echo [4] نسخ DNS Records إلى Clipboard
echo [5] فتح دليل الإعداد الكامل
echo [6] إنشاء Zone File تلقائياً
echo [7] اختبار حالة DNS الحالي
echo [0] خروج
echo.

set /p choice=اختر الرقم: 

if "%choice%"=="1" (
    echo 🌐 فتح Vercel Dashboard...
    start https://vercel.com/dashboard
    echo ✅ تم فتح Vercel Dashboard
    echo 💡 اذهب إلى Settings → Domains وأضف: www.firstlineon.com
    pause
    goto :menu
)

if "%choice%"=="2" (
    echo 🔍 فتح أدوات DNS الخارجية...
    start https://whatsmydns.net/#A/www.firstlineon.com
    start https://dnschecker.org/all-dns-records-of-domain.php?query=www.firstlineon.com
    echo ✅ تم فتح أدوات فحص DNS
    pause
    goto :menu
)

if "%choice%"=="3" (
    echo 🔄 بدء المراقبة التلقائية...
    call "مراقب-DNS-تلقائي.bat"
    goto :menu
)

if "%choice%"=="4" (
    echo 📋 نسخ DNS Records...
    echo A Record: @ → 76.76.19.61 | clip
    echo ✅ تم نسخ A Record إلى Clipboard
    echo.
    echo CNAME Record: www → cname.vercel-dns.com | clip
    echo ✅ تم نسخ CNAME Record إلى Clipboard
    echo.
    echo 💡 يمكنك الآن لصق القيم في لوحة DNS الخاصة بمزود النطاق
    pause
    goto :menu
)

if "%choice%"=="5" (
    echo 📖 فتح دليل الإعداد...
    start domain-setup-guide.md
    start "دليل-ربط-الدومين.md"
    echo ✅ تم فتح دلائل الإعداد
    pause
    goto :menu
)

if "%choice%"=="6" (
    echo 🔧 إنشاء Zone File...
    call إعداد-DNS-فوري.bat
    echo ✅ تم إنشاء Zone File
    pause
    goto :menu
)

if "%choice%"=="7" (
    echo 🔍 اختبار DNS الحالي...
    call check-domain-status.bat
    pause
    goto :menu
)

if "%choice%"=="0" (
    echo 👋 شكراً لك! أكمل إعداد DNS واستخدم المراقب التلقائي
    pause
    exit
)

:menu
echo.
echo ════════════════════════════════════════════════════════════════════════
echo اختر خياراً آخر أو اضغط 0 للخروج:
goto :start

pause
