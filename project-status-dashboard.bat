@echo off
chcp 65001 >nul
color 0D
cls

echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 📊 تقرير حالة المشروع الشامل - Project Status Dashboard      ║
echo ╚════════════════════════════════════════════════════════════════════════╝

set current_time=%time:~0,8%
set current_date=%date%

echo.
echo 🕐 وقت التقرير: %current_time% - %current_date%
echo ════════════════════════════════════════════════════════════════════════

echo.
echo 📦 PROJECT INFO:
echo ────────────────────────────────────────────────────────────────────────
echo اسم المشروع: Delivery Form Server (تسجيل المناديب)
echo الدومين المطلوب: www.firstlineon.com
echo منصة النشر: Vercel
echo مجلد العمل: c:\Users\ASUS\Downloads\delivery-form-server
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🔍 1. فحص حالة GIT:
echo ═══════════════════════════════════════════════════════════════════════
git status --porcelain > nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Git Repository مُهيأ بشكل صحيح
    for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set git_branch=%%i
    echo 🌿 الفرع الحالي: %git_branch%
    for /f %%i in ('git rev-parse --short HEAD') do set git_commit=%%i
    echo 📝 آخر commit: %git_commit%
) else (
    echo ❌ مشكلة في Git Repository
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 🌐 2. فحص حالة DNS:
echo ═══════════════════════════════════════════════════════════════════════

:: Check root domain
nslookup firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ firstlineon.com: يعمل
    set dns_root=✅ ACTIVE
) else (
    echo ❌ firstlineon.com: غير متاح
    set dns_root=❌ NOT FOUND
)

