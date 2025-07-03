#!/bin/bash

# بوت Git Push التلقائي
echo "🤖 بوت Git Push التلقائي"
echo "======================="
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# دالة للانتظار مع عرض النقاط
wait_with_dots() {
    local seconds=$1
    local message=$2
    echo -n "$message"
    for ((i=1; i<=seconds; i++)); do
        echo -n "."
        sleep 1
    done
    echo ""
}

# الخطوة 1: فحص الحالة
echo -e "${YELLOW}📊 فحص حالة Git...${NC}"
if git status | grep -q "Your branch is ahead"; then
    echo -e "${GREEN}✅ لديك commits جاهزة للدفع${NC}"
else
    echo -e "${YELLOW}⚠️  لا توجد commits للدفع${NC}"
    exit 0
fi

# الخطوة 2: محاولة push عادي أولاً
echo ""
echo -e "${YELLOW}🔄 محاولة Push عادي...${NC}"
if timeout 5s git push origin main 2>&1 | grep -q "Everything up-to-date\|main -> main"; then
    echo -e "${GREEN}✅ تم Push بنجاح!${NC}"
    exit 0
fi

# الخطوة 3: إرشادات سريعة
echo ""
echo -e "${RED}❌ يحتاج مصادقة${NC}"
echo ""
echo -e "${BLUE}🚀 الحل السريع:${NC}"
echo ""
echo "1️⃣  افتح هذا الملف في المتصفح:"
echo -e "${GREEN}   git-push-helper.html${NC}"
echo ""
echo "2️⃣  أو استخدم GitHub Desktop"
echo ""
echo "3️⃣  أو أنشئ Personal Access Token:"
echo "   • افتح: https://github.com/settings/tokens"
echo "   • Generate new token (classic)"
echo "   • اختر: repo"
echo "   • انسخ الـ token"
echo ""

# الخطوة 4: خيار تفاعلي
echo -e "${YELLOW}هل لديك Personal Access Token جاهز؟ (y/n)${NC}"
read -p "> " has_token

if [[ "$has_token" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}الصق الـ Token هنا:${NC}"
    read -s token
    echo ""
    
    if [[ -n "$token" ]]; then
        echo -e "${BLUE}🚀 محاولة Push مع Token...${NC}"
        git push "https://${token}@github.com/mshari-11/delivery-form-server.git" main 2>&1 | while read line; do
            echo "$line"
            if [[ "$line" == *"main -> main"* ]]; then
                echo -e "\n${GREEN}✅ تم Push بنجاح!${NC}"
                echo -e "${YELLOW}هل تريد حفظ الـ Token؟ (y/n)${NC}"
                read -p "> " save
                if [[ "$save" =~ ^[Yy]$ ]]; then
                    git remote set-url origin "https://${token}@github.com/mshari-11/delivery-form-server.git"
                    echo -e "${GREEN}✅ تم الحفظ${NC}"
                fi
            fi
        done
    fi
else
    # فتح المساعد
    echo ""
    echo -e "${BLUE}📖 فتح المساعد التفاعلي...${NC}"
    
    # محاولة فتح الملف
    if command -v xdg-open &> /dev/null; then
        xdg-open git-push-helper.html
    elif command -v open &> /dev/null; then
        open git-push-helper.html
    elif command -v start &> /dev/null; then
        start git-push-helper.html
    else
        echo -e "${YELLOW}افتح يدوياً: git-push-helper.html${NC}"
    fi
fi

echo ""
echo -e "${GREEN}📚 الملفات المساعدة:${NC}"
echo "• git-push-helper.html - واجهة تفاعلية"
echo "• PERSONAL-ACCESS-TOKEN-GUIDE.md - دليل مفصل"
echo "• ONE-COMMAND-PUSH.txt - أمر جاهز"
echo ""
echo -e "${BLUE}بالتوفيق! 🚀${NC}"