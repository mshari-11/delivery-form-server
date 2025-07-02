@echo off
echo 🚀 نشر سريع إلى GitHub و Vercel...
echo ==================================

echo 📦 إضافة جميع التغييرات...
git add .

echo 💬 إضافة رسالة الكوميت...
git commit -m "Fix vercel.json routing and CSS issues - Ready for deployment"

echo 📤 رفع إلى GitHub...
git push origin main

echo.
echo ✅ تم الرفع بنجاح!
echo 🔗 الرابط: https://delivery-form-mshari.vercel.app
echo ⏰ انتظر 2-3 دقائق ثم جرب الرابط
echo.
pause
