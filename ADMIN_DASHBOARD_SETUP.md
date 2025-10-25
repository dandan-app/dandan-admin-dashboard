# دليل إعداد لوحة التحكم - مشروع dndnapp

## 📋 نظرة عامة

هذا الدليل يوضح كيفية إعداد جداول لوحة التحكم في مشروع `dndnapp` بدون تعديل الجداول الموجودة.

## 🚀 خطوات الإعداد

### 1. الدخول إلى Supabase Dashboard
1. اذهب إلى [supabase.com](https://supabase.com)
2. اختر مشروع `dndnapp`
3. اذهب إلى SQL Editor

### 2. تشغيل سكريبت SQL
1. انسخ محتوى ملف `admin_dashboard_schema.sql`
2. الصق في SQL Editor
3. اضغط "Run" لتنفيذ السكريبت

### 3. التحقق من النجاح
ستظهر رسائل نجاح مثل:
```
✅ تم إنشاء جداول لوحة التحكم بنجاح!
📊 الجداول المتاحة: users, drivers, employees, orders, notifications, app_settings
🔒 تم تفعيل Row Level Security
📋 تم إنشاء الفهارس لتحسين الأداء
⚙️ تم إضافة إعدادات التطبيق الافتراضية
```

## 📊 الجداول المضافة

### 1. جدول المستخدمين (users)
```sql
- id: معرف فريد
- name: الاسم
- email: البريد الإلكتروني
- phone: رقم الهاتف
- role: الدور (user, admin, etc.)
- is_active: نشط/غير نشط
- created_at: تاريخ الإنشاء
- last_login: آخر تسجيل دخول
- address: العنوان (JSON)
- profile_image_url: رابط الصورة الشخصية
```

### 2. جدول السائقين (drivers)
```sql
- id: معرف فريد
- name: الاسم
- email: البريد الإلكتروني
- phone: رقم الهاتف
- license_number: رقم الرخصة
- vehicle_type: نوع المركبة
- vehicle_model: موديل المركبة
- vehicle_plate: رقم اللوحة
- status: الحالة (offline, available, busy)
- rating: التقييم
- total_rides: إجمالي الرحلات
- is_active: نشط/غير نشط
- location: الموقع (JSON)
```

### 3. جدول الموظفين (employees)
```sql
- id: معرف فريد
- name: الاسم
- email: البريد الإلكتروني
- phone: رقم الهاتف
- employee_id: رقم الموظف
- role: الدور (operator, manager, etc.)
- department: القسم
- status: الحالة (active, inactive, suspended, terminated)
- national_id: رقم الهوية
- hire_date: تاريخ التوظيف
- salary: الراتب
- emergency_contact: جهة الاتصال في الطوارئ
```

### 4. جدول الطلبات (orders)
```sql
- id: معرف فريد
- user_id: معرف المستخدم
- driver_id: معرف السائق
- pickup_address: عنوان الاستلام
- delivery_address: عنوان التسليم
- items: العناصر (JSON)
- total_amount: المبلغ الإجمالي
- status: الحالة (pending, confirmed, in_progress, completed, cancelled)
- payment_method: طريقة الدفع
- payment_status: حالة الدفع
```

### 5. جدول الإشعارات (notifications)
```sql
- id: معرف فريد
- user_id: معرف المستخدم
- title: العنوان
- message: الرسالة
- type: النوع
- is_read: مقروء/غير مقروء
- data: بيانات إضافية (JSON)
```

### 6. جدول إعدادات التطبيق (app_settings)
```sql
- id: معرف فريد
- key: المفتاح
- value: القيمة (JSON)
- description: الوصف
- updated_at: تاريخ التحديث
```

## 🔒 الأمان

### Row Level Security (RLS)
- تم تفعيل RLS على جميع الجداول
- سياسات القراءة والكتابة متاحة للجميع (يمكن تخصيصها)

### الفهارس
- تم إنشاء فهارس لتحسين الأداء
- فهارس على الحقول المهمة (email, status, created_at)

## ⚙️ الإعدادات الافتراضية

تم إضافة الإعدادات التالية:
- `app_name`: "نظام دندن الإداري"
- `app_version`: "1.0.0"
- `maintenance_mode`: false
- `max_file_size`: 10485760 (10MB)
- `supported_formats`: ["jpg", "jpeg", "png", "pdf"]

## 🧪 اختبار الإعداد

### 1. التحقق من الجداول
```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('users', 'drivers', 'employees', 'orders', 'notifications', 'app_settings');
```

### 2. التحقق من الإعدادات
```sql
SELECT * FROM app_settings;
```

### 3. اختبار إدراج بيانات تجريبية
```sql
INSERT INTO users (id, name, email, role) 
VALUES ('test-user-1', 'مستخدم تجريبي', 'test@example.com', 'user');
```

## 🔄 التحديثات المستقبلية

### إضافة حقول جديدة
```sql
ALTER TABLE users ADD COLUMN new_field TEXT;
```

### تعديل السياسات
```sql
DROP POLICY "policy_name" ON table_name;
CREATE POLICY "new_policy" ON table_name FOR SELECT USING (condition);
```

## 📞 الدعم

### في حالة وجود مشاكل:
1. تحقق من رسائل الخطأ في SQL Editor
2. تأكد من صلاحيات المستخدم
3. تحقق من وجود الجداول في Table Editor

### نصائح:
- احتفظ بنسخة احتياطية قبل التعديلات الكبيرة
- اختبر التغييرات في بيئة التطوير أولاً
- راجع سياسات الأمان بانتظام

---

**ملاحظة:** هذا السكريبت آمن ولا يعدل الجداول الموجودة، فقط يضيف الجداول المطلوبة للوحة التحكم.
