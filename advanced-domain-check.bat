@echo off
chcp 65001 >nul
color 0A
cls

echo ╔════════════════════════════════════════════════════════════════════╗
echo ║ 🔍 التحقق المتقدم من DNS - حسب دليل Vercel الرسمي ║
echo ╚════════════════════════════════════════════════════════════════════╝

echo.
echo 📋 فحص شامل للدومين: www.firstlineon.com
echo ════════════════════════════════════════════════════════════════════

echo.
echo 1️⃣ فحص DNS Authority الحالي:
echo ──────────────────────────────────────
dig NS firstlineon.com +short 2>nul || (
    echo ❌ لم يتم العثور على NS records
    nslookup -type=NS firstlineon.com 2>nul | findstr "nameserver"
)

echo.
echo 2️⃣ فحص A Record للدومين الرئيسي:
echo ──────────────────────────────────────
dig A firstlineon.com +short 2>nul || (
    echo 🔍 استخدام nslookup...
    nslookup -type=A firstlineon.com 8.8.8.8 2>nul | findstr "Address"
)

echo.
echo 3️⃣ فحص CNAME للنطاق الفرعي:
echo ──────────────────────────────────────
dig CNAME www.firstlineon.com +short 2>nul || (
    echo 🔍 استخدام nslookup...
    nslookup -type=CNAME www.firstlineon.com 8.8.8.8 2>nul | findstr "canonical"
)

echo.
echo 4️⃣ فحص DNS من Vercel (إذا كان مُعد):
echo ──────────────────────────────────────
dig A firstlineon.com +short @ns1.vercel-dns.com 2>nul || (
    echo ⏳ لم يتم إعداد Vercel DNS بعد
)

echo.
echo 5️⃣ اختبار الاتصال بالموقع:
echo ──────────────────────────────────────
curl -I https://www.firstlineon.com --connect-timeout 10 2>nul | findstr "HTTP" || (
    echo ⏳ الموقع غير متاح بعد
)

echo.
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🛠️ أدوات إضافية:
echo [1] فحص انتشار DNS عالمياً
echo [2] مقارنة مع DNS providers أخرى
echo [3] اختبار SSL Certificate
echo [4] عرض معلومات الدومين الكاملة
echo [5] تشغيل اختبار شامل
echo [6] الخروج
echo.
choice /C 123456 /N /M "اختر رقم: "

if %ERRORLEVEL%==1 (
    echo 🌐 فتح أدوات فحص DNS العالمية...
    start https://www.whatsmydns.net/#A/firstlineon.com
    start https://www.whatsmydns.net/#CNAME/www.firstlineon.com
    start https://dnschecker.org/#A/firstlineon.com
)

if %ERRORLEVEL%==2 (
    echo 🔍 مقارنة DNS providers...
    echo.
    echo Google DNS:
    nslookup firstlineon.com 8.8.8.8 2>nul | findstr "Address"
    echo.
    echo Cloudflare DNS:
    nslookup firstlineon.com 1.1.1.1 2>nul | findstr "Address"
    echo.
    pause
)

if %ERRORLEVEL%==3 (
    echo 🔒 اختبار SSL Certificate...
    echo.
    curl -I https://www.firstlineon.com --connect-timeout 10 2>nul || (
        echo ❌ SSL غير متاح أو الموقع غير متاح
    )
    echo.
    pause
)

if %ERRORLEVEL%==4 (
    echo 📊 معلومات الدومين الكاملة...
    echo.
    echo A Records:
    nslookup -type=A firstlineon.com 2>nul
    echo.
    echo CNAME Records:
    nslookup -type=CNAME www.firstlineon.com 2>nul
    echo.
    echo NS Records:
    nslookup -type=NS firstlineon.com 2>nul
    echo.
    pause
)

if %ERRORLEVEL%==5 (
    echo 🔄 تشغيل اختبار شامل...
    call auto-test-domain.bat
)

if %ERRORLEVEL%==6 (
    echo 👋 شكراً لك!
    exit
)

echo.
echo ════════════════════════════════════════════════════════════════════
echo 💡 نصائح:
echo    • انتظر 10-30 دقيقة بعد إعداد DNS
echo    • تحقق من Vercel Dashboard للحالة
echo    • استخدم أدوات الفحص العالمية للتأكد
echo ════════════════════════════════════════════════════════════════════
echo.
pause
