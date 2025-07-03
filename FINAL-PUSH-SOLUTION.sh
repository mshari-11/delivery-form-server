#!/bin/bash

echo "🚀 حل Git Push النهائي - First Line"
echo "===================================="
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# عرض الحالة
echo -e "${YELLOW}📊 حالة المستودع:${NC}"
commits_count=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "1")
echo -e "لديك ${BLUE}$commits_count${NC} commit غير مدفوع"
echo ""

# عرض الخيارات
echo -e "${YELLOW}🔧 الحلول المتاحة:${NC}"
echo ""
echo -e "${GREEN}1. GitHub Desktop${NC} (الأسهل)"
echo "   - افتح البرنامج واضغط Push"
echo ""
echo -e "${GREEN}2. Personal Access Token${NC} (5 دقائق)"
echo "   - اتبع الدليل: PERSONAL-ACCESS-TOKEN-GUIDE.md"
echo "   - أو استخدم الأمر من: ONE-COMMAND-PUSH.txt"
echo ""
echo -e "${GREEN}3. الملفات المضغوطة${NC} (جاهزة)"
echo "   - all-changes-20250703.tar.gz (95KB)"
echo "   - latest-commit.patch (39KB)"
echo ""
echo -e "${GREEN}4. الرفع اليدوي${NC}"
echo "   - manual-upload-guide.md"
echo ""

# اختيار سريع
echo -e "${YELLOW}📝 للبدء السريع:${NC}"
echo ""
echo "1. أنشئ Personal Access Token:"
echo "   ${BLUE}https://github.com/settings/tokens${NC}"
echo ""
echo "2. انسخ هذا الأمر واستبدل TOKEN:"
echo ""
echo -e "${BLUE}git push https://TOKEN@github.com/mshari-11/delivery-form-server.git main${NC}"
echo ""
echo "3. الصق في Terminal واضغط Enter"
echo ""

# الملفات المرجعية
echo -e "${YELLOW}📚 الملفات المساعدة:${NC}"
echo "- PERSONAL-ACCESS-TOKEN-GUIDE.md - دليل مفصل بالصور"
echo "- ONE-COMMAND-PUSH.txt - أمر جاهز للنسخ"
echo "- all-changes-20250703.tar.gz - جميع الملفات مضغوطة"
echo "- manual-upload-guide.md - الرفع اليدوي"
echo ""

# رسالة نهائية
echo -e "${GREEN}✨ نصيحة:${NC}"
echo "أسرع طريقة = GitHub Desktop إذا كان مثبتاً"
echo "أو Personal Access Token (5 دقائق فقط)"
echo ""
echo -e "${BLUE}بالتوفيق! 🚀${NC}"