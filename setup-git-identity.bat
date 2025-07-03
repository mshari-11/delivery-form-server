@echo off
chcp 65001 >nul
echo ========================================
echo تكوين هوية Git
echo ========================================

echo.
echo تكوين اسم المستخدم...
git config --global user.name "mshari-11"

echo.
echo تكوين البريد الإلكتروني...
git config --global user.email "mshari@example.com"

echo.
echo ========================================
echo ✅ تم تكوين Git بنجاح!
echo ========================================
echo.
echo يمكنك الآن تشغيل push-fix-404.bat
echo.
pause