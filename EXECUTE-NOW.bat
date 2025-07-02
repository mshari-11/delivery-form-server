@echo off
chcp 65001 >nul
color 0A
cls

echo ╔══════════════════════════════════════════════════════════════════════╗
echo ║ ⚡ التنفيذ الفوري الآن - www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════════╝

echo.
echo 🔥 تنفيذ العملية كاملة الآن...

:: خطوة 1: دفع للمستودع
echo 📤 دفع التحديثات الأخيرة...
git push origin main 2>nul

:: خطوة 2: فتح Vercel
echo 🌐 فتح Vercel Dashboard...
start https://vercel.com/mshari/delivery-form-mshari/settings/domains
timeout /t 3 >nul

:: خطوة 3: فتح مراقبة DNS
echo 🔍 فتح مراقبة DNS...
start https://www.whatsmydns.net/#A/firstlineon.com
timeout /t 2 >nul
start https://www.whatsmydns.net/#CNAME/www.firstlineon.com

:: خطوة 4: إنشاء ملفات الدعم
echo 📝 إنشاء ملفات الدعم...

echo A Record: @ = 76.76.19.19 > DNS-SETUP.txt
echo CNAME Record: www = cname.vercel-dns.com >> DNS-SETUP.txt

echo ✅ تم فتح جميع الأدوات!
echo.
echo 📋 الخطوات المطلوبة منك:
echo ────────────────────────────────────────────
echo 1. في Vercel Dashboard (المفتوح):
echo    • اضغط "Add Domain"
echo    • أدخل: firstlineon.com
echo    • أدخل: www.firstlineon.com
echo.
echo 2. في مزود النطاق:
echo    • أضف A Record: @ → 76.76.19.19
echo    • أضف CNAME: www → cname.vercel-dns.com
echo.
echo 3. انتظر 30 دقيقة واختبر:
echo    • https://www.firstlineon.com
echo.
echo 🔍 المراقبة: استخدم النوافذ المفتوحة لمتابعة انتشار DNS
echo.

:: اختبار سريع
echo 🧪 اختبار DNS الحالي:
nslookup firstlineon.com 8.8.8.8 2>nul | findstr "Address" || echo "❌ لم يتم إعداد DNS بعد"

echo.
echo 🎯 النتيجة المتوقعة: https://www.firstlineon.com
echo.
pause

:: اختبار الموقع
echo 🌐 اختبار الموقع...
start https://www.firstlineon.com

echo.
echo 🏆 العملية مكتملة! جميع الأدوات مفتوحة ومتاحة
pause
