# 🚨 إعداد DNS العاجل - خطوة بخطوة

## 📊 الوضع الحالي
- ✅ whatsmydns.net يؤكد: **لا يوجد DNS Records**
- ❌ الدومين غير مُعد: `www.firstlineon.com`
- ⏰ **المطلوب: إعداد فوري في مزود النطاق**

---

## 🔧 الخطوات المطلوبة

### الخطوة 1: الوصول لمزود النطاق
1. اذهب إلى الموقع الذي اشتريت منه `firstlineon.com`
2. سجل دخول إلى حسابك
3. ابحث عن الدومين في قائمة النطاقات

### الخطوة 2: إعداد DNS Records
ابحث عن قسم:
- **"DNS Management"**
- **"DNS Records"** 
- **"Advanced DNS"**
- **"Name Servers"**

### الخطوة 3: إضافة Records
أضف هذين الـ Records **بالضبط**:

#### A Record:
```
Type: A
Name: @ (أو فارغ)
Value: 76.76.19.19
TTL: Auto
```

#### CNAME Record:
```
Type: CNAME
Name: www
Value: cname.vercel-dns.com
TTL: Auto
```

---

## 🕒 بعد الإعداد

### الانتظار:
- **5-10 دقائق**: للتفعيل الأولي
- **30 دقيقة**: للانتشار الإقليمي
- **24 ساعة**: للانتشار العالمي الكامل

### التحقق:
1. أعد تحديث whatsmydns.net
2. ابحث عن علامات ✅ خضراء
3. اختبر الرابط: https://www.firstlineon.com

---

## 📱 مزودي النطاقات الشائعين

| المزود | مكان DNS |
|--------|-----------|
| **Namecheap** | Advanced DNS → DNS Records |
| **GoDaddy** | DNS Management → Records |
| **Cloudflare** | DNS → Records |
| **Google Domains** | DNS → Custom Records |

---

## 🆘 إذا لم تجد الإعدادات

1. ابحث في قوائم الإعدادات عن "DNS"
2. تحقق من أن النطاق لم يُحول لمزود آخر
3. تواصل مع دعم مزود النطاق
4. أرسل لهم DNS Records المطلوبة

---

## ✅ علامات النجاح

- whatsmydns.net يُظهر ✅ أخضر
- الموقع يفتح على www.firstlineon.com
- لا توجد رسائل خطأ في المتصفح

**⚡ العمل المطلوب الآن: إعداد DNS في مزود النطاق فقط!**
