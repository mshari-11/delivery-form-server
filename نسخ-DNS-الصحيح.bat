@echo off
chcp 65001 >nul
title 🔧 نسخ DNS Records الصحيحة
color 0A
cls

echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 📋 DNS Records الصحيحة من Vercel Dashboard                      ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 القيم المحدثة حسب Vercel:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 🌐 A Record:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: A
echo   Name: @ (أو firstlineon.com)
echo   Value: 76.76.21.21
echo.
echo 🌐 CNAME Record:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: CNAME  
echo   Name: www
echo   Value: f12f74b9a686d5cd.vercel-dns-016.com
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo ⚡ خيارات النسخ السريع:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo [1] نسخ A Record Value (76.76.21.21)
echo [2] نسخ CNAME Record Value (f12f74b9a686d5cd.vercel-dns-016.com)
echo [3] عرض خطوات الإعداد
echo [4] فتح أدوات التحقق
echo [5] فتح Vercel Dashboard
echo [0] خروج
echo.

set /p choice="اختر الرقم: "

if "%choice%"=="1" (
    echo 76.76.21.21 | clip
    echo ✅ تم نسخ A Record Value: 76.76.21.21
    echo 💡 الصق هذا في خانة Value للـ A Record
    pause
    goto start
)

if "%choice%"=="2" (
    echo f12f74b9a686d5cd.vercel-dns-016.com | clip
    echo ✅ تم نسخ CNAME Record Value: f12f74b9a686d5cd.vercel-dns-016.com
    echo 💡 الصق هذا في خانة Value للـ CNAME Record
    pause
    goto start
)

if "%choice%"=="3" (
    echo.
    echo 📖 خطوات الإعداد:
    echo ═══════════════════════════════════════════════════════════════════════
    echo.
    echo 1️⃣ اذهب لـ DNS Management في مزود النطاق
    echo 2️⃣ أضف A Record: @ → 76.76.21.21
    echo 3️⃣ أضف CNAME Record: www → f12f74b9a686d5cd.vercel-dns-016.com
    echo 4️⃣ احفظ التغييرات
    echo 5️⃣ انتظر 5-30 دقيقة للانتشار
    echo.
    if exist "دليل-DNS-السريع-UPDATED.md" (
        echo 🔗 فتح الدليل التفصيلي؟ [Y/N]
        set /p guide=""
        if /I "%guide%"=="Y" start "" "دليل-DNS-السريع-UPDATED.md"
    )
    pause
    goto start
)

if "%choice%"=="4" (
    echo.
    echo 🔍 فتح أدوات التحقق...
    start "" "https://whatsmydns.net/#A/www.firstlineon.com"
    start "" "https://dnschecker.org/all-dns-records-of-domain.php?query=www.firstlineon.com"
    echo ✅ تم فتح أدوات التحقق
    pause
    goto start
)

if "%choice%"=="5" (
    echo.
    echo 🌐 فتح Vercel Dashboard...
    start "" "https://vercel.com/dashboard"
    echo ✅ تم فتح Vercel Dashboard
    pause
    goto start
)

if "%choice%"=="0" goto end

echo ❌ اختيار غير صحيح
timeout /t 2 /nobreak >nul

:start
cls
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║ 📋 DNS Records الصحيحة من Vercel Dashboard                      ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo 🎯 القيم المحدثة حسب Vercel:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 🌐 A Record:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: A
echo   Name: @ (أو firstlineon.com)
echo   Value: 76.76.21.21
echo.
echo 🌐 CNAME Record:
echo ──────────────────────────────────────────────────────────────────────
echo   Type: CNAME  
echo   Name: www
echo   Value: f12f74b9a686d5cd.vercel-dns-016.com
echo.

echo ═══════════════════════════════════════════════════════════════════════
echo ⚡ خيارات النسخ السريع:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo [1] نسخ A Record Value (76.76.21.21)
echo [2] نسخ CNAME Record Value (f12f74b9a686d5cd.vercel-dns-016.com)
echo [3] عرض خطوات الإعداد
echo [4] فتح أدوات التحقق
echo [5] فتح Vercel Dashboard
echo [0] خروج
echo.

set /p choice="اختر الرقم: "

if "%choice%"=="1" (
    echo 76.76.21.21 | clip
    echo ✅ تم نسخ A Record Value: 76.76.21.21
    echo 💡 الصق هذا في خانة Value للـ A Record
    pause
    goto start
)

if "%choice%"=="2" (
    echo f12f74b9a686d5cd.vercel-dns-016.com | clip
    echo ✅ تم نسخ CNAME Record Value: f12f74b9a686d5cd.vercel-dns-016.com
    echo 💡 الصق هذا في خانة Value للـ CNAME Record
    pause
    goto start
)

if "%choice%"=="3" (
    echo.
    echo 📖 خطوات الإعداد:
    echo ═══════════════════════════════════════════════════════════════════════
    echo.
    echo 1️⃣ اذهب لـ DNS Management في مزود النطاق
    echo 2️⃣ أضف A Record: @ → 76.76.21.21
    echo 3️⃣ أضف CNAME Record: www → f12f74b9a686d5cd.vercel-dns-016.com
    echo 4️⃣ احفظ التغييرات
    echo 5️⃣ انتظر 5-30 دقيقة للانتشار
    echo.
    if exist "دليل-DNS-السريع-UPDATED.md" (
        echo 🔗 فتح الدليل التفصيلي؟ [Y/N]
        set /p guide=""
        if /I "%guide%"=="Y" start "" "دليل-DNS-السريع-UPDATED.md"
    )
    pause
    goto start
)

if "%choice%"=="4" (
    echo.
    echo 🔍 فتح أدوات التحقق...
    start "" "https://whatsmydns.net/#A/www.firstlineon.com"
    start "" "https://dnschecker.org/all-dns-records-of-domain.php?query=www.firstlineon.com"
    echo ✅ تم فتح أدوات التحقق
    pause
    goto start
)

if "%choice%"=="5" (
    echo.
    echo 🌐 فتح Vercel Dashboard...
    start "" "https://vercel.com/dashboard"
    echo ✅ تم فتح Vercel Dashboard
    pause
    goto start
)

if "%choice%"=="0" goto end

echo ❌ اختيار غير صحيح
timeout /t 2 /nobreak >nul
goto start

:end
echo.
echo 👋 شكراً! لا تنس:
echo ────────────────────────────────────────────────────────────────────────
echo 🔧 إعداد DNS Records: A=76.76.21.21, CNAME=f12f74b9a686d5cd.vercel-dns-016.com
echo ⏰ انتظار الانتشار: 5-30 دقيقة
echo 🌐 اختبار الموقع: https://www.firstlineon.com
echo.
pause
exit
