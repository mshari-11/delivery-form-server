@echo off
chcp 65001 >nul
title 🧪 اختبار المشروع قبل ربط الدومين
color 0E
cls

echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🧪 اختبار شامل للمشروع قبل ربط الدومين - Quality Check        ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 الهدف: التأكد من أن جميع الوظائف تعمل بشكل صحيح
echo ═══════════════════════════════════════════════════════════════════════

:main_menu
echo.
echo 🌐 الروابط المتاحة للاختبار:
echo ─────────────────────────────────────────────────────────────────────
echo 🔗 الأساسي: https://delivery-form-server.vercel.app
echo 🔗 الاحتياط: https://delivery-form-server-i9nnqmaww-mshari-as-projects.vercel.app
echo.

echo ⚡ اختبارات سريعة:
echo ═══════════════════════════════════════════════════════════════════════
echo [1] اختبار الصفحة الرئيسية
echo [2] اختبار صفحة تسجيل الدخول (/login)
echo [3] اختبار لوحة التحكم (/dashboard)  
echo [4] اختبار نموذج التسجيل (/register أو /form)
echo [5] اختبار صفحة إتمام التسجيل (/form-complete)
echo.
echo 🔍 اختبارات متقدمة:
echo ═══════════════════════════════════════════════════════════════════════
echo [6] فتح جميع الصفحات للاختبار الشامل
echo [7] فتح أدوات المطور للتحليل
echo [8] عرض دليل الاختبار التفصيلي
echo.
echo 📊 تقارير:
echo ═══════════════════════════════════════════════════════════════════════
echo [9] تسجيل نتائج الاختبار
echo [A] إنشاء تقرير جودة
echo.
echo [0] خروج
echo.

set /p choice="🎯 اختر نوع الاختبار: "

if "%choice%"=="1" goto test_homepage
if "%choice%"=="2" goto test_login
if "%choice%"=="3" goto test_dashboard
if "%choice%"=="4" goto test_form
if "%choice%"=="5" goto test_complete
if "%choice%"=="6" goto test_all
if "%choice%"=="7" goto dev_tools
if "%choice%"=="8" goto test_guide
if "%choice%"=="9" goto test_results
if /I "%choice%"=="A" goto quality_report
if "%choice%"=="0" goto end

echo ❌ اختيار غير صحيح
timeout /t 2 /nobreak >nul
goto main_menu

:test_homepage
echo.
echo 🏠 اختبار الصفحة الرئيسية...
start "" "https://delivery-form-server.vercel.app"
echo ✅ تم فتح الصفحة الرئيسية
echo.
echo 📋 تحقق من:
echo ──────────────────────────────────────────────────────────────────
echo ✓ تحميل الصفحة بنجاح
echo ✓ التصميم يظهر بشكل صحيح  
echo ✓ القوائم والأزرار تعمل
echo ✓ الشعار والعناوين ظاهرة
echo ✓ لا توجد أخطاء في المتصفح
echo.
pause
goto main_menu

:test_login
echo.
echo 🔐 اختبار صفحة تسجيل الدخول...
start "" "https://delivery-form-server.vercel.app/login"
echo ✅ تم فتح صفحة تسجيل الدخول
echo.
echo 📋 تحقق من:
echo ──────────────────────────────────────────────────────────────────
echo ✓ الصفحة تفتح بدون أخطاء
echo ✓ نموذج تسجيل الدخول يظهر
echo ✓ حقول الإدخال تعمل
echo ✓ أزرار تسجيل الدخول تعمل
echo ✓ رسائل التحقق تظهر
echo.
pause
goto main_menu

:test_dashboard
echo.
echo 🎛️ اختبار لوحة التحكم...
start "" "https://delivery-form-server.vercel.app/dashboard"
echo ✅ تم فتح لوحة التحكم
echo.
echo 📋 تحقق من:
echo ──────────────────────────────────────────────────────────────────
echo ✓ الوصول للوحة التحكم (قد يحتاج تسجيل دخول)
echo ✓ البيانات تظهر بشكل صحيح
echo ✓ الجداول والإحصائيات تعمل
echo ✓ أزرار الإدارة تعمل
echo ✓ القوائم الجانبية تعمل
echo.
pause
goto main_menu

