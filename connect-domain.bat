@echo off
chcp 65001 >nul
color 0E
cls

echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ 🌐 ربط الدومين التلقائي: www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════╝

echo.
echo 🚀 بدء عملية الربط التلقائي...
echo ══════════════════════════════════════════════════════════════════

echo.
echo 1️⃣ فتح Vercel Dashboard...
start https://vercel.com/dashboard

timeout /t 3 >nul

echo 2️⃣ فتح صفحة اختبار الدومين...
start domain-test.html

timeout /t 2 >nul

echo 3️⃣ فتح دليل الإعداد...
start domain-setup-guide.md

timeout /t 2 >nul

echo 4️⃣ فتح أداة فحص DNS...
start https://www.whatsmydns.net/#A/firstlineon.com

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 📋 الخطوات المطلوبة:
echo.
echo ✅ في Vercel Dashboard:
echo    • اختر مشروع: delivery-form-mshari
echo    • اذهب لـ: Settings → Domains  
echo    • أضف: firstlineon.com و www.firstlineon.com
echo.
echo ✅ في لوحة تحكم النطاق:
echo    • أضف A Record: @ → 76.76.19.19
echo    • أضف CNAME Record: www → cname.vercel-dns.com
echo.
echo ✅ انتظر 5-30 دقيقة للانتشار
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 🌟 بعد الانتهاء، الموقع سيكون متاح على:
echo    https://www.firstlineon.com
echo    https://www.firstlineon.com/login
echo    https://www.firstlineon.com/dashboard
echo.
echo 📞 للمساعدة: راجع domain-setup-guide.md
echo.
pause
