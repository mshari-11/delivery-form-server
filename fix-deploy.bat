@echo off
echo 🔧 إعادة نشر مع إصلاح Vercel...
echo ====================================

cd /d "C:\Users\ASUS\Downloads\delivery-form-server"

echo 📦 إضافة التحديثات الجديدة...
git add .

echo 💬 حفظ التحديثات...
git commit -m "Fix Vercel config for static site deployment"

echo 📤 رفع التحديثات...
git push origin main --force

echo.
echo ====================================
echo ✅ تم رفع التحديثات!
echo 🔗 الرابط: https://delivery-form-mshari.vercel.app
echo ⏰ انتظر 3-5 دقائق للنشر الجديد
echo ====================================
echo.

timeout /t 5 /nobreak
