#!/bin/bash

echo "🚀 نشر سريع إلى GitHub و Vercel..."
echo "=================================="

# إضافة جميع التغييرات
git add .

# رسالة الكوميت
git commit -m "Fix vercel.json and CSS issues - Ready for deployment"

# رفع إلى GitHub
echo "📤 رفع إلى GitHub..."
git push origin main

echo "✅ تم الرفع بنجاح!"
echo "🔗 الرابط: https://delivery-form-mshari.vercel.app"
echo "⏰ انتظر 2-3 دقائق ثم جرب الرابط"