:test_form
echo.
echo 📝 اختبار نموذج التسجيل...
start "" "https://delivery-form-server.vercel.app/register"
timeout /t 2 /nobreak >nul
start "" "https://delivery-form-server.vercel.app/form"
echo ✅ تم فتح نماذج التسجيل
echo.
echo 📋 تحقق من:
echo ──────────────────────────────────────────────────────────────────
echo ✓ نموذج تسجيل المناديب يفتح
echo ✓ جميع الحقول تعمل
echo ✓ التحقق من البيانات يعمل
echo ✓ إرسال النموذج يعمل
echo ✓ رسائل التأكيد تظهر
echo.
pause
goto main_menu

:test_complete
echo.
echo 📄 اختبار صفحة إتمام التسجيل...
start "" "https://delivery-form-server.vercel.app/form-complete"
echo ✅ تم فتح صفحة إتمام التسجيل
echo.
echo 📋 تحقق من:
echo ──────────────────────────────────────────────────────────────────
echo ✓ الصفحة تظهر بعد إتمام التسجيل
echo ✓ رسالة النجاح تظهر
echo ✓ تفاصيل التسجيل تظهر
echo ✓ أزرار طباعة/تحميل تعمل
echo.
pause
goto main_menu

:test_all
echo.
echo 🌐 فتح جميع الصفحات للاختبار الشامل...
echo ═══════════════════════════════════════════════════════════════════

echo 1/5 الصفحة الرئيسية...
start "" "https://delivery-form-server.vercel.app"
timeout /t 2 /nobreak >nul

echo 2/5 تسجيل الدخول...
start "" "https://delivery-form-server.vercel.app/login"
timeout /t 2 /nobreak >nul

echo 3/5 لوحة التحكم...
start "" "https://delivery-form-server.vercel.app/dashboard"  
timeout /t 2 /nobreak >nul

echo 4/5 نموذج التسجيل...
start "" "https://delivery-form-server.vercel.app/register"
timeout /t 2 /nobreak >nul

echo 5/5 إتمام التسجيل...
start "" "https://delivery-form-server.vercel.app/form-complete"

echo ✅ تم فتح جميع الصفحات
echo.
echo 💡 نصائح للاختبار الشامل:
echo ─────────────────────────────────────────────────────────────────
echo 🔍 تنقل بين جميع الصفحات
echo 📝 جرب تسجيل مناديب جديد  
echo 🔐 اختبر تسجيل الدخول والخروج
echo 📱 اختبر على أجهزة مختلفة
echo ⚡ راقب سرعة التحميل
echo.
pause
goto main_menu

:dev_tools
echo.
echo 🔧 فتح أدوات المطور للتحليل...
start "" "https://delivery-form-server.vercel.app"
echo.
echo 💡 تعليمات أدوات المطور:
echo ═══════════════════════════════════════════════════════════════════
echo 1️⃣ اضغط F12 أو Ctrl+Shift+I لفتح Developer Tools
echo 2️⃣ اذهب لتبويب Console لرؤية رسائل الخطأ
echo 3️⃣ اذهب لتبويب Network لمراقبة طلبات الشبكة
echo 4️⃣ اذهب لتبويب Performance لقياس الأداء
echo 5️⃣ اختبر على أحجام شاشة مختلفة
echo.
echo 🔍 ما تبحث عنه:
echo ──────────────────────────────────────────────────────────────────
echo ❌ رسائل خطأ حمراء في Console
echo ⚠️ تحذيرات صفراء
echo 🌐 طلبات فاشلة في Network (أحمر)
echo ⏱️ زمن تحميل بطيء
echo 📱 مشاكل في التصميم المتجاوب
echo.
pause
goto main_menu

:test_guide
echo.
echo 📖 فتح دليل الاختبار التفصيلي...
if exist "دليل-اختبار-شامل.md" (
    start "" "دليل-اختبار-شامل.md"
    echo ✅ تم فتح دليل الاختبار الشامل
) else (
    echo ❌ دليل الاختبار غير موجود
)
echo.
pause
goto main_menu

