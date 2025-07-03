#!/bin/bash

# مراقب DNS البسيط
echo "🔍 مراقب DNS - First Line Domain"
echo "================================="
echo "النطاق: firstlineon.com"
echo "فحص كل: 5 دقائق"
echo ""

while true; do
    echo "[$(date '+%H:%M:%S')] جاري الفحص..."
    
    # فحص nameservers
    ns_check=$(nslookup -type=NS firstlineon.com 2>&1 | grep -c "vercel-dns")
    
    # فحص الموقع
    http_code=$(curl -s -o /dev/null -w "%{http_code}" https://firstlineon.com 2>/dev/null)
    
    if [ "$ns_check" -gt 0 ] && [ "$http_code" = "200" ]; then
        echo "✅ النطاق مربوط ويعمل!"
        echo "🔗 https://firstlineon.com"
        echo ""
        echo "يمكنك إيقاف المراقبة (Ctrl+C)"
    elif [ "$ns_check" -gt 0 ]; then
        echo "⏳ Nameservers صحيحة، في انتظار التفعيل..."
    else
        echo "❌ في انتظار تحديث Nameservers"
        echo "   المطلوب: ns1.vercel-dns.com"
        echo "           ns2.vercel-dns.com"
    fi
    
    echo "---"
    sleep 300  # 5 دقائق
done