#!/bin/bash

# ===========================================
# 🎯 إعداد الدومين النهائي - خطوة بخطوة
# ===========================================

echo "🚀 بدء إعداد الدومين النهائي..."

# 1. التحقق من حالة Vercel
echo "📋 التحقق من حالة المشروع..."
vercel list

# 2. فتح إعدادات الدومين
echo "🌐 فتح إعدادات الدومين في المتصفح..."
start https://vercel.com/mshari-as-projects/delivery-form-server/settings/domains

# 3. تعليمات الإعداد
echo ""
echo "🔧 خطوات الإعداد اليدوي:"
echo "=================================="
echo "1. انقر على 'Add Domain'"
echo "2. اكتب: firstlineon.com"
echo "3. اختر: 'Add & Configure'"
echo "4. انسخ Nameservers المعروضة"
echo "5. انتقل لمزود النطاق وحدث الـ Nameservers"
echo ""

# 4. فحص DNS
echo "🔍 فحص DNS الحالي..."
nslookup firstlineon.com

echo ""
echo "✅ انتهى الإعداد!"
echo "💡 ملاحظة: بعد تحديث Nameservers، انتظر 6-48 ساعة لانتشار DNS"

pause
