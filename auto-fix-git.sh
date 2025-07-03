#!/bin/bash

echo "🔧 أداة إصلاح Git التلقائية"
echo "=========================="
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# فحص حالة Git
echo -e "${YELLOW}📊 فحص حالة Git...${NC}"
git_status=$(git status --porcelain 2>&1)
branch_status=$(git status -sb 2>&1)

if [[ "$branch_status" == *"ahead"* ]]; then
    echo -e "${YELLOW}⚠️  لديك commits غير مدفوعة${NC}"
    commits_ahead=$(echo "$branch_status" | grep -o '[0-9]* ahead' | grep -o '[0-9]*')
    echo -e "${BLUE}📝 عدد الـ commits: $commits_ahead${NC}"
fi

# محاولة إصلاح المصادقة
echo -e "\n${YELLOW}🔐 محاولة إصلاح المصادقة...${NC}"

# الخيار 1: استخدام credential helper
echo -e "${BLUE}1️⃣ تجربة credential helper...${NC}"
git config --global credential.helper manager-core 2>/dev/null || \
git config --global credential.helper manager 2>/dev/null || \
git config --global credential.helper wincred 2>/dev/null

# الخيار 2: فحص gh CLI
if command -v gh &> /dev/null; then
    echo -e "${GREEN}✅ gh CLI متوفر${NC}"
    echo -e "${BLUE}جرب: gh auth login${NC}"
else
    echo -e "${YELLOW}❌ gh CLI غير مثبت${NC}"
    echo -e "${BLUE}للتثبيت: https://cli.github.com/${NC}"
fi

# الخيار 3: إنشاء أمر push مع token
echo -e "\n${YELLOW}📋 إنشاء أوامر جاهزة...${NC}"

# حفظ الأوامر في ملف
cat > git-push-commands.txt << 'EOF'
# أوامر Push جاهزة للاستخدام

## 1. Push عادي (جرب أولاً):
git push origin main

## 2. Push مع Personal Access Token:
git push https://YOUR_GITHUB_TOKEN@github.com/mshari-11/delivery-form-server.git main

## 3. استخدام gh CLI:
gh auth login
gh repo sync

## 4. إنشاء Personal Access Token:
1. اذهب إلى: https://github.com/settings/tokens
2. اضغط "Generate new token (classic)"
3. اختر صلاحيات: repo (كاملة)
4. انسخ الـ token
5. استبدل YOUR_GITHUB_TOKEN في الأمر أعلاه

## 5. حفظ Token بشكل دائم:
git remote set-url origin https://YOUR_GITHUB_TOKEN@github.com/mshari-11/delivery-form-server.git
EOF

echo -e "${GREEN}✅ تم حفظ الأوامر في: git-push-commands.txt${NC}"

# محاولة push تلقائية
echo -e "\n${YELLOW}🚀 محاولة push تلقائية...${NC}"
echo -e "${BLUE}سأحاول الآن: git push origin main${NC}"
echo ""

# تشغيل push مع timeout
timeout 30s git push origin main 2>&1 | while IFS= read -r line; do
    echo "$line"
    if [[ "$line" == *"Username"* ]] || [[ "$line" == *"Password"* ]]; then
        echo -e "\n${RED}❌ يطلب المصادقة${NC}"
        echo -e "${YELLOW}📝 راجع git-push-commands.txt للحلول${NC}"
        exit 1
    fi
    if [[ "$line" == *"Everything up-to-date"* ]] || [[ "$line" == *"main -> main"* ]]; then
        echo -e "\n${GREEN}✅ تم Push بنجاح!${NC}"
        exit 0
    fi
done

# إذا فشل، عرض البدائل
if [ $? -ne 0 ]; then
    echo -e "\n${YELLOW}🔧 البدائل المتاحة:${NC}"
    echo -e "1. ${BLUE}GitHub Desktop${NC} - الأسهل"
    echo -e "2. ${BLUE}Personal Access Token${NC} - راجع git-push-commands.txt"
    echo -e "3. ${BLUE}gh CLI${NC} - https://cli.github.com/"
    echo -e "4. ${BLUE}الرفع اليدوي${NC} - راجع manual-upload-guide.md"
fi

echo -e "\n${GREEN}📄 الملفات المرجعية:${NC}"
echo "- git-push-commands.txt - أوامر جاهزة"
echo "- GIT-PUSH-INSTRUCTIONS.md - دليل شامل"
echo "- manual-upload-guide.md - الرفع اليدوي"