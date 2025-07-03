#!/bin/bash

# سكريبت مراقبة DNS التلقائي
# يفحص حالة DNS كل 5 دقائق ويُشعرك عند النجاح

echo "🔍 مراقب DNS التلقائي - First Line"
echo "=================================="
echo ""

# المتغيرات
DOMAIN="firstlineon.com"
CHECK_URL="https://delivery-form-server.vercel.app/api/check-dns"
LOG_FILE="dns-monitor-log.txt"
CHECK_INTERVAL=300  # 5 دقائق

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# بدء السجل
echo "بدء المراقبة: $(date)" > $LOG_FILE
echo "" >> $LOG_FILE

# دالة الفحص
check_dns() {
    echo -e "${YELLOW}⏱️  $(date +"%H:%M:%S") - فحص حالة DNS...${NC}"
    
    # فحص عبر API
    response=$(curl -s $CHECK_URL 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # استخراج حالة الربط من JSON
        is_connected=$(echo $response | grep -o '"isConnected":[^,]*' | cut -d':' -f2)
        
        if [ "$is_connected" = "true" ]; then
            echo -e "${GREEN}✅ ممتاز! النطاق مربوط بنجاح!${NC}"
            echo "$(date) - النطاق مربوط بنجاح!" >> $LOG_FILE
            
            # إشعار صوتي (Windows)
            if command -v powershell &> /dev/null; then
                powershell -c "[console]::beep(1000,500)"
            fi
            
            echo -e "${GREEN}🎉 يمكنك الآن زيارة: https://$DOMAIN${NC}"
            return 0
        else
            echo -e "${RED}❌ النطاق غير مربوط بعد${NC}"
            echo "$(date) - النطاق غير مربوط" >> $LOG_FILE
        fi
    else
        echo -e "${YELLOW}⚠️  فشل الاتصال بـ API${NC}"
    fi
    
    # فحص محلي بديل
    if command -v curl &> /dev/null; then
        site_check=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN 2>/dev/null)
        if [ "$site_check" = "200" ]; then
            echo -e "${GREEN}✅ الموقع يعمل على النطاق!${NC}"
            return 0
        fi
    fi
    
    return 1
}

# حساب الوقت المتبقي
calculate_remaining_time() {
    start_time=$(date +%s)
    max_wait=86400  # 24 ساعة
    
    elapsed=$(($(date +%s) - start_time))
    remaining=$((max_wait - elapsed))
    
    if [ $remaining -gt 0 ]; then
        hours=$((remaining / 3600))
        minutes=$(((remaining % 3600) / 60))
        echo -e "${BLUE}⏰ الوقت المتبقي المتوقع: ${hours} ساعة و ${minutes} دقيقة${NC}"
    fi
}

# رسالة البداية
echo -e "${BLUE}🎯 مراقبة النطاق: $DOMAIN${NC}"
echo -e "${BLUE}🔄 فحص كل: 5 دقائق${NC}"
echo -e "${BLUE}📝 السجل في: $LOG_FILE${NC}"
echo ""
echo -e "${YELLOW}💡 نصيحة: اضغط Ctrl+C للإيقاف${NC}"
echo ""

# حلقة المراقبة
check_count=0
while true; do
    check_count=$((check_count + 1))
    echo -e "${BLUE}--- فحص رقم $check_count ---${NC}"
    
    if check_dns; then
        echo -e "${GREEN}🎊 تم ربط النطاق بنجاح!${NC}"
        break
    fi
    
    calculate_remaining_time
    
    echo -e "${YELLOW}⏳ الفحص التالي بعد 5 دقائق...${NC}"
    echo ""
    
    # الانتظار مع إمكانية الإيقاف
    for i in {1..300}; do
        sleep 1
        if [ $((i % 60)) -eq 0 ]; then
            minutes_left=$((5 - i/60))
            echo -ne "\r${YELLOW}⏱️  باقي $minutes_left دقائق للفحص التالي...${NC}"
        fi
    done
    echo ""
done

echo ""
echo -e "${GREEN}🎉 انتهت المراقبة - النطاق جاهز!${NC}"
echo "السجل الكامل في: $LOG_FILE"