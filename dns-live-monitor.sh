#!/bin/bash

# مراقب DNS المباشر
echo "🔍 مراقب DNS المباشر - First Line"
echo "================================"
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# المتغيرات
DOMAIN="firstlineon.com"
CHECK_INTERVAL=60  # فحص كل دقيقة
VERCEL_NS1="ns1.vercel-dns.com"
VERCEL_NS2="ns2.vercel-dns.com"
LOG_FILE="dns-monitor-$(date +%Y%m%d).log"
START_TIME=$(date +%s)

# دالة شريط التقدم
progress_bar() {
    local progress=$1
    local total=50
    local filled=$((progress * total / 100))
    local empty=$((total - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%" "$progress"
}

# دالة حساب الوقت المنقضي
elapsed_time() {
    local current=$(date +%s)
    local elapsed=$((current - START_TIME))
    local hours=$((elapsed / 3600))
    local minutes=$(((elapsed % 3600) / 60))
    local seconds=$((elapsed % 60))
    printf "%02d:%02d:%02d" $hours $minutes $seconds
}

# دالة الفحص الشامل
check_dns_status() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}🕐 الوقت: $(date +"%Y-%m-%d %H:%M:%S")${NC}"
    echo -e "${BLUE}⏱️  المدة: $(elapsed_time)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    local status_points=0
    local total_points=5
    
    # 1. فحص تسجيل النطاق
    echo -ne "${YELLOW}1. فحص تسجيل النطاق...${NC} "
    if host $DOMAIN 8.8.8.8 &>/dev/null || nslookup $DOMAIN &>/dev/null; then
        echo -e "${GREEN}✅ مُسجل${NC}"
        ((status_points++))
    else
        echo -e "${RED}❌ غير مُسجل${NC}"
        echo -e "${RED}   ⚠️  يجب تسجيل النطاق أولاً من أحد مزودي النطاقات${NC}"
        return 0
    fi
    
    # 2. فحص Nameservers
    echo -ne "${YELLOW}2. فحص Nameservers...${NC} "
    local ns_check=$(dig NS $DOMAIN +short 2>/dev/null || nslookup -type=NS $DOMAIN 2>/dev/null | grep nameserver)
    
    if [[ "$ns_check" == *"vercel-dns"* ]]; then
        echo -e "${GREEN}✅ مربوط مع Vercel${NC}"
        ((status_points++))
    else
        echo -e "${RED}❌ غير مربوط مع Vercel${NC}"
        echo -e "${YELLOW}   الحالية: ${NC}"
        echo "$ns_check" | sed 's/^/     /'
    fi
    
    # 3. فحص A Records
    echo -ne "${YELLOW}3. فحص A Records...${NC} "
    local a_records=$(dig A $DOMAIN +short 2>/dev/null)
    
    if [[ -n "$a_records" ]]; then
        echo -e "${GREEN}✅ موجودة${NC}"
        echo -e "${CYAN}   IP: $a_records${NC}"
        ((status_points++))
    else
        echo -e "${YELLOW}⏳ في انتظار التحديث${NC}"
    fi
    
    # 4. فحص الموقع
    echo -ne "${YELLOW}4. فحص الموقع...${NC} "
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" -m 5 https://$DOMAIN 2>/dev/null)
    
    if [[ "$http_code" == "200" ]]; then
        echo -e "${GREEN}✅ يعمل بنجاح!${NC}"
        ((status_points++))
    elif [[ "$http_code" == "301" ]] || [[ "$http_code" == "302" ]]; then
        echo -e "${GREEN}✅ إعادة توجيه نشطة${NC}"
        ((status_points++))
    else
        echo -e "${RED}❌ غير متاح (HTTP $http_code)${NC}"
    fi
    
    # 5. فحص SSL
    echo -ne "${YELLOW}5. فحص شهادة SSL...${NC} "
    if timeout 5 openssl s_client -connect $DOMAIN:443 -servername $DOMAIN </dev/null 2>/dev/null | grep -q "Verify return code: 0"; then
        echo -e "${GREEN}✅ صالحة${NC}"
        ((status_points++))
    else
        echo -e "${YELLOW}⏳ في انتظار التفعيل${NC}"
    fi
    
    # عرض النتيجة الإجمالية
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    local percentage=$((status_points * 100 / total_points))
    
    echo -ne "${BLUE}التقدم الكلي: ${NC}"
    progress_bar $percentage
    echo ""
    
    if [[ $percentage -eq 100 ]]; then
        echo -e "\n${GREEN}🎉 ممتاز! النطاق مربوط ويعمل بشكل كامل!${NC}"
        echo -e "${GREEN}✅ يمكنك الآن زيارة: https://$DOMAIN${NC}"
        return 1  # نجح - أوقف المراقبة
    elif [[ $percentage -ge 60 ]]; then
        echo -e "\n${YELLOW}⏳ تقدم جيد - الربط في طريقه للاكتمال${NC}"
    else
        echo -e "\n${RED}⚠️  يحتاج المزيد من الوقت أو الإجراءات${NC}"
    fi
    
    # حفظ في السجل
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Status: $percentage% - Points: $status_points/$total_points" >> $LOG_FILE
    
    return 0  # استمر بالمراقبة
}

# دالة الإشعار
notify_success() {
    # صوت (Windows)
    if command -v powershell &>/dev/null; then
        powershell -c "[console]::beep(1000,500); [console]::beep(1500,500); [console]::beep(2000,500)"
    fi
    
    # رسالة
    echo -e "\n${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║      🎊 تم ربط النطاق بنجاح! 🎊         ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
}

# البداية
clear
echo -e "${BLUE}🎯 مراقبة النطاق: $DOMAIN${NC}"
echo -e "${BLUE}🔄 فحص كل: $CHECK_INTERVAL ثانية${NC}"
echo -e "${BLUE}📝 السجل: $LOG_FILE${NC}"
echo -e "${YELLOW}⏹️  للإيقاف: Ctrl+C${NC}\n"

# حفظ بداية المراقبة
echo "========================================" >> $LOG_FILE
echo "بدء المراقبة: $(date)" >> $LOG_FILE
echo "النطاق: $DOMAIN" >> $LOG_FILE
echo "========================================" >> $LOG_FILE

# حلقة المراقبة الرئيسية
check_count=0
while true; do
    ((check_count++))
    
    echo -e "\n${BLUE}🔄 الفحص رقم: $check_count${NC}"
    
    if check_dns_status; then
        # استمر بالمراقبة
        echo -e "\n${YELLOW}⏳ الفحص التالي بعد $CHECK_INTERVAL ثانية...${NC}"
        
        # عداد تنازلي مع شريط تقدم
        for ((i=$CHECK_INTERVAL; i>0; i--)); do
            printf "\r${CYAN}⏱️  باقي: %02d ثانية ${NC}" $i
            sleep 1
        done
        printf "\r                                        \r"  # مسح السطر
    else
        # نجح الربط
        notify_success
        echo -e "\n${GREEN}✅ انتهت المراقبة - النطاق جاهز!${NC}"
        echo "انتهت المراقبة بنجاح: $(date)" >> $LOG_FILE
        break
    fi
done

# عرض ملخص نهائي
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 ملخص المراقبة:${NC}"
echo -e "• عدد الفحوصات: $check_count"
echo -e "• المدة الكلية: $(elapsed_time)"
echo -e "• السجل محفوظ في: $LOG_FILE"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${GREEN}شكراً لاستخدام مراقب DNS! 🚀${NC}"