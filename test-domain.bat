@echo off
chcp 65001 >nul
color 0A
cls

echo ╔══════════════════════════════════════════════════════════════════╗
echo ║     🧪 أداة فحص DNS المتقدمة - www.firstlineon.com     ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo 📅 التاريخ: %date% - الوقت: %time%
echo ═══════════════════════════════════════════════════════════════════
echo.

:: Check for required tools
where nslookup >nul 2>&1 || (
    echo ❌ خطأ: nslookup غير متوفر
    pause
    exit /b 1
)

echo 🔍 بدء الفحص الشامل للدومين...
echo.

:: ═══════════════════════════════════════════════
:: 1. فحص Nameservers
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════╗
echo ║ 1️⃣ فحص Nameservers                    ║
echo ╚════════════════════════════════════════╝
echo.

echo 🔸 جاري فحص NS records لـ firstlineon.com...
nslookup -type=NS firstlineon.com 8.8.8.8 2>nul | findstr /i "nameserver" >temp_ns.txt
if %errorlevel% equ 0 (
    echo ✅ تم العثور على Nameservers:
    type temp_ns.txt | findstr /i "nameserver"
    
    :: Check if using Vercel nameservers
    type temp_ns.txt | findstr /i "vercel-dns.com" >nul && (
        echo.
        echo 🌟 ممتاز! تستخدم Vercel Nameservers
    ) || (
        echo.
        echo ⚠️ تستخدم nameservers خارجية - تأكد من إعدادات A/CNAME
    )
) else (
    echo ❌ لم يتم العثور على NS records
)
del temp_ns.txt 2>nul
echo.

:: ═══════════════════════════════════════════════
:: 2. فحص A Record
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════╗
echo ║ 2️⃣ فحص A Record للدومين الرئيسي      ║
echo ╚════════════════════════════════════════╝
echo.

echo 🔸 جاري فحص A record لـ firstlineon.com...
nslookup -type=A firstlineon.com 8.8.8.8 2>nul | findstr /i "Address:" | findstr /v "8.8.8.8" >temp_a.txt
if %errorlevel% equ 0 (
    for /f "tokens=2" %%a in (temp_a.txt) do set IP_ADDRESS=%%a
    echo ✅ A Record موجود: !IP_ADDRESS!
    
    :: Check if it's Vercel IP
    echo !IP_ADDRESS! | findstr "76.76.21.21" >nul && (
        echo 🌟 يستخدم Vercel IP الصحيح!
    ) || (
        echo ⚠️ يستخدم IP مختلف - تحقق من الإعدادات
    )
) else (
    echo ❌ لا يوجد A Record
)
del temp_a.txt 2>nul
echo.

:: ═══════════════════════════════════════════════
:: 3. فحص CNAME Record
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════╗
echo ║ 3️⃣ فحص CNAME Record لـ www            ║
echo ╚════════════════════════════════════════╝
echo.

echo 🔸 جاري فحص CNAME record لـ www.firstlineon.com...
nslookup -type=CNAME www.firstlineon.com 8.8.8.8 2>nul | findstr /i "canonical name" >temp_cname.txt
if %errorlevel% equ 0 (
    echo ✅ CNAME Record موجود:
    type temp_cname.txt
    
    :: Check if pointing to Vercel
    type temp_cname.txt | findstr /i "vercel" >nul && (
        echo 🌟 يشير إلى Vercel بشكل صحيح!
    )
) else (
    :: Try regular lookup as it might be A record
    nslookup www.firstlineon.com 8.8.8.8 2>nul | findstr /i "Address:" | findstr /v "8.8.8.8" >nul && (
        echo ℹ️ www يستخدم A record بدلاً من CNAME
    ) || (
        echo ❌ لا يوجد CNAME أو A record لـ www
    )
)
del temp_cname.txt 2>nul
echo.

:: ═══════════════════════════════════════════════
:: 4. فحص الاتصال والاستجابة
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════╗
echo ║ 4️⃣ فحص الاتصال والاستجابة             ║
echo ╚════════════════════════════════════════╝
echo.

echo 🔸 فحص ping للدومين...
ping -n 2 www.firstlineon.com >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ الدومين يستجيب للـ ping
) else (
    echo ⚠️ الدومين لا يستجيب للـ ping (قد يكون ICMP محظور)
)
echo.

:: ═══════════════════════════════════════════════
:: 5. فحص HTTP/HTTPS
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════╗
echo ║ 5️⃣ فحص HTTP/HTTPS Response            ║
echo ╚════════════════════════════════════════╝
echo.

