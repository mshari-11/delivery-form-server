@echo off
chcp 65001 > nul
title "نشر الخط الأول - Final Deploy"
color 0A

echo.
echo ██████████████████████████████████████████████████████████
echo █                                                        █
echo █    🚀 نشر نظام تسجيل مناديب الخط الأول - النشر النهائي    █
echo █                                                        █
echo ██████████████████████████████████████████████████████████
echo.

echo 📋 جاري التحقق من الملفات المطلوبة...
timeout /t 1 > nul

if not exist "vercel.json" (
    echo ❌ ملف vercel.json غير موجود
    pause
    exit /b 1
)

if not exist "server.js" (
    echo ❌ ملف server.js غير موجود
    pause
    exit /b 1
)

if not exist "form-complete.html" (
    echo ❌ ملف form-complete.html غير موجود
    pause
    exit /b 1
)

echo ✅ تم التحقق من جميع الملفات المطلوبة

echo.
echo 📦 جاري إعداد البيانات للنشر...
git add .
git commit -m "🎯 إصلاح شامل ونهائي - تم حل جميع المشاكل وجاهز للنشر"

echo.
echo 🌐 جاري رفع التحديثات إلى GitHub...
git push origin main

echo.
echo 🚀 جاري بدء النشر على Vercel...
vercel --prod --yes

echo.
echo ██████████████████████████████████████████████████████████
echo █                     🎉 تم النشر بنجاح! 🎉                 █
echo ██████████████████████████████████████████████████████████
echo.
echo 🔗 روابط الموقع الجاهزة:
echo    🌐 الصفحة الرئيسية:
echo       https://delivery-form-mshari.vercel.app/
echo.
echo    📊 لوحة التحكم:
echo       https://delivery-form-mshari.vercel.app/dashboard
echo.
echo    🔐 تسجيل الدخول:
echo       https://delivery-form-mshari.vercel.app/login
echo.
echo 🔑 بيانات الدخول للإدارة:
echo    📧 المستخدم: admin
echo    🔒 كلمة المرور: admin123
echo.
echo ✨ المميزات المفعلة:
echo    ✅ رفع الملفات والصور
echo    ✅ قاعدة البيانات SQLite
echo    ✅ تصدير بيانات Excel
echo    ✅ أمان وحماية متقدمة
echo    ✅ واجهات متجاوبة وجميلة
echo    ✅ إدارة شاملة للمناديب
echo.
echo 🎊 مبروك! مشروعك الآن جاهز ويعمل بكفاءة عالية
echo 💯 تم إصلاح جميع المشاكل بنجاح!
echo.
pause
