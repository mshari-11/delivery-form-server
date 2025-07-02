# 🌐 إعدادات DNS لربط الدومين المخصص

## معلومات الدومين
- **الدومين**: firstlineon.com
- **النطاق الفرعي**: www.firstlineon.com  
- **المشروع**: delivery-form-mshari
- **Vercel URL**: https://delivery-form-mshari.vercel.app

## 📋 DNS Records المطلوبة

### 1. A Record (للدومين الرئيسي)
```
Type: A
Name: @
Value: 76.76.19.19
TTL: Auto
```

### 2. CNAME Record (للنطاق الفرعي)
```
Type: CNAME  
Name: www
Value: cname.vercel-dns.com
TTL: Auto
```

### 3. CAA Record (اختياري - للأمان)
```
Type: CAA
Name: @
Value: 0 issue "letsencrypt.org"
TTL: Auto
```

## 🔍 التحقق من الإعدادات

بعد إضافة DNS Records:

1. انتظر 5-10 دقائق
2. ارجع إلى Vercel Dashboard
3. تحقق من حالة الدومين
4. يجب أن تظهر علامة ✅ خضراء

## 🌟 الروابط النهائية بعد الربط

- **الموقع الرئيسي**: https://www.firstlineon.com
- **تسجيل الدخول**: https://www.firstlineon.com/login
- **لوحة التحكم**: https://www.firstlineon.com/dashboard  
- **نموذج التسجيل**: https://www.firstlineon.com/form-complete.html

## 📞 معلومات الدعم

إذا واجهت مشاكل:
- تأكد من صحة DNS Records
- انتظر حتى 24 ساعة للانتشار الكامل
- تحقق من لوحة تحكم مزود النطاق
