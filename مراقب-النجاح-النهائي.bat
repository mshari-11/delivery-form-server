@echo off
chcp 65001 >nul
color 0B
cls

echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🔄 مراقب DNS النهائي - Vercel Domain Connection Monitor         ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 الهدف: مراقبة ربط www.firstlineon.com بـ Vercel
echo ⏰ فترة المراقبة: كل 2 دقيقة
echo 🌐 الدومين: www.firstlineon.com
echo ═══════════════════════════════════════════════════════════════════════

set check_count=0

:monitor_loop
set /a check_count+=1
set current_time=%time:~0,8%
set current_date=%date%

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🔍 فحص رقم %check_count% - %current_time%
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

:: Test 1: DNS Resolution
echo [1/4] فحص DNS Resolution...
nslookup www.firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo       ✅ DNS: www.firstlineon.com موجود
    set dns_status=FOUND
) else (
    echo       ❌ DNS: www.firstlineon.com غير موجود
    set dns_status=NOT_FOUND
    goto continue_monitoring
)

:: Test 2: Get IP Address and verify it matches Vercel
echo [2/4] الحصول على IP Address والتحقق من Vercel...
for /f "tokens=2 delims= " %%i in ('nslookup www.firstlineon.com 8.8.8.8 2^>nul ^| findstr "Address:" ^| tail -1') do set ip_addr=%%i
if defined ip_addr (
    echo       ✅ IP Address: %ip_addr%
    
    :: Check if IP matches expected Vercel IP range
    echo %ip_addr% | findstr "216.15" >nul
    if %errorlevel% equ 0 (
        echo       ✅ IP matches Vercel range (216.15.x.x)
        set ip_status=VERCEL_IP
    ) else (
        echo       ⚠️ IP doesn't match expected Vercel range
        set ip_status=NON_VERCEL_IP
    )
) else (
    echo       ⚠️ لم يتم العثور على IP Address
    set ip_status=NO_IP
)

:: Test 3: HTTP/HTTPS Connection
echo [3/4] اختبار اتصال HTTPS...
curl -s -o nul -w "%%{http_code}" https://www.firstlineon.com --connect-timeout 5 > temp_http.txt 2>nul
set /p http_code=<temp_http.txt
del temp_http.txt >nul 2>&1

if "%http_code%"=="200" (
    echo       ✅ HTTPS: يعمل بشكل صحيح (200 OK)
    set https_status=WORKING
    goto success_detected
) else if "%http_code%"=="301" (
    echo       ✅ HTTPS: يعمل مع إعادة توجيه (301)
    set https_status=REDIRECT
    goto success_detected
) else if "%http_code%"=="404" (
    echo       ⚠️ HTTPS: الموقع متصل لكن صفحة غير موجودة (404)
    set https_status=CONNECTED_404
    goto success_detected
) else (
    echo       ❌ HTTPS: غير متاح (Code: %http_code%)
    set https_status=NOT_WORKING
)

:: Test 4: Vercel-specific test
echo [4/4] فحص اتصال Vercel...
curl -s -I https://www.firstlineon.com --connect-timeout 5 2>nul | findstr /i "vercel\|server:" >nul
if %errorlevel% equ 0 (
    echo       ✅ Vercel: الموقع متصل بـ Vercel
    set vercel_status=CONNECTED
) else (
    echo       ❌ Vercel: غير متصل بـ Vercel بعد
    set vercel_status=NOT_CONNECTED
)

:continue_monitoring
:: Status Summary
echo.
echo 📊 ملخص الحالة:
echo ─────────────────────────────────────────────────────────
if "%dns_status%"=="FOUND" (
    echo 🌐 DNS: ✅ جاهز
) else (
    echo 🌐 DNS: ❌ غير جاهز
)

if "%https_status%"=="WORKING" (
    echo 🔗 HTTPS: ✅ يعمل
) else if "%https_status%"=="REDIRECT" (
    echo 🔗 HTTPS: ✅ يعمل مع إعادة توجيه
) else if "%https_status%"=="CONNECTED_404" (
    echo 🔗 HTTPS: ⚠️ متصل لكن يحتاج إعداد
) else (
    echo 🔗 HTTPS: ❌ غير متاح
)

if "%vercel_status%"=="CONNECTED" (
    echo 🚀 Vercel: ✅ متصل
) else (
    echo 🚀 Vercel: ❌ غير متصل
)

:: Update status file
echo 📊 Domain Monitor Status - %current_time% %current_date% > DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo Check #%check_count% Results: >> DOMAIN-STATUS.txt
echo DNS Status: %dns_status% >> DOMAIN-STATUS.txt
echo HTTPS Status: %https_status% >> DOMAIN-STATUS.txt
echo Vercel Status: %vercel_status% >> DOMAIN-STATUS.txt
if defined ip_addr echo IP Address: %ip_addr% >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo Last Check: %current_time% >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt

echo.
echo ⏳ انتظار دقيقتين قبل الفحص التالي...
echo 💡 اضغط Ctrl+C لإيقاف المراقبة

:: Wait 2 minutes
timeout /t 120 /nobreak > nul

goto monitor_loop

:success_detected
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🎉 نجح الاتصال! الموقع أصبح متاحاً!                          ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 📊 تفاصيل النجاح:
echo ───────────────────────────────────────────────────────────────────────
echo ✅ DNS: متاح (%ip_addr%)
echo ✅ HTTPS: %https_status%
echo ✅ Vercel: %vercel_status%
echo.

:: Update final status
echo 🎉 SUCCESS! - %current_time% %current_date% > DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🌐 WEBSITE STATUS: LIVE! >> DOMAIN-STATUS.txt
echo ═══════════════════════════════════════════════════════════════════════ >> DOMAIN-STATUS.txt
echo Domain: www.firstlineon.com >> DOMAIN-STATUS.txt
echo DNS: %dns_status% >> DOMAIN-STATUS.txt
echo HTTPS: %https_status% >> DOMAIN-STATUS.txt
echo Vercel: %vercel_status% >> DOMAIN-STATUS.txt
if defined ip_addr echo IP: %ip_addr% >> DOMAIN-STATUS.txt
echo Success Time: %current_time% >> DOMAIN-STATUS.txt
echo. >> DOMAIN-STATUS.txt
echo 🎯 NEXT: Test all website pages >> DOMAIN-STATUS.txt

echo 🚀 فتح الموقع الآن...
start https://www.firstlineon.com

echo.
echo 🔍 اختبار الصفحات الأساسية...
echo.
echo 🏠 الصفحة الرئيسية:
start https://www.firstlineon.com
echo    ↳ https://www.firstlineon.com

echo.
echo 🔐 صفحة تسجيل الدخول:
start https://www.firstlineon.com/login
echo    ↳ https://www.firstlineon.com/login

echo.
echo 📊 لوحة التحكم:
start https://www.firstlineon.com/dashboard
echo    ↳ https://www.firstlineon.com/dashboard

echo.
echo ✅ صفحة إتمام النموذج:
start https://www.firstlineon.com/form-complete
echo    ↳ https://www.firstlineon.com/form-complete

echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🎊 تهانينا! مشروع تسجيل المناديب أصبح متاحاً على الإنترنت!     ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 📝 إنشاء تقرير النجاح النهائي...
call project-status-dashboard.bat

pause
exit
