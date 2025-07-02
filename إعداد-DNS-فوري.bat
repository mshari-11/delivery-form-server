@echo off
chcp 65001 >nul
color 0C
cls

echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ 🚨 عاجل: إعداد DNS المطلوب فوراً لـ www.firstlineon.com ║
echo ╚══════════════════════════════════════════════════════════════════╝

echo.
echo 📊 نتائج whatsmydns.net تؤكد:
echo ❌ لا يوجد CNAME Record للدومين
echo ❌ لا يوجد A Record للدومين
echo ❌ DNS غير مُعد بالكامل

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 🔧 المطلوب عمله الآن:
echo.
echo 1️⃣ اذهب إلى لوحة تحكم مزود النطاق
echo    (المكان الذي اشتريت منه الدومين)
echo.
echo 2️⃣ ابحث عن قسم "DNS Management" أو "DNS Records"
echo.
echo 3️⃣ أضف هذين الـ Records بالضبط:
echo.
echo ────────────────────────────────────────
echo 📝 A Record:
echo ────────────────────────────────────────
echo Type: A
echo Name: @ (أو اتركه فارغ)
echo Value: 76.76.19.19
echo TTL: Auto (أو 3600)
echo.
echo ────────────────────────────────────────
echo 📝 CNAME Record:
echo ────────────────────────────────────────
echo Type: CNAME
echo Name: www
echo Value: cname.vercel-dns.com
echo TTL: Auto (أو 3600)
echo ────────────────────────────────────────

echo.
echo 4️⃣ احفظ التغييرات في لوحة التحكم
echo.
echo 5️⃣ انتظر 10-30 دقيقة
echo.
echo 6️⃣ أعد فحص whatsmydns.net
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 💡 مزودي النطاقات الشائعين:
echo • Namecheap: Advanced DNS
echo • GoDaddy: DNS Management  
echo • Cloudflare: DNS Records
echo • Google Domains: DNS
echo.
echo هل تريد نسخ DNS Records إلى الحافظة؟ (Y/N)
choice /C YN /N
if %ERRORLEVEL%==1 (
    echo A,@,76.76.19.19 | clip
    echo ✅ تم نسخ A Record!
    timeout /t 2 >nul
    echo CNAME,www,cname.vercel-dns.com | clip  
    echo ✅ تم نسخ CNAME Record!
    echo.
    echo 📋 الصق هذه القيم في لوحة تحكم مزود النطاق
)

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
echo 🌐 بعد إعداد DNS، الروابط ستعمل:
echo • https://www.firstlineon.com
echo • https://www.firstlineon.com/login
echo • https://www.firstlineon.com/dashboard
echo.
pause
