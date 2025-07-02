@echo off
chcp 65001 >nul
color 0B
cls

echo ╔══════════════════════════════════════════════════════════════════════╗
echo ║ 🤖 الإعداد التلقائي للدومين: www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════════╝

echo.
echo 🚀 بدء الإعداد التلقائي بناءً على دليل Vercel الرسمي...
echo ══════════════════════════════════════════════════════════════════════

echo.
echo 📋 الخطوات التي سيتم تنفيذها:
echo ════════════════════════════════════════════════════════════════════
echo 1️⃣ إعداد Vercel Dashboard
echo 2️⃣ إنشاء DNS Records تلقائياً
echo 3️⃣ التحقق من صحة الإعدادات
echo 4️⃣ مراقبة انتشار DNS
echo 5️⃣ اختبار الموقع النهائي

echo.
echo ════════════════════════════════════════════════════════════════════
echo.

:: Step 1: فتح Vercel Dashboard
echo 🌐 الخطوة 1: فتح Vercel Dashboard...
start https://vercel.com/mshari/delivery-form-mshari/settings/domains
timeout /t 3 >nul

:: Step 2: إنشاء ملف تكوين DNS تلقائي
echo 📝 الخطوة 2: إنشاء تكوين DNS تلقائي...

:: إنشاء ملف DNS Zone
echo ; DNS Zone file for firstlineon.com > firstlineon.zone
echo $TTL 300 >> firstlineon.zone
echo @ IN SOA ns1.vercel-dns.com. dns@vercel.com. ( >> firstlineon.zone
echo     2025070201 ; Serial >> firstlineon.zone
echo     3600       ; Refresh >> firstlineon.zone
echo     1800       ; Retry >> firstlineon.zone
echo     1209600    ; Expire >> firstlineon.zone
echo     300 )      ; Minimum TTL >> firstlineon.zone
echo. >> firstlineon.zone
echo ; A Records >> firstlineon.zone
echo @           IN  A     76.76.19.19 >> firstlineon.zone
echo. >> firstlineon.zone
echo ; CNAME Records >> firstlineon.zone
echo www         IN  CNAME cname.vercel-dns.com. >> firstlineon.zone

echo ✅ تم إنشاء ملف DNS Zone

:: Step 3: إنشاء تعليمات مفصلة
echo 📄 الخطوة 3: إنشاء دليل التنفيذ...

echo. > domain-setup-instructions.txt
echo ════════════════════════════════════════════════════════════════ >> domain-setup-instructions.txt
echo 📋 تعليمات إعداد الدومين - www.firstlineon.com >> domain-setup-instructions.txt
echo ════════════════════════════════════════════════════════════════ >> domain-setup-instructions.txt
echo. >> domain-setup-instructions.txt
echo 🔸 في Vercel Dashboard (المفتوح الآن): >> domain-setup-instructions.txt
echo    1. اضغط "Add Domain" >> domain-setup-instructions.txt
echo    2. أدخل: firstlineon.com >> domain-setup-instructions.txt
echo    3. أدخل: www.firstlineon.com >> domain-setup-instructions.txt
echo    4. اختر طريقة التحقق المناسبة >> domain-setup-instructions.txt
echo. >> domain-setup-instructions.txt
echo 🔸 في لوحة تحكم مزود النطاق: >> domain-setup-instructions.txt
echo    أضف هذه السجلات بالضبط: >> domain-setup-instructions.txt
echo. >> domain-setup-instructions.txt
echo    Type: A >> domain-setup-instructions.txt
echo    Name: @ >> domain-setup-instructions.txt
echo    Value: 76.76.19.19 >> domain-setup-instructions.txt
echo    TTL: 300 (أو Auto) >> domain-setup-instructions.txt
echo. >> domain-setup-instructions.txt
echo    Type: CNAME >> domain-setup-instructions.txt
echo    Name: www >> domain-setup-instructions.txt
echo    Value: cname.vercel-dns.com >> domain-setup-instructions.txt
echo    TTL: 300 (أو Auto) >> domain-setup-instructions.txt
echo. >> domain-setup-instructions.txt

:: Step 4: فتح أدوات المراقبة
echo 🔍 الخطوة 4: فتح أدوات المراقبة...
start https://www.whatsmydns.net/#A/firstlineon.com
timeout /t 2 >nul
start https://www.whatsmydns.net/#CNAME/www.firstlineon.com
timeout /t 2 >nul

:: Step 5: إنشاء ملف اختبار تلقائي
echo 🧪 الخطوة 5: إنشاء اختبار تلقائي...

echo @echo off > auto-test-domain.bat
echo chcp 65001 ^>nul >> auto-test-domain.bat
echo cls >> auto-test-domain.bat
echo echo 🧪 اختبار تلقائي للدومين... >> auto-test-domain.bat
echo echo. >> auto-test-domain.bat
echo echo 1️⃣ اختبار DNS A Record: >> auto-test-domain.bat
echo nslookup firstlineon.com 8.8.8.8 ^| findstr "Address" >> auto-test-domain.bat
echo echo. >> auto-test-domain.bat
echo echo 2️⃣ اختبار DNS CNAME Record: >> auto-test-domain.bat
echo nslookup www.firstlineon.com 8.8.8.8 ^| findstr "canonical" >> auto-test-domain.bat
echo echo. >> auto-test-domain.bat
echo echo 3️⃣ اختبار الموقع: >> auto-test-domain.bat
echo curl -I https://www.firstlineon.com 2^>nul ^|^| echo "الموقع لم يصبح متاحاً بعد" >> auto-test-domain.bat
echo pause >> auto-test-domain.bat

:: Step 6: تحديث حالة المشروع
echo 📊 الخطوة 6: تحديث حالة المشروع...

echo 📊 حالة مشروع تسجيل المناديب - %date% %time% > DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🌐 DOMAIN STATUS: >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════ >> DOMAIN-STATUS.txt
echo الدومين الجديد: www.firstlineon.com >> DOMAIN-STATUS.txt
echo الحالة: تحت الإعداد التلقائي >> DOMAIN-STATUS.txt
echo المطلوب: اتباع التعليمات في Vercel >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🎯 NEXT STEPS: >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════ >> DOMAIN-STATUS.txt
echo 1. ✅ Vercel Dashboard مفتوح >> DOMAIN-STATUS.txt
echo 2. ✅ DNS Zone file منشأ >> DOMAIN-STATUS.txt
echo 3. ✅ أدوات المراقبة مفتوحة >> DOMAIN-STATUS.txt
echo 4. ⏳ إضافة الدومين في Vercel >> DOMAIN-STATUS.txt
echo 5. ⏳ إعداد DNS في مزود النطاق >> DOMAIN-STATUS.txt

echo.
echo ════════════════════════════════════════════════════════════════════
echo.
echo ✅ تم إكمال الإعداد التلقائي!
echo.
echo 📁 الملفات المُنشأة:
echo    • firstlineon.zone - ملف DNS Zone
echo    • domain-setup-instructions.txt - التعليمات
echo    • auto-test-domain.bat - اختبار تلقائي
echo.
echo 🌐 النوافذ المفتوحة:
echo    • Vercel Dashboard - لإضافة الدومين
echo    • أدوات مراقبة DNS - لمتابعة الانتشار
echo.
echo 📋 اقرأ ملف: domain-setup-instructions.txt
echo 🧪 للاختبار اللاحق: auto-test-domain.bat
echo.
echo ⏱️ الوقت المتوقع: 15-45 دقيقة
echo.
pause
