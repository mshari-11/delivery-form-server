# 🚀 دليل DNS السريع - القيم الصحيحة من Vercel

## 📋 القيم المحدثة من Vercel Dashboard

من الصورة التي أرسلتها، القيم الصحيحة هي:

### 🌐 A Record للدومين الأساسي:
```
Type: A
Name: @ (أو firstlineon.com أو فارغ)
Value: 76.76.21.21
TTL: 300 (أو Auto/Default)
```

### 🌐 CNAME Record للدومين الفرعي:
```
Type: CNAME
Name: www
Value: f12f74b9a686d5cd.vercel-dns-016.com
TTL: 300 (أو Auto/Default)
```

---

## 🔧 خطوات الإعداد في DNS Management

### 1. الوصول لـ DNS Management
- اذهب لموقع مزود النطاق (حيث اشتريت firstlineon.com)
- ادخل لـ Control Panel أو Customer Area
- ابحث عن: DNS Settings/DNS Management/Domain Settings

### 2. إعداد A Record
```
1. اضغط Add Record أو New Record
2. Type/النوع: A
3. Name/Host: @ (أو اتركه فارغ)
4. Value/Points to: 76.76.21.21
5. TTL: 300 أو Auto
6. Save/حفظ
```

### 3. إعداد CNAME Record  
```
1. اضغط Add Record مرة أخرى
2. Type/النوع: CNAME
3. Name/Host: www
4. Value/Points to: f12f74b9a686d5cd.vercel-dns-016.com
5. TTL: 300 أو Auto
6. Save/حفظ
```

---

## ⚡ نسخ سريع للقيم

### للنسخ المباشر:
```
A Record Value: 76.76.21.21
CNAME Record Value: f12f74b9a686d5cd.vercel-dns-016.com
```

---

## 🔍 التحقق من النجاح

بعد 5-30 دقيقة من الإعداد:

### أدوات التحقق:
- [whatsmydns.net](https://whatsmydns.net/#A/www.firstlineon.com)
- [dnschecker.org](https://dnschecker.org/all-dns-records-of-domain.php?query=www.firstlineon.com)

### علامات النجاح:
- ✅ `nslookup www.firstlineon.com` يعطي: 76.76.21.21
- ✅ `https://www.firstlineon.com` يفتح الموقع
- ✅ DNS Checkers تظهر ✅ في معظم المواقع

---

## 🌐 الحلول البديلة

### إذا لم تستطع الوصول لـ DNS Management:

#### الحل الأول: Cloudflare (مُوصى به)
1. إنشاء حساب مجاني في [cloudflare.com](https://cloudflare.com)
2. إضافة الدومين `firstlineon.com`
3. إعداد DNS Records بالقيم أعلاه
4. تحديث Nameservers في مزود النطاق

#### الحل الثاني: الدعم الفني
- اتصل بمزود النطاق
- اطلب إعداد DNS Records
- أعطِ القيم: A=76.76.21.21، CNAME=f12f74b9a686d5cd.vercel-dns-016.com

---

*📝 القيم محدثة حسب Vercel Dashboard الفعلي*
