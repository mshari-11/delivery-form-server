@echo off
chcp 65001 >nul
echo ====================================
echo 🔧 أداة إعداد Windows - First Line
echo ====================================
echo.

:: فحص Git
echo 📊 فحص Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git غير مثبت
    echo 📥 قم بتنزيله من: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo ✅ Git مثبت

:: فحص حالة المستودع
echo.
echo 📁 فحص المستودع...
git status --short
echo.

:: فحص commits غير مدفوعة
for /f "tokens=*" %%i in ('git status -sb 2^>nul') do set branch_status=%%i
echo %branch_status% | findstr /C:"ahead" >nul
if %errorlevel% equ 0 (
    echo ⚠️  لديك commits غير مدفوعة
    echo.
)

:: خيارات Push
echo ====================================
echo 📤 خيارات دفع التغييرات:
echo ====================================
echo.
echo 1) استخدام GitHub Desktop (الأسهل)
echo 2) استخدام Personal Access Token
echo 3) استخدام سطر الأوامر
echo 4) فتح دليل الرفع اليدوي
echo 5) فحص DNS المحلي
echo 6) الخروج
echo.

set /p choice="اختر رقم الخيار: "

if "%choice%"=="1" goto github_desktop
if "%choice%"=="2" goto pat_guide
if "%choice%"=="3" goto git_push
if "%choice%"=="4" goto manual_upload
if "%choice%"=="5" goto dns_check
if "%choice%"=="6" goto end

:github_desktop
echo.
echo 🖥️ فتح GitHub Desktop...
start "" "C:\Program Files\GitHub Desktop\GitHubDesktop.exe" 2>nul
if %errorlevel% neq 0 (
    echo ❌ GitHub Desktop غير مثبت
    echo 📥 قم بتنزيله من: https://desktop.github.com/
    pause
)
goto menu

:pat_guide
echo.
echo 🔑 دليل Personal Access Token:
echo ====================================
echo 1. افتح: https://github.com/settings/tokens
echo 2. اضغط "Generate new token (classic)"
echo 3. اختر صلاحيات: repo
echo 4. انسخ الـ token
echo 5. استخدم الأمر:
echo    git push https://TOKEN@github.com/mshari-11/delivery-form-server.git main
echo.
echo اضغط أي مفتاح لفتح صفحة GitHub...
pause >nul
start https://github.com/settings/tokens
goto menu

:git_push
echo.
echo 🚀 محاولة Push...
git push origin main
if %errorlevel% neq 0 (
    echo.
    echo ❌ فشل Push - جرب خيار آخر
    pause
)
goto menu

:manual_upload
echo.
echo 📖 فتح دليل الرفع اليدوي...
start notepad manual-upload-guide.md 2>nul
if %errorlevel% neq 0 (
    echo ❌ الملف غير موجود
    pause
)
goto menu

:dns_check
echo.
echo 🌐 فتح صفحة فحص DNS المحلية...
start dns-check-local.html
goto menu

:menu
echo.
echo ====================================
echo اضغط أي مفتاح للعودة للقائمة...
pause >nul
cls
goto :start

:end
echo.
echo 👋 شكراً لاستخدام أداة الإعداد!
echo.
echo 📋 الملفات المرجعية:
echo - GIT-PUSH-INSTRUCTIONS.md
echo - manual-upload-guide.md
echo - DOMAIN-SETUP-WIZARD.md
echo.
pause