:test_results
echo.
echo 📊 تسجيل نتائج الاختبار...
echo ═══════════════════════════════════════════════════════════════════
echo.
set /p homepage="هل الصفحة الرئيسية تعمل؟ [Y/N]: "
set /p login="هل صفحة تسجيل الدخول تعمل؟ [Y/N]: "
set /p dashboard="هل لوحة التحكم تعمل؟ [Y/N]: "
set /p form="هل نموذج التسجيل يعمل؟ [Y/N]: "
set /p database="هل حفظ البيانات يعمل؟ [Y/N]: "
set /p design="هل التصميم متجاوب؟ [Y/N]: "

echo.
echo 📋 نتائج الاختبار:
echo ─────────────────────────────────────────────────────────────────
echo 🏠 الصفحة الرئيسية: %homepage%
echo 🔐 تسجيل الدخول: %login%
echo 🎛️ لوحة التحكم: %dashboard%
echo 📝 نموذج التسجيل: %form%
echo 🗃️ قاعدة البيانات: %database%
echo 📱 التصميم المتجاوب: %design%
echo.

echo 📄 حفظ النتائج في ملف...
echo نتائج اختبار المشروع - %date% %time% > نتائج-الاختبار.txt
echo ═══════════════════════════════════════════════════════════════════ >> نتائج-الاختبار.txt
echo الصفحة الرئيسية: %homepage% >> نتائج-الاختبار.txt
echo تسجيل الدخول: %login% >> نتائج-الاختبار.txt
echo لوحة التحكم: %dashboard% >> نتائج-الاختبار.txt
echo نموذج التسجيل: %form% >> نتائج-الاختبار.txt
echo قاعدة البيانات: %database% >> نتائج-الاختبار.txt
echo التصميم المتجاوب: %design% >> نتائج-الاختبار.txt

echo ✅ تم حفظ النتائج في نتائج-الاختبار.txt
pause
goto main_menu

:quality_report
echo.
echo 📊 إنشاء تقرير جودة...
echo ═══════════════════════════════════════════════════════════════════

if /I "%homepage%"=="Y" (if /I "%login%"=="Y" (if /I "%dashboard%"=="Y" (if /I "%form%"=="Y" (if /I "%database%"=="Y" (if /I "%design%"=="Y" (
    echo 🎉 تقييم الجودة: ممتاز - جاهز للربط بالدومين!
    echo ✅ جميع الوظائف تعمل بشكل مثالي
    echo 🚀 يمكن المتابعة مع ربط www.firstlineon.com
) else (
    echo ⚠️ تقييم الجودة: جيد - يحتاج تحسينات طفيفة
    echo 🔧 هناك بعض المشاكل البسيطة
    echo 💡 يُنصح بالإصلاح قبل الربط
))))))

echo.
echo 📋 التوصيات:
echo ─────────────────────────────────────────────────────────────────
if /I "%homepage%"=="N" echo ❌ إصلاح مشكلة الصفحة الرئيسية
if /I "%login%"=="N" echo ❌ إصلاح مشكلة تسجيل الدخول
if /I "%dashboard%"=="N" echo ❌ إصلاح مشكلة لوحة التحكم
if /I "%form%"=="N" echo ❌ إصلاح مشكلة نموذج التسجيل
if /I "%database%"=="N" echo ❌ إصلاح مشكلة قاعدة البيانات
if /I "%design%"=="N" echo ❌ إصلاح مشكلة التصميم المتجاوب

echo.
pause
goto main_menu

:end
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 👋 انتهى الاختبار - Quality Check Complete                      ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 💡 ملخص سريع:
echo ─────────────────────────────────────────────────────────────────
echo 🔗 رابط الاختبار: https://delivery-form-server.vercel.app
echo 📄 النتائج محفوظة في: نتائج-الاختبار.txt
echo 📖 الدليل التفصيلي: دليل-اختبار-شامل.md
echo.
echo 🎯 إذا كان كل شيء يعمل:
echo    ✅ جاهز لربط الدومين www.firstlineon.com
echo    🔧 حدث Nameservers: ns1.vercel-dns.com + ns2.vercel-dns.com
echo.
echo 🔧 إذا وجدت مشاكل:
echo    ⚠️ أصلح المشاكل أولاً → أعد النشر → أعد الاختبار
echo.
pause
exit
