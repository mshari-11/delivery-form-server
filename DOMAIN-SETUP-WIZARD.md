# 🧙‍♂️ **معالج إعداد النطاق التفاعلي - Domain Setup Wizard**

<div align="center">

## 🚀 **دليل سريع لربط firstlineon.com**

[![حالة النطاق](https://img.shields.io/badge/Domain_Status-Pending-yellow)](https://delivery-form-server.vercel.app/dns-check.html)
[![Vercel](https://img.shields.io/badge/Deployed_on-Vercel-black)](https://delivery-form-server.vercel.app)

</div>

---

## 📋 **قائمة التحقق السريعة**

- [ ] لديك حساب في موقع مزود النطاق
- [ ] يمكنك الوصول لإعدادات DNS/Nameservers
- [ ] النطاق firstlineon.com مسجل وفعال
- [ ] لديك 10 دقائق لإكمال العملية

---

## 🛠️ **الأدوات المتاحة**

### 1️⃣ **واجهة الويب التفاعلية** (الأسهل)
```
🌐 افتح في المتصفح:
https://delivery-form-server.vercel.app/dns-check.html
```

### 2️⃣ **سكريبت الفحص التلقائي**
```bash
# Linux/Mac:
chmod +x setup-domain-auto.sh
./setup-domain-auto.sh

# Windows (Git Bash):
bash setup-domain-auto.sh
```

### 3️⃣ **API المباشر**
```bash
# فحص JSON
curl https://delivery-form-server.vercel.app/api/check-dns

# فحص منسق
curl -s https://delivery-form-server.vercel.app/api/check-dns | python -m json.tool
```

---

## 📝 **خطوات الربط بالتفصيل**

### **الخطوة 1: تسجيل الدخول لمزود النطاق**

<details>
<summary>🔍 <b>أين أجد مزود النطاق؟</b></summary>

- تحقق من بريدك الإلكتروني عن "domain registration" أو "domain purchase"
- المزودون الشائعون: GoDaddy, Namecheap, Google Domains, Name.com
- إذا لم تتذكر، جرب [WHOIS Lookup](https://who.is)

</details>

### **الخطوة 2: الوصول لإعدادات DNS**

<details>
<summary>📍 <b>مواقع إعدادات DNS حسب المزود</b></summary>

| المزود | المسار |
|--------|---------|
| **GoDaddy** | My Products → DNS → Manage Zones |
| **Namecheap** | Domain List → Manage → Advanced DNS |
| **Google Domains** | My domains → DNS |
| **Name.com** | My Domains → Click domain → Manage Nameservers |
| **Cloudflare** | DNS → Settings |

</details>

### **الخطوة 3: تغيير Nameservers**

#### ⚠️ **مهم جداً:**
1. **احذف** جميع nameservers الموجودة
2. **أضف فقط** هذين:

```
ns1.vercel-dns.com
ns2.vercel-dns.com
```

<details>
<summary>❌ <b>أخطاء شائعة يجب تجنبها</b></summary>

- ❌ لا تضف A records أو CNAME records
- ❌ لا تترك nameservers قديمة
- ❌ لا تضف أكثر من nameservers Vercel
- ❌ لا تنسى حفظ التغييرات

</details>

### **الخطوة 4: حفظ والانتظار**

- ✅ احفظ التغييرات
- ⏱️ انتظر 6-24 ساعة (عادة أقل)
- 🔄 استخدم أدواتنا للتحقق من التقدم

---

## 🔍 **أدوات التحقق الخارجية**

### **فحص DNS عالمياً:**
- [DNS Checker](https://dnschecker.org/#NS/firstlineon.com)
- [WhatsMyDNS](https://whatsmydns.net/#NS/firstlineon.com)
- [MXToolbox](https://mxtoolbox.com/SuperTool.aspx?action=ns%3afirstlineon.com)

### **فحص محلي:**
```bash
# Windows Command Prompt:
nslookup -type=NS firstlineon.com

# Mac/Linux Terminal:
dig NS firstlineon.com +short

# PowerShell:
Resolve-DnsName firstlineon.com -Type NS
```

---

## ✅ **علامات النجاح**

عندما ينجح الربط، ستلاحظ:

1. ✅ أدواتنا تعرض "النطاق مربوط بنجاح"
2. ✅ https://firstlineon.com يفتح موقعك
3. ✅ شهادة SSL صالحة (القفل الأخضر)
4. ✅ إعادة توجيه www تعمل

---

## ❓ **الأسئلة الشائعة**

<details>
<summary><b>كم من الوقت يستغرق انتشار DNS؟</b></summary>

- عادة: 2-6 ساعات
- أحياناً: حتى 24 ساعة
- نادراً: 48 ساعة

</details>

<details>
<summary><b>لماذا أرى "DNS_PROBE_FINISHED_NXDOMAIN"؟</b></summary>

- DNS لم ينتشر بعد
- Nameservers غير صحيحة
- النطاق غير مسجل/منتهي

</details>

<details>
<summary><b>هل يمكنني إضافة subdomain؟</b></summary>

نعم، بعد ربط النطاق الرئيسي، يمكنك إضافة subdomains من Vercel Dashboard.

</details>

---

## 🆘 **استكشاف الأخطاء**

### **المشكلة: الموقع لا يفتح بعد 24 ساعة**

```bash
# 1. تحقق من Nameservers
nslookup -type=NS firstlineon.com

# 2. تحقق من الاستجابة
curl -I https://firstlineon.com

# 3. امسح DNS cache
# Windows:
ipconfig /flushdns

# Mac:
sudo dscacheutil -flushcache

# Linux:
sudo systemctl restart systemd-resolved
```

### **المشكلة: شهادة SSL غير صالحة**

- انتظر 10-30 دقيقة بعد ربط DNS
- تحقق من أن النطاق يشير لـ Vercel
- جرب مسح cache المتصفح

---

## 📊 **تتبع التقدم**

استخدم هذا الجدول لتتبع حالة الربط:

| المرحلة | الحالة | الوقت المتوقع | ملاحظات |
|---------|--------|---------------|---------|
| تغيير NS | ⏳ | 5 دقائق | في موقع المزود |
| انتشار DNS | ⏳ | 6-24 ساعة | تحقق دورياً |
| SSL جاهز | ⏳ | 10 دقائق | بعد DNS |
| الموقع يعمل | ⏳ | مباشرة | بعد SSL |

---

## 🎯 **اختصارات مفيدة**

### **أمر واحد للفحص الكامل:**
```bash
# Linux/Mac:
curl -s https://delivery-form-server.vercel.app/api/check-dns | grep -E "(isConnected|message)"

# Windows PowerShell:
(Invoke-WebRequest https://delivery-form-server.vercel.app/api/check-dns).Content | ConvertFrom-Json | Select isConnected, message
```

### **مراقبة مستمرة:**
```bash
# فحص كل دقيقة
watch -n 60 'curl -s https://delivery-form-server.vercel.app/api/check-dns | grep isConnected'
```

---

## 📱 **دعم إضافي**

- **واجهة الفحص:** [dns-check.html](https://delivery-form-server.vercel.app/dns-check.html)
- **API التحقق:** [/api/check-dns](https://delivery-form-server.vercel.app/api/check-dns)
- **Vercel Docs:** [Custom Domains](https://vercel.com/docs/concepts/projects/domains)

---

<div align="center">

### 🎉 **بمجرد ربط النطاق، موقعك سيكون جاهزاً على:**

# [firstlineon.com](https://firstlineon.com)

---

**آخر تحديث:** 2025-07-03 | **الحالة:** في انتظار ربط DNS

</div>