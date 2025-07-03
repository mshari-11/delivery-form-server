#!/bin/bash

echo "🌐 أداة ربط النطاق التلقائية - First Line Domain Setup"
echo "=================================================="

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# المتغيرات
DOMAIN="firstlineon.com"
WWW_DOMAIN="www.firstlineon.com"
VERCEL_NS1="ns1.vercel-dns.com"
VERCEL_NS2="ns2.vercel-dns.com"
VERCEL_URL="https://delivery-form-server.vercel.app"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo -e "\n${BLUE}📅 التاريخ والوقت: $(date)${NC}"
echo -e "${BLUE}🌐 النطاق المستهدف: $DOMAIN${NC}"
echo -e "${BLUE}🔗 موقع Vercel: $VERCEL_URL${NC}\n"

# فحص DNS الحالي
echo -e "${YELLOW}📡 فحص DNS الحالي...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# محاولة استخدام nslookup
if command -v nslookup &> /dev/null; then
    current_ns=$(nslookup -type=NS $DOMAIN 2>/dev/null | grep "nameserver" | awk '{print $4}' | head -2)
# أو استخدام dig
elif command -v dig &> /dev/null; then
    current_ns=$(dig NS $DOMAIN +short 2>/dev/null | head -2)
else
    echo -e "${RED}❌ لم يتم العثور على أدوات DNS (nslookup أو dig)${NC}"
    current_ns=""
fi

if [ -z "$current_ns" ]; then
    echo -e "${RED}❌ لم يتم العثور على nameservers للنطاق${NC}"
    echo -e "${YELLOW}💡 قد يكون النطاق جديداً أو غير مُعد بعد${NC}"
else
    echo -e "${GREEN}✅ Nameservers الحالية:${NC}"
    echo "$current_ns" | while read -r ns; do
        echo -e "   • $ns"
    done
fi

# التحقق من Vercel
echo -e "\n${YELLOW}🔍 التحقق من إعدادات Vercel...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

vercel_connected=false
if [[ "$current_ns" == *"vercel-dns"* ]]; then
    echo -e "${GREEN}✅ النطاق مربوط مع Vercel!${NC}"
    vercel_connected=true
else
    echo -e "${RED}❌ النطاق غير مربوط مع Vercel${NC}"
fi

