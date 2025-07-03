# 📤 **دليل الرفع اليدوي - Manual Upload Guide**

## 🎯 **إذا فشل git push، استخدم هذه الطرق:**

---

## **الطريقة 1: GitHub Web Interface** (الأسهل)

### 📋 **الخطوات:**

1. **افتح المستودع:**
   ```
   https://github.com/mshari-11/delivery-form-server
   ```

2. **ارفع الملفات الجديدة:**
   - اضغط "Add file" → "Upload files"
   - اسحب هذه الملفات:
     ```
     ✅ public/dns-check.html
     ✅ api/check-dns.js
     ✅ DOMAIN-SETUP-WIZARD.md
     ✅ FINAL-STEPS.md
     ✅ monitor-dns.sh
     ✅ .gitattributes
     ✅ auto-fix-git.sh
     ```

3. **حدث الملفات المعدلة:**
   - افتح كل ملف واضغط "Edit"
   - انسخ المحتوى من ملفك المحلي
   - الصق واحفظ
   - الملفات المحدثة:
     ```
     📝 package.json
     📝 README.md
     📝 خطة-الإنهاء-النهائية.md
     ```

4. **أنشئ Commit:**
   - في الأسفل، اكتب:
     ```
     🚀 إضافة أدوات ربط النطاق المتكاملة
     ```
   - اضغط "Commit changes"

---

## **الطريقة 2: استخدام ZIP**

### 📦 **إنشاء ملف ZIP:**

```bash
# أنشئ ZIP بالملفات المعدلة
zip -r changes-2025-07-03.zip \
  public/dns-check.html \
  api/check-dns.js \
  DOMAIN-SETUP-WIZARD.md \
  FINAL-STEPS.md \
  monitor-dns.sh \
  .gitattributes \
  auto-fix-git.sh \
  manual-upload-guide.md \
  package.json \
  README.md
```

### 📤 **ارفع عبر GitHub:**
1. اذهب لـ Issues في المستودع
2. أنشئ issue جديد
3. ارفق ملف ZIP
4. اطلب من شخص له صلاحيات أن يطبق التغييرات

---

## **الطريقة 3: نسخ المحتوى**

### 📋 **الملفات الجديدة للنسخ:**

<details>
<summary><b>1. public/dns-check.html</b></summary>

```html
[انسخ محتوى الملف من المشروع المحلي]
```
</details>

<details>
<summary><b>2. api/check-dns.js</b></summary>

```javascript
[انسخ محتوى الملف من المشروع المحلي]
```
</details>

<details>
<summary><b>3. package.json (الأسطر الجديدة فقط)</b></summary>

أضف في قسم scripts:
```json
"check-dns": "echo 'افتح: http://localhost:5000/dns-check.html' && npm start",
"domain-setup": "bash setup-domain-auto.sh",
"dns-status": "curl -s https://delivery-form-server.vercel.app/api/check-dns | python -m json.tool"
```
</details>

---

## **الطريقة 4: استخدام Vercel CLI**

### 🛠️ **التثبيت والاستخدام:**

```bash
# تثبيت Vercel CLI
npm i -g vercel

# تسجيل الدخول
vercel login

# النشر المباشر
vercel --prod

# ربط مع المشروع الحالي
vercel link
```

---

## **البديل الأخير: فريق العمل**

### 👥 **اطلب المساعدة:**

1. **أرسل رسالة تحتوي:**
   ```
   لدي 2 commits جاهزة:
   - db501fe: تحديثات نهائية شاملة
   - 0ce4a0f: أدوات ربط النطاق
   
   هل يمكنك عمل pull و push؟
   ```

2. **أو شارك remote access:**
   - استخدم TeamViewer/AnyDesk
   - شارك الشاشة عبر Discord/Zoom

---

## 📝 **قائمة الملفات المحدثة الكاملة:**

### **ملفات جديدة (8):**
- ✅ public/dns-check.html
- ✅ api/check-dns.js
- ✅ DOMAIN-SETUP-WIZARD.md
- ✅ FINAL-STEPS.md
- ✅ monitor-dns.sh
- ✅ .gitattributes
- ✅ auto-fix-git.sh
- ✅ manual-upload-guide.md

### **ملفات محدثة (3):**
- 📝 package.json
- 📝 README.md
- 📝 خطة-الإنهاء-النهائية.md

### **ملفات محذوفة (4):**
- ❌ Untitled-1.json
- ❌ Untitled-1.txt
- ❌ nafath_integration.py
- ❌ promissory_note_service.py

---

## ⚡ **نصيحة سريعة:**

إذا كان لديك GitHub Desktop:
1. افتحه
2. سيعرض لك التغييرات
3. اضغط "Push origin"
4. تم! ✅

---

**آخر تحديث:** 2025-07-03  
**الهدف:** نشر أدوات ربط النطاق الجديدة