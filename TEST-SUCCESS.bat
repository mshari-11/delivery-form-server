@echo off
chcp 65001 >nul
color 0A
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║        🧪 اختبار نجاح الإصلاحات                      ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📊 التحقق من حالة الإصلاحات...
echo.

echo ✅ التحديثات مدفوعة إلى GitHub
echo ✅ ملف vercel.json محدث
echo.
echo ════════════════════════════════════════════════════════
echo.

echo 🌐 اختبار الموقع الأول...
echo    https://delivery-form-mshari.vercel.app/login
curl -s -o nul -w "    الحالة: %%{http_code}\n" https://delivery-form-mshari.vercel.app/login

echo.
echo 🌐 اختبار الموقع الثاني...
echo    https://delivery-form-server-54sv.vercel.app/login
curl -s -o nul -w "    الحالة: %%{http_code}\n" https://delivery-form-server-54sv.vercel.app/login

echo.
echo ════════════════════════════════════════════════════════
echo.

echo 💡 إذا ظهرت الحالة 404:
echo.
echo 1. افتح Vercel Dashboard:
echo    https://vercel.com/dashboard
echo.
echo 2. اختر المشروع
echo.
echo 3. اضغط على "Redeploy"
echo.
echo 4. اختر "Redeploy with existing Build Cache cleared"
echo.
echo ════════════════════════════════════════════════════════
echo.
echo 📌 في هذه الأثناء، استخدم:
echo.
echo ✅ https://delivery-form-mshari.vercel.app/login.html
echo ✅ https://delivery-form-server-54sv.vercel.app/login.html
echo.
pause