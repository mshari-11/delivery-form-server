@echo off
chcp 65001 >nul
color 0A
cls

echo ╔══════════════════════════════════════════════════════════════╗
echo ║ 🧪 اختبار سريع للدومين: www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════╝

echo.
echo 🔍 فحص حالة الدومين...
echo ═══════════════════════════════════════════════════════════

echo.
echo 1️⃣ فحص DNS للدومين الرئيسي:
nslookup firstlineon.com 2>nul | find "Address:" && (
    echo ✅ firstlineon.com - يعمل
) || (
    echo ⏳ firstlineon.com - لا يزال قيد الانتشار
)

echo.
echo 2️⃣ فحص DNS للنطاق الفرعي:
nslookup www.firstlineon.com 2>nul | find "Address:" && (
    echo ✅ www.firstlineon.com - يعمل
) || (
    echo ⏳ www.firstlineon.com - لا يزال قيد الانتشار
)

echo.
echo 3️⃣ فحص الاتصال:
ping -n 1 www.firstlineon.com >nul 2>&1 && (
    echo ✅ الدومين يستجيب للـ ping
) || (
    echo ⏳ الدومين لا يستجيب بعد
)

echo.
echo ═══════════════════════════════════════════════════════════
echo.

echo 🌐 اختبار الروابط:
echo.

echo 📍 محاولة فتح الموقع الرئيسي...
start https://www.firstlineon.com
timeout /t 2 >nul

echo 📍 محاولة فتح صفحة تسجيل الدخول...
start https://www.firstlineon.com/login
timeout /t 2 >nul

echo 📍 محاولة فتح لوحة التحكم...
start https://www.firstlineon.com/dashboard

echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo 🎯 النتيجة:
echo.
echo إذا فتحت الصفحات بنجاح = ✅ تم الربط!
echo إذا ظهرت أخطاء = ⏳ انتظر 10-30 دقيقة إضافية
echo.
echo 🔗 الروابط الجديدة:
echo    الموقع: https://www.firstlineon.com
echo    الدخول: https://www.firstlineon.com/login
echo    الإدارة: https://www.firstlineon.com/dashboard
echo.
echo 📊 للمزيد من الاختبارات:
start https://www.whatsmydns.net/#A/firstlineon.com

echo.
pause