:: Check www subdomain  
nslookup www.firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ www.firstlineon.com: يعمل
    set dns_www=✅ ACTIVE
) else (
    echo ❌ www.firstlineon.com: غير متاح
    set dns_www=❌ NOT FOUND
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 🔗 3. فحص الروابط الأساسية:
echo ═══════════════════════════════════════════════════════════════════════

:: Test main URLs
echo 🔍 فحص HTTPS الأساسي...
curl -s -o nul -w "%%{http_code}" https://www.firstlineon.com --connect-timeout 5 > temp_status.txt 2>nul
set /p https_status=<temp_status.txt
del temp_status.txt >nul 2>&1

if "%https_status%"=="200" (
    echo ✅ https://www.firstlineon.com: يعمل
    set site_status=✅ WORKING
) else (
    echo ❌ https://www.firstlineon.com: غير متاح
    set site_status=❌ NOT WORKING
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 📁 4. فحص ملفات المشروع الأساسية:
echo ═══════════════════════════════════════════════════════════════════════

:: Check critical files
if exist "index.html" (
    echo ✅ index.html موجود
) else (
    echo ❌ index.html مفقود
)

if exist "login.html" (
    echo ✅ login.html موجود
) else (
    echo ❌ login.html مفقود  
)

if exist "dashboard.html" (
    echo ✅ dashboard.html موجود
) else (
    echo ❌ dashboard.html مفقود
)

if exist "vercel.json" (
    echo ✅ vercel.json موجود
) else (
    echo ❌ vercel.json مفقود
)

if exist "package.json" (
    echo ✅ package.json موجود
) else (
    echo ❌ package.json مفقود
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 🛠️ 5. أدوات الإدارة المتاحة:
echo ═══════════════════════════════════════════════════════════════════════

set tools_count=0
if exist "SETUP-URGENT.bat" (
    echo ✅ SETUP-URGENT.bat - إعداد فوري
    set /a tools_count+=1
)
if exist "مراقب-DNS-تلقائي.bat" (
    echo ✅ مراقب-DNS-تلقائي.bat - مراقبة تلقائية
    set /a tools_count+=1
)
if exist "check-domain-status.bat" (
    echo ✅ check-domain-status.bat - فحص شامل
    set /a tools_count+=1
)
if exist "advanced-domain-check.bat" (
    echo ✅ advanced-domain-check.bat - فحص متقدم
    set /a tools_count+=1
)
if exist "PUSH-FINAL.bat" (
    echo ✅ PUSH-FINAL.bat - دفع نهائي
    set /a tools_count+=1
)

echo 📊 المجموع: %tools_count% أدوات متاحة

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 📋 6. تقرير الحالة النهائي:
echo ═══════════════════════════════════════════════════════════════════════

echo.
echo 🎯 ملخص الحالة:
echo ────────────────────────────────────────────────────────────────────────
echo Git Repository: ✅ يعمل
echo Root Domain: %dns_root%
echo WWW Domain: %dns_www%  
echo Website Status: %site_status%
echo Management Tools: ✅ %tools_count% أدوات جاهزة
echo.

:: Determine overall status
if "%dns_www%"=="✅ ACTIVE" (
    if "%site_status%"=="✅ WORKING" (
        set overall_status=🎉 FULLY OPERATIONAL
        set status_color=0A
        echo 🎉 الحالة العامة: المشروع يعمل بالكامل!
    ) else (
        set overall_status=⚠️ DNS READY, SITE PENDING
        set status_color=0E
        echo ⚠️ الحالة العامة: DNS جاهز، الموقع قيد التحضير
    )
) else (
    set overall_status=🔧 SETUP REQUIRED
    set status_color=0C
    echo 🔧 الحالة العامة: مطلوب إعداد DNS
)

echo.
color %status_color%
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ OVERALL STATUS: %overall_status%
echo ╚════════════════════════════════════════════════════════════════════════╝

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 🚀 الخطوات التالية المُوصى بها:
echo ═══════════════════════════════════════════════════════════════════════

if "%dns_www%"=="❌ NOT FOUND" (
    echo 1. 🔧 تشغيل SETUP-URGENT.bat لإعداد DNS
    echo 2. 🔄 تشغيل مراقب-DNS-تلقائي.bat للمتابعة
    echo 3. ⏳ انتظار انتشار DNS (5-60 دقيقة)
) else (
    echo 1. ✅ اختبار جميع صفحات الموقع
    echo 2. 🔍 التحقق من عمل النماذج
    echo 3. 📊 مراقبة الأداء
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 🔗 روابط سريعة:
echo ═══════════════════════════════════════════════════════════════════════
echo 🌐 Vercel Dashboard: https://vercel.com/dashboard
echo 🔍 DNS Checker: https://whatsmydns.net/#A/www.firstlineon.com
echo 📖 Setup Guide: domain-setup-guide.md
echo 🇸🇦 Arabic Guide: دليل-ربط-الدومين.md

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 📁 Save Report:
echo ═══════════════════════════════════════════════════════════════════════

:: Save report to file
echo 📊 تقرير حالة المشروع - %current_time% %current_date% > PROJECT-STATUS-REPORT.txt
echo. >> PROJECT-STATUS-REPORT.txt
echo OVERALL STATUS: %overall_status% >> PROJECT-STATUS-REPORT.txt
echo. >> PROJECT-STATUS-REPORT.txt
echo DNS STATUS: >> PROJECT-STATUS-REPORT.txt
echo - firstlineon.com: %dns_root% >> PROJECT-STATUS-REPORT.txt
echo - www.firstlineon.com: %dns_www% >> PROJECT-STATUS-REPORT.txt
echo. >> PROJECT-STATUS-REPORT.txt
echo WEBSITE STATUS: %site_status% >> PROJECT-STATUS-REPORT.txt
echo TOOLS AVAILABLE: %tools_count% >> PROJECT-STATUS-REPORT.txt
echo. >> PROJECT-STATUS-REPORT.txt
echo Generated: %current_time% %current_date% >> PROJECT-STATUS-REPORT.txt

echo ✅ تم حفظ التقرير في: PROJECT-STATUS-REPORT.txt

echo.
echo ═══════════════════════════════════════════════════════════════════════
pause
