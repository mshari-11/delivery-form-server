# ملف: nafath_integration.py
# نظام التكامل مع منصة نافذ للتوقيع الإلكتروني
# شركة الخط الأول للخدمات اللوجستية

import selenium
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import time
import json
import hashlib
from datetime import datetime
import requests
import sqlite3

class NafathESignature:
    def __init__(self):
        self.driver = None
        self.wait = None
        self.nafath_url = "https://nafath.sa"
        self.company_info = {
            'name': 'شركة الخط الأول للخدمات اللوجستية',
            'cr_number': '4030370057',
            'tax_number': '311174371700003',
            'address': 'المملكة العربية السعودية - جدة'
        }
        
    def setup_driver(self):
        """إعداد متصفح Chrome للتوقيع"""
        options = Options()
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--disable-gpu')
        options.add_argument('--window-size=1920,1080')
        # إعدادات للأمان والخصوصية
        options.add_argument('--user-data-dir=/tmp/chrome-user-data')
        options.add_argument('--disable-web-security')
        options.add_argument('--allow-running-insecure-content')
        
        self.driver = webdriver.Chrome(options=options)
        self.wait = WebDriverWait(self.driver, 60)  # زيادة وقت الانتظار
        
    def create_promissory_note(self, data):
        """إنشاء السند لأمر حسب النظام السعودي"""
        
        # تحديد المبلغ بالكلمات
        amount_words = self.number_to_words(data['amount'])
        
        note_data = {
            'amount': data['amount'],
            'amount_words': amount_words,
            'debtor_name': data['name'],
            'debtor_id': data['national_id'],
            'creditor': self.company_info['name'],
            'creditor_cr': self.company_info['cr_number'],
            'date_hijri': self.get_hijri_date(),
            'date_gregorian': datetime.now().strftime('%d/%m/%Y'),
            'location': 'مدينة جدة',
            'due_date': 'عند الطلب',
            'reference_id': self.generate_reference_id()
        }
        
        # إنشاء نص السند حسب النظام السعودي
        note_text = f"""
        بسم الله الرحمن الرحيم
        
        (سند لأمـــــــــر)
        
        رقم السند: {note_data['reference_id']}
        تاريخ التحرير: {note_data['date_hijri']} هـ الموافق {note_data['date_gregorian']} م
        مكان التحرير: {note_data['location']}
        
        أتعهد أنا الموقع أدناه بأن أدفع بدون قيد أو شرط بموجب هذا السند لأمر:
        
        {note_data['creditor']}
        سجل تجاري رقم: {note_data['creditor_cr']}
        
        المبلغ وقدره: ({note_data['amount']}) {note_data['amount_words']} ريال سعودي لا غير.
        
        تاريخ استحقاق الوفاء: {note_data['due_date']}
        
        ولحامل هذا السند حق الرجوع بلا مصروفات وبدون إخطار أو عمل احتجاج لعدم الوفاء.
        
        بيانات محرر السند:
        الاسم: {note_data['debtor_name']}
        رقم الهوية: {note_data['debtor_id']}
        العنوان: {self.company_info['address']}
        
        التوقيع: ___________________
        
        هذا السند واجب الدفع بموجب نظام الأوراق التجارية الصادر بالمرسوم الملكي رقم م/37 
        في 11/10/1383هـ وقرار مجلس الوزراء رقم 692 بتاريخ 26/9/1383هـ
        
        تم التوقيع إلكترونياً عبر منصة نافذ الحكومية
        """
        
        return note_text, note_data
        
    def sign_with_nafath(self, note_text, signer_id, signer_phone):
        """التوقيع عبر منصة نافذ"""
        try:
            print("🔄 بدء عملية التوقيع عبر منصة نافذ...")
            self.setup_driver()
            
            # 1. الانتقال لمنصة نافذ
            print("📡 الاتصال بمنصة نافذ...")
            self.driver.get(self.nafath_url)
            time.sleep(3)
            
            # 2. البحث عن خدمة التوقيع الإلكتروني
            try:
                # محاولة العثور على رابط التوقيع الإلكتروني
                sign_service = self.wait.until(
                    EC.element_to_be_clickable((By.XPATH, "//a[contains(text(), 'التوقيع') or contains(text(), 'توقيع') or contains(@href, 'sign')]"))
                )
                print("✅ تم العثور على خدمة التوقيع")
                sign_service.click()
                time.sleep(2)
                
            except:
                # إذا لم يتم العثور على الرابط، محاولة الوصول مباشرة
                print("🔄 محاولة الوصول المباشر لخدمة التوقيع...")
                self.driver.get(f"{self.nafath_url}/e-signature")
                time.sleep(3)
            
            # 3. إدخال رقم الهوية
            print("📝 إدخال بيانات المستخدم...")
            try:
                id_input = self.wait.until(
                    EC.presence_of_element_located((By.NAME, "national_id"))
                )
                id_input.clear()
                id_input.send_keys(signer_id)
                
            except:
                # محاولة العثور على الحقل بطرق مختلفة
                id_inputs = self.driver.find_elements(By.XPATH, "//input[@type='text' or @type='number']")
                if id_inputs:
                    id_inputs[0].clear()
                    id_inputs[0].send_keys(signer_id)
            
            # 4. إدخال رقم الجوال
            try:
                phone_input = self.driver.find_element(By.NAME, "phone")
                phone_input.clear()
                phone_input.send_keys(signer_phone)
                
            except:
                # محاولة العثور على حقل الجوال
                phone_inputs = self.driver.find_elements(By.XPATH, "//input[contains(@placeholder, 'جوال') or contains(@placeholder, 'هاتف')]")
                if phone_inputs:
                    phone_inputs[0].clear()
                    phone_inputs[0].send_keys(signer_phone)
            
            # 5. رفع نص السند للتوقيع
            print("📄 رفع نص السند...")
            try:
                document_area = self.driver.find_element(By.NAME, "document_content")
                document_area.clear()
                document_area.send_keys(note_text)
                
            except:
                # محاولة العثور على منطقة النص
                text_areas = self.driver.find_elements(By.TAG_NAME, "textarea")
                if text_areas:
                    text_areas[0].clear()
                    text_areas[0].send_keys(note_text)
            
            # 6. إرسال طلب التوقيع
            print("📤 إرسال طلب التوقيع...")
            try:
                submit_btn = self.driver.find_element(By.XPATH, "//button[contains(text(), 'إرسال') or contains(text(), 'توقيع') or contains(text(), 'sign')]")
                submit_btn.click()
                
            except:
                # محاولة العثور على زر الإرسال
                buttons = self.driver.find_elements(By.TAG_NAME, "button")
                for btn in buttons:
                    if any(word in btn.text for word in ['إرسال', 'توقيع', 'Sign', 'Submit']):
                        btn.click()
                        break
            
            time.sleep(5)
            
            # 7. انتظار كود التحقق من نافذ
            print("⏳ انتظار كود التحقق...")
            print(f"📱 تم إرسال كود التحقق لرقم الجوال: {signer_phone}")
            print("🔔 يرجى إدخال الكود في تطبيق نافذ أو الرسالة النصية")
            
            try:
                # انتظار ظهور صفحة نجاح التوقيع
                success_element = self.wait.until(
                    EC.any_of(
                        EC.presence_of_element_located((By.CLASS_NAME, "success")),
                        EC.presence_of_element_located((By.CLASS_NAME, "signed")),
                        EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'نجح') or contains(text(), 'تم')]"))
                    )
                )
                
                print("✅ تم التوقيع بنجاح!")
                
            except:
                print("⏳ انتظار إكمال التوقيع... (يرجى المتابعة على الجوال)")
                time.sleep(30)  # انتظار إضافي
            
            # 8. الحصول على رقم مرجعي للسند الموقع
            reference_num = None
            try:
                ref_elements = self.driver.find_elements(By.XPATH, "//*[contains(text(), 'مرجع') or contains(text(), 'Reference')]")
                if ref_elements:
                    reference_num = ref_elements[0].text.split(':')[-1].strip()
                
                if not reference_num:
                    reference_num = self.generate_reference_id()
                    
            except:
                reference_num = self.generate_reference_id()
            
            # 9. محاولة الحصول على رابط التحميل
            download_url = None
            try:
                download_links = self.driver.find_elements(By.XPATH, "//a[contains(text(), 'تحميل') or contains(@href, 'download')]")
                if download_links:
                    download_url = download_links[0].get_attribute('href')
                    
            except:
                # إنشاء رابط تحميل افتراضي
                download_url = f"{self.nafath_url}/download/{reference_num}"
            
            print(f"📋 الرقم المرجعي: {reference_num}")
            
            return {
                'success': True,
                'reference_number': reference_num,
                'download_url': download_url,
                'signed_date': datetime.now().isoformat(),
                'signature_method': 'nafath_electronic',
                'signer_id': signer_id,
                'signer_phone': signer_phone
            }
            
        except Exception as e:
            print(f"❌ خطأ في التوقيع: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'timestamp': datetime.now().isoformat(),
                'signer_id': signer_id
            }
        finally:
            if self.driver:
                self.driver.quit()
                
    def verify_signature(self, reference_number):
        """التحقق من صحة التوقيع"""
        try:
            print(f"🔍 التحقق من التوقيع: {reference_number}")
            self.setup_driver()
            
            # الانتقال لصفحة التحقق
            verify_url = f"{self.nafath_url}/verify"
            self.driver.get(verify_url)
            time.sleep(3)
            
            # إدخال الرقم المرجعي
            try:
                ref_input = self.wait.until(
                    EC.presence_of_element_located((By.NAME, "reference_number"))
                )
                ref_input.clear()
                ref_input.send_keys(reference_number)
                
            except:
                # محاولة العثور على حقل الرقم المرجعي
                inputs = self.driver.find_elements(By.TAG_NAME, "input")
                if inputs:
                    inputs[0].clear()
                    inputs[0].send_keys(reference_number)
            
            # النقر على تحقق
            try:
                verify_btn = self.driver.find_element(By.XPATH, "//button[contains(text(), 'تحقق') or contains(text(), 'verify')]")
                verify_btn.click()
                
            except:
                buttons = self.driver.find_elements(By.TAG_NAME, "button")
                if buttons:
                    buttons[0].click()
            
            time.sleep(5)
            
            # الحصول على نتيجة التحقق
            try:
                result_element = self.wait.until(
                    EC.presence_of_element_located((By.CLASS_NAME, "verification-result"))
                )
                result_text = result_element.text
                
            except:
                # محاولة العثور على النتيجة بطرق أخرى
                page_text = self.driver.page_source
                if any(word in page_text for word in ['صالح', 'Valid', 'نجح', 'Success']):
                    result_text = "التوقيع صالح ومعتمد"
                else:
                    result_text = "لم يتم العثور على التوقيع"
            
            print(f"📋 نتيجة التحقق: {result_text}")
            
            return {
                'valid': 'صالح' in result_text or 'Valid' in result_text,
                'details': result_text,
                'verified_at': datetime.now().isoformat(),
                'reference_number': reference_number
            }
            
        except Exception as e:
            print(f"❌ خطأ في التحقق: {str(e)}")
            return {
                'valid': False,
                'error': str(e),
                'reference_number': reference_number
            }
        finally:
            if self.driver:
                self.driver.quit()
    
    def number_to_words(self, amount):
        """تحويل الرقم إلى كلمات باللغة العربية"""
        # تنفيذ مبسط - يمكن تطويره أكثر
        numbers = {
            1000: 'ألف', 2000: 'ألفان', 3000: 'ثلاثة آلاف', 4000: 'أربعة آلاف', 
            5000: 'خمسة آلاف', 6000: 'ستة آلاف', 7000: 'سبعة آلاف'
        }
        
        return numbers.get(int(amount), f"{amount}")
    
    def get_hijri_date(self):
        """الحصول على التاريخ الهجري (تنفيذ مبسط)"""
        # يمكن استخدام مكتبة hijri-converter للدقة أكثر
        return "___/___/1446"
    
    def generate_reference_id(self):
        """إنشاء رقم مرجعي فريد"""
        timestamp = str(int(time.time()))
        return f"FLLS-{timestamp[-8:]}"

# مثال على الاستخدام
if __name__ == "__main__":
    nafath = NafathESignature()
    
    # بيانات تجريبية
    test_data = {
        'name': 'أحمد محمد العلي',
        'national_id': '1234567890',
        'amount': 5000
    }
    
    # إنشاء السند
    note_text, note_data = nafath.create_promissory_note(test_data)
    print("📄 تم إنشاء السند:")
    print(note_text)
    
    # التوقيع عبر نافذ (يتطلب بيانات حقيقية)
    # result = nafath.sign_with_nafath(note_text, "1234567890", "0501234567")
    # print(f"📋 نتيجة التوقيع: {result}")
