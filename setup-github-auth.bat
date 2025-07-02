@echo off
chcp 65001 >nul
color 0E
cls

echo ╔═══════════════════════════════════════════════════════╗
echo ║           🔐 إعداد المصادقة مع GitHub                ║
echo ╚═══════════════════════════════════════════════════════╝

echo.
echo 📌 الخيارات المتاحة للدفع:
echo ════════════════════════════════════════════════════════

echo.
echo 1️⃣ GitHub Desktop (الأسهل - موصى به)
echo    ✓ لا يحتاج كلمة مرور
echo    ✓ واجهة رسومية سهلة
echo    ✓ تحميل من: https://desktop.github.com/
echo.

echo 2️⃣ Personal Access Token (للمحترفين)
echo    ✓ يعمل مع سطر الأوامر
echo    ✓ صلاحيات محددة
echo    ✓ أكثر أماناً من كلمة المرور
echo.

echo 3️⃣ VS Code (متوسط)
echo    ✓ مدمج مع المحرر
echo    ✓ سهل الاستخدام
echo    ✓ يحتاج تسجيل دخول مرة واحدة
echo.

echo ════════════════════════════════════════════════════════
echo.
echo 🔑 خطوات الحصول على Personal Access Token:
echo ────────────────────────────────────────────────

echo.
echo 1. افتح المتصفح واذهب إلى:
echo    https://github.com/settings/tokens
echo.
echo 2. اضغط على: "Generate new token (classic)"
echo.
echo 3. أدخل اسم وصفي مثل: "Vercel Deploy Token"
echo.
echo 4. اختر مدة الصلاحية: 90 days
echo.
echo 5. اختر الصلاحيات التالية:
echo    ☑️ repo (Full control of private repositories)
echo.
echo 6. اضغط "Generate token" في الأسفل
echo.
echo 7. 🚨 مهم: انسخ الـ token فوراً!
echo    (لن يظهر مرة أخرى)
echo.

echo ════════════════════════════════════════════════════════
echo.
echo 💡 كيفية استخدام الـ Token:
echo ────────────────────────────────────────────────

echo.
echo عند تشغيل git push، سيطلب منك:
echo.
echo Username: mshari-11
echo Password: [الصق الـ Token هنا - ليس كلمة المرور!]
echo.
echo ⚠️  تنبيه: الـ Token لن يظهر عند اللصق (أمان)
echo.

echo ════════════════════════════════════════════════════════
echo.
echo 🔗 روابط مفيدة:
echo.
echo GitHub Tokens: https://github.com/settings/tokens
echo GitHub Desktop: https://desktop.github.com/
echo VS Code: https://code.visualstudio.com/
echo.

pause