echo 🔸 فحص استجابة الموقع...
curl -Is https://www.firstlineon.com 2>nul | findstr /i "HTTP" >temp_http.txt 2>nul
if %errorlevel% equ 0 (
    for /f "tokens=2" %%a in (temp_http.txt) do set HTTP_CODE=%%a
    echo ✅ استجابة HTTPS: !HTTP_CODE!
    
    if "!HTTP_CODE!"=="200" echo 🌟 الموقع يعمل بشكل مثالي!
    if "!HTTP_CODE!"=="301" echo ℹ️ يوجد إعادة توجيه
    if "!HTTP_CODE!"=="404" echo ⚠️ الصفحة غير موجودة
    if "!HTTP_CODE!"=="500" echo ❌ خطأ في الخادم
) else (
    echo ⚠️ curl غير متوفر - جاري تجربة طريقة بديلة...
    powershell -Command "try { $response = Invoke-WebRequest -Uri 'https://www.firstlineon.com' -UseBasicParsing -Method Head; Write-Host '✅ استجابة HTTPS:' $response.StatusCode } catch { Write-Host '❌ فشل الاتصال:' $_.Exception.Message }" 2>nul
)
del temp_http.txt 2>nul
echo.

:: ═══════════════════════════════════════════════
:: 6. فحص SSL Certificate
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════╗
echo ║ 6️⃣ فحص شهادة SSL                      ║
echo ╚════════════════════════════════════════╝
echo.

echo 🔸 فحص شهادة SSL...
powershell -Command "try { $request = [System.Net.HttpWebRequest]::Create('https://www.firstlineon.com'); $request.Method = 'HEAD'; $response = $request.GetResponse(); Write-Host '✅ شهادة SSL صالحة'; $response.Close() } catch { Write-Host '❌ مشكلة في SSL:' $_.Exception.Message }" 2>nul
echo.

:: ═══════════════════════════════════════════════
:: 7. ملخص النتائج
:: ═══════════════════════════════════════════════
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                     📊 ملخص النتائج                           ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

echo 🔗 الروابط للاختبار:
echo    • https://firstlineon.com
echo    • https://www.firstlineon.com
echo    • https://www.firstlineon.com/login
echo    • https://www.firstlineon.com/dashboard
echo.

echo 🌐 أدوات فحص خارجية:
echo    • DNS Checker: https://www.whatsmydns.net/#A/firstlineon.com
echo    • SSL Test: https://www.ssllabs.com/ssltest/analyze.html?d=www.firstlineon.com
echo    • DNS Propagation: https://www.whatsmydns.net/#NS/firstlineon.com
echo.

echo ⏱️ أوقات الانتشار المتوقعة:
echo    • A/CNAME Records: 5-60 دقيقة
echo    • Nameservers: 24-48 ساعة
echo    • SSL Certificate: 10-15 دقيقة بعد DNS
echo.

echo 💡 نصائح:
echo    • إذا كانت النتائج سلبية، انتظر المزيد من الوقت
echo    • تأكد من مسح DNS cache المحلي
echo    • جرب من أجهزة/شبكات مختلفة
echo.

echo ═══════════════════════════════════════════════════════════════════
echo.
echo 🎯 هل تريد فتح الموقع للاختبار؟ (اضغط Y للموافقة)
choice /c YN /n /t 10 /d N >nul
if %errorlevel% equ 1 (
    echo.
    echo 🌐 جاري فتح الروابط...
    start https://www.firstlineon.com
    timeout /t 2 >nul
    start https://www.firstlineon.com/login
    timeout /t 2 >nul
    start https://www.firstlineon.com/dashboard
)

echo.
echo 📝 تم حفظ التقرير في: domain-test-report.txt
(
    echo تقرير فحص DNS - %date% %time%
    echo ═══════════════════════════════════════════
    echo.
    echo Domain: firstlineon.com
    echo.
    echo Nameservers:
    nslookup -type=NS firstlineon.com 8.8.8.8 2>nul | findstr /i "nameserver"
    echo.
    echo A Records:
    nslookup -type=A firstlineon.com 8.8.8.8 2>nul
    echo.
    echo CNAME Records:
    nslookup -type=CNAME www.firstlineon.com 8.8.8.8 2>nul
) > domain-test-report.txt

echo.
echo ✅ اكتمل الفحص!
echo.
pause