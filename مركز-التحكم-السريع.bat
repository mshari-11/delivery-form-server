@echo off
chcp 65001 >nul
color 0A
cls

:main_loop
cls
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🔥 DNS SETUP CONTROL CENTER - مركز التحكم في إعداد DNS           ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.

set current_time=%time:~0,8%
set current_date=%date%

echo ⏰ الوقت الحالي: %current_time% - %current_date%
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 📊 CURRENT STATUS - الحالة الحالية:
echo ═══════════════════════════════════════════════════════════════════════

:: Quick DNS test
echo 🔍 فحص DNS سريع...
nslookup www.firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ DNS: www.firstlineon.com متاح!
    echo    🎉 SUCCESS! الدومين أصبح نشطاً!
    goto success_celebration
) else (
    echo    ❌ DNS: www.firstlineon.com غير متاح بعد
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo 🎯 DNS RECORDS REQUIRED - القيم المطلوبة:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 📋 A Record:
echo    Type: A
echo    Name: @ (أو firstlineon.com)
echo    Value: 216.15.011
echo.
echo 📋 CNAME Record:
echo    Type: CNAME
echo    Name: www
echo    Value: f12f74b9a686d5cd.vercel-dns-016.com
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🛠️ ACTIVE TOOLS - الأدوات النشطة:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo ✅ مراقب-النجاح-النهائي.bat - يفحص كل دقيقتين
echo ✅ إصلاح-DNS-فوري.bat - جاهز لنسخ القيم
echo ✅ Vercel Dashboard - مفتوح
echo ✅ DNS Checkers - مفتوحة للمراقبة
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo 🚀 QUICK ACTIONS - إجراءات سريعة:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo [1] نسخ A Record Value (216.15.011)
echo [2] نسخ CNAME Value (f12f74b9a686d5cd.vercel-dns-016.com)
echo [3] فتح Vercel Dashboard
echo [4] فتح DNS Checkers
echo [5] تشغيل فحص DNS سريع
echo [6] تحديث النافذة
echo [0] خروج
echo.

echo ⏳ سيتم تحديث النافذة تلقائياً كل 30 ثانية...
echo 💡 اختر رقماً أو انتظر التحديث التلقائي

choice /c 1234560 /t 30 /d 6 /n >nul

if errorlevel 7 goto exit_program
if errorlevel 6 goto main_loop
if errorlevel 5 goto quick_dns_test
if errorlevel 4 goto open_dns_checkers
if errorlevel 3 goto open_vercel
if errorlevel 2 goto copy_cname
if errorlevel 1 goto copy_a_record

:copy_a_record
echo 216.15.011 | clip
echo.
echo ✅ تم نسخ A Record Value: 216.15.011
echo 💡 يمكنك الآن لصقه في مزود النطاق
pause
goto main_loop

:copy_cname
echo f12f74b9a686d5cd.vercel-dns-016.com | clip
echo.
echo ✅ تم نسخ CNAME Value: f12f74b9a686d5cd.vercel-dns-016.com
echo 💡 يمكنك الآن لصقه في مزود النطاق
pause
goto main_loop

:open_vercel
start https://vercel.com/dashboard
echo.
echo ✅ تم فتح Vercel Dashboard
pause
goto main_loop

:open_dns_checkers
start https://whatsmydns.net/#A/firstlineon.com
start https://whatsmydns.net/#CNAME/www.firstlineon.com
echo.
echo ✅ تم فتح DNS Checkers
pause
goto main_loop

:quick_dns_test
echo.
echo 🔍 إجراء فحص DNS شامل...
echo ──────────────────────────────────────────────────────────────────────
nslookup firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ firstlineon.com: متاح
) else (
    echo ❌ firstlineon.com: غير متاح
)

nslookup www.firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ www.firstlineon.com: متاح
) else (
    echo ❌ www.firstlineon.com: غير متاح
)

ping www.firstlineon.com -n 1 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ ping: يعمل
) else (
    echo ❌ ping: غير متاح
)
echo.
pause
goto main_loop

:success_celebration
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 🎊🎊🎊 SUCCESS! DNS أصبح نشطاً! 🎊🎊🎊                        ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎉 تهانينا! الدومين www.firstlineon.com أصبح متاحاً!
echo.
echo 🚀 فتح الموقع الآن...
start https://www.firstlineon.com
start https://www.firstlineon.com/login
start https://www.firstlineon.com/dashboard
echo.
echo ✅ تم فتح جميع صفحات الموقع!
echo.
pause

:exit_program
echo.
echo 👋 شكراً لك! استمر في استخدام الأدوات المتاحة
echo.
pause
exit
