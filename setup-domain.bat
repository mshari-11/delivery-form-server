@echo off
chcp 65001 >nul
color 0B
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║ 🌐 ربط الدومين المخصص: www.firstlineon.com ║
echo ╚═══════════════════════════════════════════════════════════════╝

echo.
echo 📋 الخطوات المطلوبة:
echo ═══════════════════════════════════════════════════════════════

echo.
echo 1️⃣ فتح Vercel Dashboard:
start https://vercel.com/dashboard

echo.
echo 2️⃣ اختيار المشروع:
echo    البحث عن: delivery-form-mshari
echo    أو البحث عن: delivery-form-server

echo.
echo 3️⃣ إعدادات الدومين:
echo    • اضغط على المشروع
echo    • اذهب إلى: Settings → Domains
echo    • اضغط: Add Domain

echo.
echo 4️⃣ إدخال الدومين:
echo    • اكتب: firstlineon.com
echo    • اكتب: www.firstlineon.com
echo    • اضغط: Add

echo.
echo 5️⃣ نسخ إعدادات DNS:
echo    Vercel سيعطيك DNS records للنسخ
echo    أو استخدم هذه القيم الجاهزة:
echo.
echo    A Record:     @ → 76.76.19.19
echo    CNAME Record: www → cname.vercel-dns.com

echo.
echo 6️⃣ فتح أدوات مساعدة:
start domain-test.html
timeout /t 2 >nul
start https://www.whatsmydns.net/#A/firstlineon.com

echo.
echo ════════════════════════════════════════════════════════════════
echo.
echo 📌 تم فتح:
echo    ✅ Vercel Dashboard (لإضافة الدومين)
echo    ✅ صفحة اختبار الدومين (للمتابعة)
echo    ✅ أداة فحص DNS (للتحقق)
echo.
echo 💡 نصيحة: أضف الدومين في Vercel أولاً، ثم أضف DNS Records
echo.
pause

echo.
echo ⏭️  الخطوة التالية:
echo    بعد إعداد DNS، اضغط Enter للاختبار...
pause

echo.
echo 🧪 اختبار الاتصال بالدومين...
echo ═══════════════════════════════════════════════════════════════

echo 🌐 محاولة الوصول إلى: www.firstlineon.com
ping -n 1 www.firstlineon.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ تم! الدومين يستجيب
    echo.
    echo 🚀 فتح الموقع الجديد...
    start https://www.firstlineon.com
    start https://www.firstlineon.com/login
) else (
    echo ⏳ لا يزال قيد الانتشار...
    echo    جرب مرة أخرى خلال 10-30 دقيقة
)

echo.
echo ════════════════════════════════════════════════════════════════
pause
