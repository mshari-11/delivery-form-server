@echo off 
chcp 65001 >nul 
cls 
echo 🧪 اختبار تلقائي للدومين... 
echo. 
echo 1️⃣ اختبار DNS A Record: 
nslookup firstlineon.com 8.8.8.8 | findstr "Address" 
echo. 
echo 2️⃣ اختبار DNS CNAME Record: 
nslookup www.firstlineon.com 8.8.8.8 | findstr "canonical" 
echo. 
echo 3️⃣ اختبار الموقع: 
curl -I https://www.firstlineon.com 2>nul || echo "الموقع لم يصبح متاحاً بعد" 
pause 
