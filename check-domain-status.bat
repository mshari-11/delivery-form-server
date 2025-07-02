@echo off
chcp 65001 >nul
color 0C
cls

echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ 📊 فحص حالة ربط الدومين: www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════╝

echo.
echo 🔍 جاري فحص حالة الدومين...
echo ══════════════════════════════════════════════════════════════════

echo.
echo 1️⃣ اختبار الدومين الرئيسي:
ping -n 1 firstlineon.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    ✅ firstlineon.com - متاح
) else (
    echo    ❌ firstlineon.com - غير متاح بعد
)

echo.
echo 2️⃣ اختبار النطاق الفرعي:
ping -n 1 www.firstlineon.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    ✅ www.firstlineon.com - متاح
) else (
    echo    ❌ www.firstlineon.com - غير متاح بعد
)

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 📋 الحالة الحالية:
type DOMAIN-STATUS.txt

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 🛠️ إجراءات سريعة:
echo.
echo [1] فتح Vercel Dashboard
echo [2] فتح أداة فحص DNS
echo [3] اختبار الروابط
echo [4] عرض DNS Records
echo [5] الخروج
echo.
choice /C 12345 /N /M "اختر رقم: "

if %ERRORLEVEL%==1 (
    echo.
    echo 🌐 فتح Vercel Dashboard...
    start https://vercel.com/mshari/delivery-form-mshari/settings/domains
)

if %ERRORLEVEL%==2 (
    echo.
    echo 🔍 فتح أداة فحص DNS...
    start https://www.whatsmydns.net/#A/firstlineon.com
    start https://www.whatsmydns.net/#CNAME/www.firstlineon.com
)

if %ERRORLEVEL%==3 (
    echo.
    echo 🧪 اختبار الروابط...
    call test-domain.bat
)

if %ERRORLEVEL%==4 (
    echo.
    echo 📋 عرض DNS Records...
    type DNS-records.txt
    echo.
    pause
)

if %ERRORLEVEL%==5 (
    echo.
    echo 👋 شكراً لك!
    exit
)

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
