@echo off
echo 🚀 بدء عملية النشر التلقائي...
echo ======================================

cd /d "C:\Users\ASUS\Downloads\delivery-form-server"

echo 📦 إضافة جميع التغييرات...
git add .

echo 💬 حفظ التغييرات...
git commit -m "Fix vercel.json routing and CSS issues - Ready for deployment"

echo 📤 رفع إلى GitHub...
git push origin main

echo.
echo ======================================
echo ✅ تم الرفع بنجاح!
echo 🔗 الرابط: https://delivery-form-mshari.vercel.app
echo ⏰ انتظر 2-3 دقائق ثم جرب الرابط
echo ======================================
echo.

timeout /t 10 /nobreak