# فحص الموقع
echo -e "\n${YELLOW}🌐 فحص الموقع...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# فحص النطاق الرئيسي
echo -e "🔗 فحص https://$DOMAIN ..."
response=$(curl -s -o /dev/null -w "%{http_code}" -L https://$DOMAIN 2>/dev/null || echo "0")

if [ "$response" == "200" ]; then
    echo -e "${GREEN}✅ الموقع يعمل على النطاق الرئيسي! (كود: $response)${NC}"
elif [ "$response" == "301" ] || [ "$response" == "302" ]; then
    echo -e "${YELLOW}🔄 إعادة توجيه نشطة (كود: $response)${NC}"
else
    echo -e "${RED}❌ الموقع غير متاح على النطاق (كود: $response)${NC}"
fi

# فحص WWW
echo -e "\n🔗 فحص https://$WWW_DOMAIN ..."
www_response=$(curl -s -o /dev/null -w "%{http_code}" -L https://$WWW_DOMAIN 2>/dev/null || echo "0")

if [ "$www_response" == "200" ] || [ "$www_response" == "301" ] || [ "$www_response" == "302" ]; then
    echo -e "${GREEN}✅ نطاق WWW يعمل! (كود: $www_response)${NC}"
else
    echo -e "${YELLOW}⚠️ نطاق WWW غير متاح (كود: $www_response)${NC}"
fi

# فحص موقع Vercel
echo -e "\n🔗 فحص $VERCEL_URL ..."
vercel_response=$(curl -s -o /dev/null -w "%{http_code}" -L $VERCEL_URL 2>/dev/null || echo "0")

if [ "$vercel_response" == "200" ]; then
    echo -e "${GREEN}✅ موقع Vercel يعمل بشكل صحيح!${NC}"
else
    echo -e "${RED}❌ مشكلة في موقع Vercel (كود: $vercel_response)${NC}"
fi

# الخطوات المطلوبة
if [ "$vercel_connected" = false ]; then
    echo -e "\n${YELLOW}📝 الخطوات المطلوبة لربط النطاق:${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "1. ${BLUE}سجل دخول لموقع مزود النطاق${NC}"
    echo -e "2. ${BLUE}ابحث عن إعدادات DNS أو Nameservers${NC}"
    echo -e "3. ${BLUE}احذف جميع nameservers الحالية${NC}"
    echo -e "4. ${BLUE}أضف nameservers Vercel:${NC}"
    echo -e "   ${GREEN}• $VERCEL_NS1${NC}"
    echo -e "   ${GREEN}• $VERCEL_NS2${NC}"
    echo -e "5. ${BLUE}احفظ التغييرات${NC}"
    echo -e "6. ${BLUE}انتظر 6-24 ساعة لانتشار DNS${NC}"
    
    echo -e "\n${YELLOW}💡 نصائح:${NC}"
    echo -e "• تأكد من حذف ${RED}جميع${NC} nameservers القديمة"
    echo -e "• أضف nameservers Vercel ${GREEN}فقط${NC}"
    echo -e "• لا تضف A records أو CNAME - Vercel سيديرها تلقائياً"
fi

# إنشاء تقرير
echo -e "\n${YELLOW}📊 إنشاء تقرير...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

report_file="domain-status-$TIMESTAMP.txt"
cat > $report_file << EOF
=====================================
تقرير حالة النطاق - Domain Status Report
=====================================
التاريخ: $(date)
النطاق: $DOMAIN

معلومات DNS:
------------
Nameservers الحالية:
$current_ns

حالة الربط مع Vercel: $(if [ "$vercel_connected" = true ]; then echo "✅ مربوط"; else echo "❌ غير مربوط"; fi)

حالة الموقع:
-----------
- النطاق الرئيسي ($DOMAIN): $response
- نطاق WWW ($WWW_DOMAIN): $www_response
- موقع Vercel: $vercel_response

Nameservers المطلوبة:
-------------------
1. $VERCEL_NS1
2. $VERCEL_NS2

ملاحظات:
--------
$(if [ "$vercel_connected" = true ]; then
    echo "✅ النطاق مربوط بنجاح مع Vercel"
    if [ "$response" != "200" ]; then
        echo "⚠️ لكن الموقع لم يُفعل بعد على النطاق"
    fi
else
    echo "❌ يجب تحديث nameservers في موقع مزود النطاق"
fi)

=====================================
نهاية التقرير
=====================================
EOF

echo -e "${GREEN}✅ تم حفظ التقرير في: $report_file${NC}"

# ملخص نهائي
echo -e "\n${BLUE}📋 الملخص النهائي:${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$vercel_connected" = true ] && [ "$response" == "200" ]; then
    echo -e "${GREEN}🎉 ممتاز! النطاق مربوط ويعمل بشكل كامل!${NC}"
    echo -e "${GREEN}✅ يمكنك الوصول لموقعك عبر: https://$DOMAIN${NC}"
elif [ "$vercel_connected" = true ]; then
    echo -e "${YELLOW}⏳ النطاق مربوط لكن يحتاج وقت للتفعيل الكامل${NC}"
    echo -e "${YELLOW}💡 انتظر 10-30 دقيقة وأعد المحاولة${NC}"
else
    echo -e "${RED}⚠️ النطاق يحتاج لتحديث nameservers${NC}"
    echo -e "${YELLOW}📝 اتبع الخطوات المذكورة أعلاه${NC}"
fi

echo -e "\n${BLUE}🔄 لإعادة الفحص، شغّل هذا الأمر مرة أخرى${NC}"
echo -e "${BLUE}📄 راجع التقرير: cat $report_file${NC}"
echo -e "\n${GREEN}شكراً لاستخدام أداة ربط النطاق! 🚀${NC}"