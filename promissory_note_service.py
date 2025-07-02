# ملف: promissory_note_service.py
# خدمة إدارة السندات مع التكامل مع نافذ
# شركة الخط الأول للخدمات اللوجستية

from nafath_integration import NafathESignature
import sqlite3
import json
from datetime import datetime
import hashlib
import os

class PromissoryNoteService:
    def __init__(self, db_path='delivery_system.db'):
        self.db_path = db_path
        self.nafath = NafathESignature()
        self.init_database()
        
    def init_database(self):
        """إنشاء جداول السندات وقاعدة البيانات"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # جدول السندات الرئيسي
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS promissory_notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            delivery_person_id TEXT NOT NULL,
            delivery_person_name TEXT NOT NULL,
            delivery_person_phone TEXT NOT NULL,
            app_name TEXT NOT NULL,
            amount DECIMAL(10,2) NOT NULL,
            amount_words TEXT,
            note_text TEXT NOT NULL,
            nafath_reference TEXT UNIQUE,
            signature_status TEXT DEFAULT 'pending',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            signed_at TIMESTAMP,
            download_url TEXT,
            verification_data TEXT,
            ip_address TEXT,
            user_agent TEXT,
            hash_value TEXT UNIQUE
        )
        ''')
        
        # جدول تتبع حالة التوقيع
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS signature_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            note_id INTEGER,
            status TEXT NOT NULL,
            details TEXT,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (note_id) REFERENCES promissory_notes (id)
        )
        ''')
        
        # جدول إعدادات التطبيقات
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS app_settings (
            app_name TEXT PRIMARY KEY,
            amount DECIMAL(10,2) NOT NULL,
            requires_note BOOLEAN DEFAULT 1,
            description TEXT
        )
        ''')
        
        # إدراج إعدادات التطبيقات الافتراضية
        apps_data = [
            ('kita', 5000.00, 1, 'تطبيق كيتا - نظام بالطلب'),
            ('jahez', 2000.00, 1, 'تطبيق جاهز'),
            ('thechefz', 5000.00, 1, 'تطبيق ذا شفز'),
            ('marsool', 0.00, 0, 'تطبيق مرسول - بدون سند لأمر')
        ]
        
        cursor.executemany('''
        INSERT OR IGNORE INTO app_settings (app_name, amount, requires_note, description)
        VALUES (?, ?, ?, ?)
        ''', apps_data)
        
        conn.commit()
        conn.close()
        print("✅ تم إنشاء قاعدة البيانات بنجاح")
        
    def create_and_sign_note(self, person_data, app_name, client_info=None):
        """إنشاء وتوقيع السند"""
        try:
            print(f"🔄 بدء إنشاء سند لأمر للتطبيق: {app_name}")
            
            # التحقق من أن التطبيق يتطلب سند لأمر
            app_info = self.get_app_info(app_name)
            if not app_info['requires_note']:
                return {
                    'success': True,
                    'no_note_required': True,
                    'message': f'تطبيق {app_name} لا يتطلب سند لأمر'
                }
            
            amount = app_info['amount']
            
            # إنشاء السند
            note_text, note_data = self.nafath.create_promissory_note({
                'name': person_data['name'],
                'national_id': person_data['national_id'],
                'amount': amount
            })
            
            # إنشاء hash للسند
            note_hash = hashlib.sha256(
                f"{person_data['national_id']}{app_name}{amount}{datetime.now().date()}".encode()
            ).hexdigest()
            
            # حفظ السند في قاعدة البيانات
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            # التحقق من عدم وجود سند مماثل
            cursor.execute('''
            SELECT id FROM promissory_notes 
            WHERE delivery_person_id = ? AND app_name = ? AND signature_status = 'signed'
            AND date(created_at) = date('now')
            ''', (person_data['national_id'], app_name))
            
            existing_note = cursor.fetchone()
            if existing_note:
                conn.close()
                return {
                    'success': False,
                    'error': 'يوجد سند موقع مسبقاً لنفس الشخص والتطبيق اليوم',
                    'existing_note_id': existing_note[0]
                }
            
            # إدراج السند الجديد
            cursor.execute('''
            INSERT INTO promissory_notes 
            (delivery_person_id, delivery_person_name, delivery_person_phone, 
             app_name, amount, amount_words, note_text, signature_status, 
             ip_address, user_agent, hash_value)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', (
                person_data['national_id'], 
                person_data['name'],
                person_data['phone'],
                app_name, 
                amount, 
                note_data['amount_words'],
                note_text, 
                'pending',
                client_info.get('ip_address', '') if client_info else '',
                client_info.get('user_agent', '') if client_info else '',
                note_hash
            ))
            
            note_id = cursor.lastrowid
            conn.commit()
            
            # تسجيل بداية عملية التوقيع
            self.log_signature_event(cursor, note_id, 'created', 'تم إنشاء السند')
            conn.commit()
            conn.close()
            
            print(f"📄 تم إنشاء السند رقم: {note_id}")
            
            # إرسال للتوقيع عبر نافذ
            print("📱 إرسال السند للتوقيع عبر منصة نافذ...")
            signature_result = self.nafath.sign_with_nafath(
                note_text, 
                person_data['national_id'], 
                person_data['phone']
            )
            
            # تحديث حالة السند بناء على نتيجة التوقيع
            if signature_result['success']:
                print("✅ تم التوقيع بنجاح")
                self.update_signature_status(
                    note_id, 
                    'signed', 
                    signature_result['reference_number'],
                    signature_result['download_url'],
                    json.dumps(signature_result)
                )
                
                return {
                    'success': True,
                    'note_id': note_id,
                    'nafath_reference': signature_result['reference_number'],
                    'download_url': signature_result['download_url'],
                    'amount': amount,
                    'app_name': app_name,
                    'message': 'تم توقيع السند بنجاح عبر منصة نافذ'
                }
            else:
                print(f"❌ فشل التوقيع: {signature_result.get('error', 'خطأ غير معروف')}")
                self.update_signature_status(
                    note_id, 
                    'failed', 
                    details=json.dumps(signature_result)
                )
                return {
                    'success': False,
                    'note_id': note_id,
                    'error': signature_result.get('error', 'فشل في التوقيع'),
                    'message': 'فشل في توقيع السند عبر منصة نافذ'
                }
                
        except Exception as e:
            print(f"❌ خطأ في إنشاء السند: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'message': 'خطأ في إنشاء السند'
            }
            
    def update_signature_status(self, note_id, status, reference=None, download_url=None, details=None):
        """تحديث حالة التوقيع"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        if status == 'signed':
            cursor.execute('''
            UPDATE promissory_notes 
            SET signature_status = ?, nafath_reference = ?, 
                download_url = ?, signed_at = CURRENT_TIMESTAMP
            WHERE id = ?
            ''', (status, reference, download_url, note_id))
            
            self.log_signature_event(cursor, note_id, 'signed', f'تم التوقيع - المرجع: {reference}')
            
        else:
            cursor.execute('''
            UPDATE promissory_notes 
            SET signature_status = ?
            WHERE id = ?
            ''', (status, note_id))
            
            self.log_signature_event(cursor, note_id, status, details or f'تغيير الحالة إلى: {status}')
            
        conn.commit()
        conn.close()
        
    def log_signature_event(self, cursor, note_id, status, details):
        """تسجيل أحداث التوقيع"""
        cursor.execute('''
        INSERT INTO signature_logs (note_id, status, details)
        VALUES (?, ?, ?)
        ''', (note_id, status, details))
        
    def get_note_status(self, note_id):
        """الحصول على حالة السند"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
        SELECT pn.*, 
               GROUP_CONCAT(sl.status || ': ' || sl.details || ' (' || sl.timestamp || ')') as logs
        FROM promissory_notes pn
        LEFT JOIN signature_logs sl ON pn.id = sl.note_id
        WHERE pn.id = ?
        GROUP BY pn.id
        ''', (note_id,))
        
        result = cursor.fetchone()
        conn.close()
        
        if result:
            columns = [description[0] for description in cursor.description]
            return dict(zip(columns, result))
        return None
        
    def get_note_by_reference(self, nafath_reference):
        """الحصول على السند بالرقم المرجعي"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
        SELECT * FROM promissory_notes 
        WHERE nafath_reference = ?
        ''', (nafath_reference,))
        
        result = cursor.fetchone()
        conn.close()
        
        if result:
            columns = [description[0] for description in cursor.description]
            return dict(zip(columns, result))
        return None
        
    def verify_note(self, nafath_reference):
        """التحقق من صحة السند"""
        print(f"🔍 التحقق من السند: {nafath_reference}")
        
        # التحقق عبر منصة نافذ
        verification_result = self.nafath.verify_signature(nafath_reference)
        
        # حفظ نتيجة التحقق
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
        UPDATE promissory_notes 
        SET verification_data = ?
        WHERE nafath_reference = ?
        ''', (json.dumps(verification_result), nafath_reference))
        
        # تسجيل عملية التحقق
        cursor.execute('''
        SELECT id FROM promissory_notes WHERE nafath_reference = ?
        ''', (nafath_reference,))
        
        note_id = cursor.fetchone()
        if note_id:
            self.log_signature_event(
                cursor, 
                note_id[0], 
                'verified', 
                f"تم التحقق - النتيجة: {'صالح' if verification_result['valid'] else 'غير صالح'}"
            )
        
        conn.commit()
        conn.close()
        
        return verification_result
        
    def get_app_info(self, app_name):
        """الحصول على معلومات التطبيق"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
        SELECT * FROM app_settings WHERE app_name = ?
        ''', (app_name,))
        
        result = cursor.fetchone()
        conn.close()
        
        if result:
            return {
                'app_name': result[0],
                'amount': result[1],
                'requires_note': bool(result[2]),
                'description': result[3]
            }
        
        # إعادة إعدادات افتراضية إذا لم يوجد التطبيق
        return {
            'app_name': app_name,
            'amount': 0,
            'requires_note': False,
            'description': 'تطبيق غير معروف'
        }
        
    def get_notes_summary(self, limit=50):
        """الحصول على ملخص السندات"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
        SELECT id, delivery_person_name, app_name, amount, 
               signature_status, nafath_reference, created_at
        FROM promissory_notes 
        ORDER BY created_at DESC 
        LIMIT ?
        ''', (limit,))
        
        results = cursor.fetchall()
        conn.close()
        
        columns = ['id', 'name', 'app', 'amount', 'status', 'reference', 'date']
        return [dict(zip(columns, row)) for row in results]
        
    def get_statistics(self):
        """الحصول على إحصائيات السندات"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # إحصائيات عامة
        cursor.execute('''
        SELECT 
            COUNT(*) as total_notes,
            COUNT(CASE WHEN signature_status = 'signed' THEN 1 END) as signed_notes,
            COUNT(CASE WHEN signature_status = 'pending' THEN 1 END) as pending_notes,
            COUNT(CASE WHEN signature_status = 'failed' THEN 1 END) as failed_notes,
            SUM(CASE WHEN signature_status = 'signed' THEN amount ELSE 0 END) as total_amount
        FROM promissory_notes
        ''')
        
        general_stats = cursor.fetchone()
        
        # إحصائيات حسب التطبيق
        cursor.execute('''
        SELECT app_name, COUNT(*) as count, 
               SUM(amount) as total_amount,
               COUNT(CASE WHEN signature_status = 'signed' THEN 1 END) as signed_count
        FROM promissory_notes 
        GROUP BY app_name
        ''')
        
        app_stats = cursor.fetchall()
        
        conn.close()
        
        return {
            'general': {
                'total_notes': general_stats[0],
                'signed_notes': general_stats[1],
                'pending_notes': general_stats[2],
                'failed_notes': general_stats[3],
                'total_amount': general_stats[4] or 0
            },
            'by_app': [
                {
                    'app_name': row[0],
                    'count': row[1],
                    'total_amount': row[2] or 0,
                    'signed_count': row[3]
                } for row in app_stats
            ]
        }

# مثال على الاستخدام
if __name__ == "__main__":
    service = PromissoryNoteService()
    
    # بيانات تجريبية
    test_person = {
        'name': 'أحمد محمد العلي',
        'national_id': '1234567890',
        'phone': '0501234567'
    }
    
    # إنشاء وتوقيع سند لتطبيق كيتا
    result = service.create_and_sign_note(test_person, 'kita')
    print(f"📋 نتيجة إنشاء السند: {result}")
    
    # عرض الإحصائيات
    stats = service.get_statistics()
    print(f"📊 إحصائيات السندات: {stats}")
