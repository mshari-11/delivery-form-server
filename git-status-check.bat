@echo off
chcp 65001 >nul
echo ========================================
echo حالة Git الحالية
echo ========================================

echo.
echo التحقق من الفرع الحالي...
git branch --show-current

echo.
echo عرض آخر commit...
git log -1 --oneline

echo.
echo التحقق من الحالة...
git status

echo.
echo ========================================
echo ✅ الـ Commit تم بنجاح!
echo ⏳ باقي فقط: git push origin main
echo ========================================
echo.
echo استخدم إحدى الطرق التالية:
echo 1. GitHub Desktop (الأسهل)
echo 2. git push origin main
echo 3. VS Code Source Control
echo.
echo راجع ملف: خطوات-الدفع-النهائية.md
echo.
pause