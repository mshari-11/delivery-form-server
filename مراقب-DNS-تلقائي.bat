@echo off
chcp 65001 >nul
color 0E
cls

echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ 🔄 مراقب DNS التلقائي - www.firstlineon.com                   ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo ⏰ بدء المراقبة التلقائية...
echo 📋 سيتم فحص الدومين كل 5 دقائق حتى يصبح متاحاً
echo ═══════════════════════════════════════════════════════════════════════

:monitor_loop
set current_time=%time:~0,8%
set current_date=%date%

echo.
echo 🕐 الوقت: %current_time% - %current_date%
echo ─────────────────────────────────────────────────────────

:: Test root domain
echo 🔍 فحص firstlineon.com...
nslookup firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ firstlineon.com متاح!
    set root_status=✅ ACTIVE
    set root_color=✅
) else (
    echo    ❌ firstlineon.com غير متاح
    set root_status=❌ NOT FOUND
    set root_color=❌
)

:: Test www subdomain
echo 🔍 فحص www.firstlineon.com...
nslookup www.firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ www.firstlineon.com متاح!
    set www_status=✅ ACTIVE
    set www_color=✅
    goto success_found
) else (
    echo    ❌ www.firstlineon.com غير متاح
    set www_status=❌ NOT FOUND
    set www_color=❌
)

:: Test HTTPS accessibility
echo 🔍 فحص HTTPS...
curl -s -o nul -w "%%{http_code}" https://www.firstlineon.com --connect-timeout 10 2>nul | findstr "200" >nul
if %errorlevel% equ 0 (
    echo    ✅ HTTPS يعمل بشكل صحيح!
    set https_status=✅ WORKING
) else (
    echo    ❌ HTTPS غير متاح بعد
    set https_status=❌ NOT READY
)

:: Update status file
echo 📊 تحديث ملف الحالة...
echo 📊 مراقب DNS التلقائي - %current_time% %current_date% > DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🌐 DOMAIN STATUS: >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════════════════════════════════════ >> DOMAIN-STATUS.txt
echo الدومين: firstlineon.com - %root_status% >> DOMAIN-STATUS.txt
echo WWW: www.firstlineon.com - %www_status% >> DOMAIN-STATUS.txt
echo HTTPS: %https_status% >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 📈 MONITORING INFO: >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════════════════════════════════════ >> DOMAIN-STATUS.txt
echo آخر فحص: %current_time% >> DOMAIN-STATUS.txt
echo الحالة: قيد المراقبة التلقائية >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt

echo.
echo 📊 الحالة الحالية:
echo    firstlineon.com: %root_color% %root_status%
echo    www.firstlineon.com: %www_color% %www_status%
echo    HTTPS: %https_status%

echo.
echo ⏳ انتظار 5 دقائق قبل الفحص التالي...
echo 💡 يمكنك إيقاف المراقبة بالضغط على Ctrl+C
echo.

:: Wait 5 minutes (300 seconds)
timeout /t 300 /nobreak > nul

goto monitor_loop

:success_found
echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ 🎉 تم العثور على الدومين! النطاق أصبح متاحاً!               ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 الخطوة التالية: اختبار الموقع
echo.

:: Update final status
echo 🎉 DNS PROPAGATION SUCCESS! - %current_time% %current_date% > DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🌐 DOMAIN STATUS: >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════════════════════════════════════ >> DOMAIN-STATUS.txt
echo firstlineon.com: ✅ ACTIVE >> DOMAIN-STATUS.txt
echo www.firstlineon.com: ✅ ACTIVE >> DOMAIN-STATUS.txt
echo DNS انتشر بنجاح في: %current_time% >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🎯 NEXT STEPS: >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════════════════════════════════════ >> DOMAIN-STATUS.txt
echo 1. ✅ اختبار الروابط >> DOMAIN-STATUS.txt
echo 2. ✅ التحقق من SSL >> DOMAIN-STATUS.txt
echo 3. ✅ اختبار صفحات الموقع >> DOMAIN-STATUS.txt

echo.
echo 🚀 فتح الموقع الجديد...
start https://www.firstlineon.com

echo.
echo 🔧 تشغيل اختبار شامل للموقع...
call test-domain.bat

echo.
echo 📋 تشغيل التحقق النهائي...
call advanced-domain-check.bat

pause
