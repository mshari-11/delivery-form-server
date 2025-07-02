@echo off
chcp 65001 >nul
color 0C
cls

echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🚨 DNS Records Update - القيم الصحيحة من Vercel Dashboard       ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 المشكلة: DNS Records في مزود النطاق لا تطابق قيم Vercel
echo ⚡ الحل: تحديث DNS Records بالقيم الصحيحة التالية:
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 📋 DNS Records المطلوبة حسب Vercel:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 🌐 A Record للدومين الأساسي:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: A
echo   Name: @ (أو firstlineon.com)
echo   Value: 216.15.011
echo.
echo 🌐 CNAME Record للـ www:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: CNAME  
echo   Name: www
echo   Value: f12f74b9a686d5cd.vercel-dns-016.com
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🛠️ خيارات سريعة:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo [1] نسخ A Record Value للـ Clipboard
echo [2] نسخ CNAME Record Value للـ Clipboard  
echo [3] نسخ جميع القيم
echo [4] فتح أدوات DNS الخارجية للتحقق
echo [5] بدء المراقبة التلقائية
echo [6] عرض دليل إعداد DNS
echo [0] خروج
echo.

set /p choice=اختر الرقم: 

if "%choice%"=="1" (
    echo 216.15.011 | clip
    echo ✅ تم نسخ A Record Value: 216.15.011
    echo 💡 يمكنك الآن لصقه في خانة Value للـ A Record
    pause
    goto :menu
)

if "%choice%"=="2" (
    echo f12f74b9a686d5cd.vercel-dns-016.com | clip
    echo ✅ تم نسخ CNAME Record Value: f12f74b9a686d5cd.vercel-dns-016.com
    echo 💡 يمكنك الآن لصقه في خانة Value للـ CNAME Record
    pause
    goto :menu
)

if "%choice%"=="3" (
    echo A Record: 216.15.011 | clip
    echo ✅ تم نسخ A Record Value
    timeout /t 2 /nobreak > nul
    echo f12f74b9a686d5cd.vercel-dns-016.com | clip
    echo ✅ تم نسخ CNAME Record Value
    echo.
    echo 📋 القيم منسوخة للـ Clipboard:
    echo    A Record: 216.15.011
    echo    CNAME: f12f74b9a686d5cd.vercel-dns-016.com
    pause
    goto :menu
)

if "%choice%"=="4" (
    echo 🔍 فتح أدوات التحقق من DNS...
    start https://whatsmydns.net/#A/firstlineon.com
    start https://whatsmydns.net/#CNAME/www.firstlineon.com
    start https://dnschecker.org/all-dns-records-of-domain.php?query=firstlineon.com
    echo ✅ تم فتح أدوات فحص DNS
    pause
    goto :menu
)

if "%choice%"=="5" (
    echo 🔄 بدء المراقبة التلقائية...
    start "DNS Monitor" "مراقب-النجاح-النهائي.bat"
    echo ✅ تم تشغيل المراقب التلقائي
    echo 💡 سيتحقق كل دقيقتين ويُعلمك عند النجاح
    pause
    goto :menu
)

if "%choice%"=="6" (
    echo 📖 فتح دلائل الإعداد...
    start notepad "DNS-UPDATE-REQUIRED.txt"
    start notepad "دليل-التنفيذ-النهائي.txt"
    echo ✅ تم فتح دلائل الإعداد
    pause
    goto :menu
)

if "%choice%"=="0" (
    echo 👋 تأكد من تحديث DNS Records واستخدم المراقب التلقائي!
    pause
    exit
)

:menu
echo.
echo ════════════════════════════════════════════════════════════════════════
echo اختر خياراً آخر أو اضغط 0 للخروج:
goto :start

:start
cls
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🚨 DNS Records Update - القيم الصحيحة من Vercel Dashboard       ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 المشكلة: DNS Records في مزود النطاق لا تطابق قيم Vercel
echo ⚡ الحل: تحديث DNS Records بالقيم الصحيحة التالية:
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 📋 DNS Records المطلوبة حسب Vercel:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 🌐 A Record للدومين الأساسي:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: A
echo   Name: @ (أو firstlineon.com)
echo   Value: 216.15.011
echo.
echo 🌐 CNAME Record للـ www:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: CNAME  
echo   Name: www
echo   Value: f12f74b9a686d5cd.vercel-dns-016.com
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🛠️ خيارات سريعة:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo [1] نسخ A Record Value للـ Clipboard
echo [2] نسخ CNAME Record Value للـ Clipboard  
echo [3] نسخ جميع القيم
echo [4] فتح أدوات DNS الخارجية للتحقق
echo [5] بدء المراقبة التلقائية
echo [6] عرض دليل إعداد DNS
echo [0] خروج
echo.

set /p choice=اختر الرقم: 
goto :process_choice

:process_choice
if "%choice%"=="1" (
    echo 216.15.011 | clip
    echo ✅ تم نسخ A Record Value: 216.15.011
    echo 💡 يمكنك الآن لصقه في خانة Value للـ A Record
    pause
    goto :start
)

if "%choice%"=="2" (
    echo f12f74b9a686d5cd.vercel-dns-016.com | clip
    echo ✅ تم نسخ CNAME Record Value: f12f74b9a686d5cd.vercel-dns-016.com
    echo 💡 يمكنك الآن لصقه في خانة Value للـ CNAME Record
    pause
    goto :start
)

if "%choice%"=="3" (
    echo A Record: 216.15.011 | clip
    echo ✅ تم نسخ A Record Value
    timeout /t 2 /nobreak > nul
    echo f12f74b9a686d5cd.vercel-dns-016.com | clip
    echo ✅ تم نسخ CNAME Record Value
    echo.
    echo 📋 القيم منسوخة للـ Clipboard:
    echo    A Record: 216.15.011
    echo    CNAME: f12f74b9a686d5cd.vercel-dns-016.com
    pause
    goto :start
)

if "%choice%"=="4" (
    echo 🔍 فتح أدوات التحقق من DNS...
    start https://whatsmydns.net/#A/firstlineon.com
    start https://whatsmydns.net/#CNAME/www.firstlineon.com
    start https://dnschecker.org/all-dns-records-of-domain.php?query=firstlineon.com
    echo ✅ تم فتح أدوات فحص DNS
    pause
    goto :start
)

if "%choice%"=="5" (
    echo 🔄 بدء المراقبة التلقائية...
    start "DNS Monitor" "مراقب-النجاح-النهائي.bat"
    echo ✅ تم تشغيل المراقب التلقائي
    echo 💡 سيتحقق كل دقيقتين ويُعلمك عند النجاح
    pause
    goto :start
)

if "%choice%"=="6" (
    echo 📖 فتح دلائل الإعداد...
    start notepad "DNS-UPDATE-REQUIRED.txt"
    start notepad "دليل-التنفيذ-النهائي.txt"
    echo ✅ تم فتح دلائل الإعداد
    pause
    goto :start
)

if "%choice%"=="0" (
    echo 👋 تأكد من تحديث DNS Records واستخدم المراقب التلقائي!
    pause
    exit
)

goto :start
