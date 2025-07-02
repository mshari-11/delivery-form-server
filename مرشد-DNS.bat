@echo off
chcp 65001 >nul
color 0E
cls

echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ 🎯 مرشد DNS التفاعلي - www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════╝

echo.
echo 🚀 سأوجهك خطوة بخطوة لإعداد DNS:
echo ══════════════════════════════════════════════════════════════════

echo.
echo 📋 ملخص ما ستفعله:
echo • إضافة A Record للدومين الرئيسي
echo • إضافة CNAME Record للنطاق الفرعي www
echo • حفظ التغييرات ومراقبة الانتشار

echo.
echo ══════════════════════════════════════════════════════════════════
echo.

echo 📝 DNS Records للنسخ:
echo.
echo 🔸 A Record:
echo    Type: A
echo    Name: @
echo    Value: 76.76.19.19
echo.
echo 🔸 CNAME Record:
echo    Type: CNAME
echo    Name: www
echo    Value: cname.vercel-dns.com

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 🌐 اختر عملية:
echo [1] نسخ A Record إلى الحافظة
echo [2] نسخ CNAME Record إلى الحافظة  
echo [3] فتح أدوات الاختبار
echo [4] عرض دليل مزودي النطاقات
echo [5] إنهاء
echo.
choice /C 12345 /N /M "اختر رقم: "

if %ERRORLEVEL%==1 (
    echo 76.76.19.19 | clip
    echo ✅ تم نسخ A Record Value إلى الحافظة!
    echo 📋 الصق في خانة "Value" للـ A Record
    echo.
    pause
)

if %ERRORLEVEL%==2 (
    echo cname.vercel-dns.com | clip
    echo ✅ تم نسخ CNAME Record Value إلى الحافظة!
    echo 📋 الصق في خانة "Value" للـ CNAME Record
    echo.
    pause
)

if %ERRORLEVEL%==3 (
    echo 🧪 فتح أدوات الاختبار...
    start https://www.whatsmydns.net/#A/firstlineon.com
    start https://www.whatsmydns.net/#CNAME/www.firstlineon.com
    start https://dnschecker.org/#A/firstlineon.com
)

if %ERRORLEVEL%==4 (
    cls
    echo ╔══════════════════════════════════════════════════════════════════╗
    echo ║ 📖 دليل مزودي النطاقات الشائعين ║
    echo ╚══════════════════════════════════════════════════════════════════╝
    echo.
    echo 🏢 Namecheap:
    echo    • اذهب إلى: Dashboard → Domain List
    echo    • اضغط "Manage" بجانب الدومين
    echo    • اختر "Advanced DNS"
    echo    • اضغط "Add New Record"
    echo.
    echo 🏢 GoDaddy:
    echo    • اذهب إلى: My Products → Domains
    echo    • اضغط "DNS" بجانب الدومين
    echo    • اضغط "Add" لإضافة record
    echo.
    echo 🏢 Cloudflare:
    echo    • اذهب إلى: Dashboard → Websites
    echo    • اختر الدومين
    echo    • اذهب إلى تبويب "DNS"
    echo    • اضغط "Add record"
    echo.
    echo 🏢 Google Domains:
    echo    • اذهب إلى: Domains → My domains
    echo    • اضغط "Manage" 
    echo    • اذهب إلى "DNS"
    echo    • اضغط "Manage custom records"
    echo.
    pause
)

if %ERRORLEVEL%==5 (
    echo 👋 نراك قريباً!
    exit
)

echo.
echo ══════════════════════════════════════════════════════════════════
echo 💡 تذكر: بعد إعداد DNS انتظر 30 دقيقة واختبر الموقع!
echo ══════════════════════════════════════════════════════════════════
echo.
pause
