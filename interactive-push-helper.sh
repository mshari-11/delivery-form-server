#!/bin/bash

# سكريبت تفاعلي لمساعدتك في Push
echo "🚀 مساعد Git Push التفاعلي"
echo "=========================="
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# دالة لفتح المتصفح
open_browser() {
    url=$1
    if command -v xdg-open &> /dev/null; then
        xdg-open "$url"
    elif command -v open &> /dev/null; then
        open "$url"
    elif command -v start &> /dev/null; then
        start "$url"
    else
        echo -e "${YELLOW}افتح هذا الرابط يدوياً:${NC}"
        echo "$url"
    fi
}

# الخطوة 1: عرض التعليمات
echo -e "${BLUE}📝 الخطوات:${NC}"
echo "1. سأفتح لك صفحة إنشاء Personal Access Token"
echo "2. اتبع التعليمات في الصفحة"
echo "3. انسخ الـ Token"
echo "4. ارجع هنا والصقه"
echo ""

# سؤال المستخدم
echo -e "${YELLOW}هل أنت جاهز للبدء؟ (y/n)${NC}"
read -p "> " ready

if [[ ! "$ready" =~ ^[Yy]$ ]]; then
    echo "حسناً، يمكنك تشغيل السكريبت مرة أخرى عندما تكون جاهزاً"
    exit 0
fi

# الخطوة 2: فتح صفحة GitHub
echo ""
echo -e "${GREEN}🌐 فتح صفحة GitHub...${NC}"
echo -e "${YELLOW}إذا لم يفتح المتصفح، افتح هذا الرابط:${NC}"
echo "https://github.com/settings/tokens/new"
echo ""

# فتح المتصفح
open_browser "https://github.com/settings/tokens/new"

# الخطوة 3: إرشادات إنشاء Token
echo -e "${BLUE}📋 في صفحة GitHub:${NC}"
echo "1. في خانة 'Note': اكتب 'Delivery Form Server'"
echo "2. في 'Expiration': اختر '90 days'"
echo "3. في 'Select scopes': ضع علامة على 'repo' (الصندوق الرئيسي)"
echo "4. انزل للأسفل واضغط 'Generate token'"
echo "5. انسخ الـ Token (يبدأ بـ ghp_)"
echo ""

# الخطوة 4: إدخال Token
echo -e "${YELLOW}📥 الصق الـ Personal Access Token هنا:${NC}"
echo -e "${RED}(ملاحظة: لن يظهر الـ token أثناء الكتابة لأسباب أمنية)${NC}"
read -s -p "Token: " token
echo ""

# التحقق من Token
if [[ -z "$token" ]]; then
    echo -e "${RED}❌ لم تدخل token${NC}"
    exit 1
fi

if [[ ! "$token" =~ ^ghp_ ]]; then
    echo -e "${YELLOW}⚠️  تحذير: الـ token عادة يبدأ بـ ghp_${NC}"
    echo "هل تريد المتابعة؟ (y/n)"
    read -p "> " continue
    if [[ ! "$continue" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# الخطوة 5: تنفيذ Push
echo ""
echo -e "${GREEN}🚀 تنفيذ Push...${NC}"
echo ""

# إنشاء الأمر
push_url="https://${token}@github.com/mshari-11/delivery-form-server.git"

# محاولة Push
git push "$push_url" main 2>&1 | while IFS= read -r line; do
    echo "$line"
    if [[ "$line" == *"Everything up-to-date"* ]]; then
        echo ""
        echo -e "${GREEN}✅ كل شيء محدث بالفعل!${NC}"
        saved=true
    fi
    if [[ "$line" == *"main -> main"* ]]; then
        echo ""
        echo -e "${GREEN}✅ تم Push بنجاح!${NC}"
        saved=true
    fi
done

# حفظ Token للمستقبل (اختياري)
if [ "$saved" = true ]; then
    echo ""
    echo -e "${YELLOW}هل تريد حفظ الـ token للاستخدام المستقبلي؟ (y/n)${NC}"
    read -p "> " save_token
    
    if [[ "$save_token" =~ ^[Yy]$ ]]; then
        git remote set-url origin "$push_url"
        echo -e "${GREEN}✅ تم حفظ الإعدادات${NC}"
        echo "يمكنك الآن استخدام: git push origin main"
    fi
fi

echo ""
echo -e "${BLUE}📊 النتيجة النهائية:${NC}"
if git status | grep -q "Your branch is up to date"; then
    echo -e "${GREEN}✅ جميع التغييرات مدفوعة بنجاح!${NC}"
    echo ""
    echo -e "${GREEN}🎉 ممتاز! يمكنك الآن:${NC}"
    echo "1. زيارة: https://delivery-form-server.vercel.app/dns-check.html"
    echo "2. متابعة ربط DNS"
else
    echo -e "${YELLOW}⚠️  قد تحتاج لمحاولة أخرى${NC}"
fi