# 🔑 **دليل Personal Access Token خطوة بخطوة**

## 📋 **دليل سريع بالصور**

### 🎯 **الخطوات بالترتيب:**

---

## **الخطوة 1: افتح إعدادات GitHub**

1. اذهب إلى: https://github.com
2. اضغط على صورتك في الزاوية اليمنى العلوية
3. اختر **Settings** من القائمة

---

## **الخطوة 2: الوصول لـ Developer Settings**

1. في القائمة الجانبية، انزل للأسفل
2. ابحث عن **< > Developer settings**
3. اضغط عليها

---

## **الخطوة 3: إنشاء Token جديد**

1. اختر **Personal access tokens** → **Tokens (classic)**
2. اضغط زر **Generate new token** → **Generate new token (classic)**

---

## **الخطوة 4: إعدادات الـ Token**

### **في حقل Note:**
```
Delivery Form Server Push Access
```

### **في Expiration:**
- اختر **90 days** أو **No expiration**

### **في Select scopes:**
☑️ ضع علامة على **repo** (الصندوق الرئيسي)
- سيختار تلقائياً كل الصناديق تحته

---

## **الخطوة 5: إنشاء الـ Token**

1. انزل للأسفل
2. اضغط زر **Generate token** الأخضر

---

## **الخطوة 6: نسخ الـ Token**

⚠️ **مهم جداً:**
- **انسخ الـ Token الآن!** (يبدأ بـ ghp_)
- **لن تتمكن من رؤيته مرة أخرى**
- احفظه في مكان آمن

---

## 🚀 **استخدام الـ Token**

### **الطريقة 1: أمر واحد**
```bash
git push https://ghp_YOUR_TOKEN_HERE@github.com/mshari-11/delivery-form-server.git main
```
**استبدل ghp_YOUR_TOKEN_HERE بالـ token الذي نسخته**

### **الطريقة 2: حفظه بشكل دائم**
```bash
git remote set-url origin https://ghp_YOUR_TOKEN_HERE@github.com/mshari-11/delivery-form-server.git
```
**ثم يمكنك استخدام:**
```bash
git push origin main
```

---

## 📝 **مثال كامل**

إذا كان الـ token الخاص بك: `ghp_AbCdEfGhIjKlMnOpQrStUvWxYz123456`

الأمر سيكون:
```bash
git push https://ghp_AbCdEfGhIjKlMnOpQrStUvWxYz123456@github.com/mshari-11/delivery-form-server.git main
```

---

## ❓ **أسئلة شائعة**

### **س: ماذا لو فقدت الـ Token؟**
ج: أنشئ token جديد بنفس الخطوات

### **س: هل الـ Token آمن؟**
ج: نعم، لكن لا تشاركه مع أحد

### **س: كم مدة صلاحية الـ Token؟**
ج: حسب ما اخترت (90 يوم أو دائم)

---

## 🎬 **فيديو توضيحي**

شاهد الخطوات بالفيديو:
https://www.youtube.com/watch?v=kHkQnuYzwoo

---

## ⚡ **الخلاصة السريعة**

1. Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. اختر: repo
4. انسخ الـ token
5. استخدم:
```bash
git push https://TOKEN@github.com/mshari-11/delivery-form-server.git main
```

---

## 🆘 **إذا واجهت مشكلة**

1. تأكد من نسخ الـ token بالكامل
2. تأكد من وجود ghp_ في البداية
3. جرب token جديد إذا فشل الأول
4. استخدم GitHub Desktop كبديل

---

**آخر تحديث:** 2025-07-03  
**الوقت المطلوب:** 3-5 دقائق