@echo off
chcp 65001 >nul
color 0B
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║           🧪 اختبار الروابط بعد النشر                ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo ⏳ تأكد من مرور 1-2 دقيقة بعد الدفع...
echo.
echo ════════════════════════════════════════════════════════
echo.

echo 🌐 سيتم فتح الروابط التالية في المتصفح:
echo.
echo 1️⃣ الصفحة الرئيسية (مع زر دخول الإدارة الجديد)
echo 2️⃣ تسجيل الدخول (المُصلحة من 404)
echo 3️⃣ لوحة التحكم الإدارية
echo 4️⃣ صفحة 404 المخصصة
echo.
echo اضغط أي مفتاح للبدء...
pause >nul

echo.
echo 🚀 فتح الروابط...
echo ────────────────────────────────────────────────

echo.
echo ▶️ الصفحة الرئيسية:
start https://delivery-form-mshari.vercel.app/
echo    ✓ تحقق من وجود زر "دخول الإدارة" في الأعلى

timeout /t 2 >nul

echo.
echo ▶️ تسجيل الدخول (المُصلحة):
start https://delivery-form-mshari.vercel.app/login
echo    ✓ يجب أن تظهر صفحة تسجيل الدخول بدون خطأ 404

timeout /t 2 >nul

echo.
echo ▶️ لوحة التحكم:
start https://delivery-form-mshari.vercel.app/dashboard
echo    ✓ سيطلب تسجيل الدخول أولاً

timeout /t 2 >nul

echo.
echo ▶️ صفحة 404 (للاختبار):
start https://delivery-form-mshari.vercel.app/page-not-found
echo    ✓ يجب أن تظهر صفحة 404 المخصصة

echo.
echo ════════════════════════════════════════════════════════
echo.
echo ✅ تم فتح جميع الروابط!
echo.
echo 📝 بيانات الدخول للموظفين:
echo ────────────────────────────────────────────────
echo    Username: admin
echo    Password: admin123
echo.
echo 🔍 ما يجب التحقق منه:
echo ────────────────────────────────────────────────
echo    ✓ زر "دخول الإدارة" في الصفحة الرئيسية
echo    ✓ صفحة تسجيل الدخول تعمل بدون 404
echo    ✓ إمكانية تسجيل الدخول للوحة التحكم
echo    ✓ صفحة 404 المخصصة تظهر للروابط الخاطئة
echo.
echo 🔗 روابط إضافية:
echo ────────────────────────────────────────────────
echo    GitHub: https://github.com/mshari-11/delivery-form-server
echo    Vercel: https://vercel.com/dashboard
echo.
echo 💡 إذا لم تعمل الروابط:
echo    1. تأكد من اكتمال البناء في Vercel
echo    2. جرب تحديث الصفحة (F5)
echo    3. امسح ذاكرة التخزين المؤقت (Ctrl+F5)
echo.
pause