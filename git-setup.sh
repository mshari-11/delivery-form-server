#!/bin/bash
echo "=== إعداد Git وإنشاء Repository ==="

# تعيين معلومات Git
git config --global user.name "First Line Logistics"
git config --global user.email "info@firstlinelog.com"

# عمل commit
git commit -m "v2.1.0 - Enhanced icons and permissions system"

echo "تم إعداد Git بنجاح!"
echo ""
echo "الخطوات التالية:"
echo "1. اذهب إلى github.com"
echo "2. أنشئ repository جديد باسم: delivery-form-server"
echo "3. انسخ رابط الـ repository"
echo "4. نفذ الأوامر التالية:"
echo ""
echo "git remote add origin [REPOSITORY_URL]"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "5. للنشر على Vercel:"
echo "   - اذهب إلى vercel.com"
echo "   - سجل دخول بـ GitHub"
echo "   - اختر Import Git Repository"
echo "   - اختر delivery-form-server"
echo "   - اضغط Deploy"
