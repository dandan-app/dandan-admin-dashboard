# إعداد قاعدة البيانات المشتركة - مشروع dndnapp

## 📋 نظرة عامة

لوحة التحكم والتطبيق الرئيسي يستخدمان نفس قاعدة البيانات `dndnapp`. هذا السكريبت يتحقق من الجداول الموجودة ويضيف فقط الجداول المفقودة.

## 🔍 التحقق من الجداول الموجودة

### الجداول المطلوبة للوحة التحكم:
- ✅ **users** - المستخدمين
- ✅ **drivers** - السائقين  
- ✅ **employees** - الموظفين
- ✅ **orders** - الطلبات
- ✅ **notifications** - الإشعارات
- ✅ **app_settings** - إعدادات التطبيق

## 🚀 خطوات الإعداد

### 1. الدخول إلى Supabase Dashboard
1. اذهب إلى [supabase.com](https://supabase.com)
2. اختر مشروع `dndnapp`
3. اذهب إلى SQL Editor

### 2. تشغيل سكريبت التحقق
1. انسخ محتوى ملف `check_existing_tables.sql`
2. الصق في SQL Editor
3. اضغط "Run" لتنفيذ السكريبت

### 3. مراجعة النتائج
ستظهر قائمة بالجداول الموجودة والمفقودة:
```
table_name | status
-----------|--------
users      | ✅ موجود
drivers    | ✅ موجود
orders     | ✅ موجود
employees  | ❌ مفقود
notifications | ❌ مفقود
app_settings | ❌ مفقود
```

## 📊 الجداول المضافة (إذا كانت مفقودة)

### 1. جدول الموظفين (employees)
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

### 2. جدول الإشعارات (notifications)
```sql
- id: معرف فريد
- user_id: معرف المستخدم
- title: العنوان
- message: الرسالة
- type: النوع
- is_read: مقروء/غير مقروء
- data: بيانات إضافية (JSON)
```

### 3. جدول إعدادات التطبيق (app_settings)
```sql
- id: معرف فريد
- key: المفتاح
- value: القيمة (JSON)
- description: الوصف
- updated_at: تاريخ التحديث
```

## 🔒 الأمان والصلاحيات

### Row Level Security (RLS)
- تم تفعيل RLS على جميع الجداول
- سياسات القراءة والكتابة متاحة للجميع
- يمكن تخصيص السياسات حسب الحاجة

### الفهارس
- تم إنشاء فهارس لتحسين الأداء
- فهارس على الحقول المهمة (email, status, created_at)

## ⚙️ الإعدادات الافتراضية

تم إضافة الإعدادات التالية (إذا لم تكن موجودة):
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
INSERT INTO employees (id, name, email, phone, employee_id, department, hire_date) 
VALUES ('emp-1', 'موظف تجريبي', 'employee@example.com', '123456789', 'EMP001', 'IT', '2024-01-01');
```

## 🔄 التحديثات المستقبلية

### إضافة حقول جديدة
```sql
ALTER TABLE employees ADD COLUMN new_field TEXT;
```

### تعديل السياسات
```sql
DROP POLICY "policy_name" ON table_name;
CREATE POLICY "new_policy" ON table_name FOR SELECT USING (condition);
```

## 📊 مراقبة الأداء

### استعلامات مفيدة:
```sql
-- عدد المستخدمين
SELECT COUNT(*) FROM users;

-- عدد الطلبات حسب الحالة
SELECT status, COUNT(*) FROM orders GROUP BY status;

-- عدد الموظفين حسب القسم
SELECT department, COUNT(*) FROM employees GROUP BY department;

-- الإشعارات غير المقروءة
SELECT COUNT(*) FROM notifications WHERE is_read = false;
```

## 🔧 استكشاف الأخطاء

### مشاكل شائعة:
1. **خطأ في الصلاحيات**: تحقق من RLS policies
2. **خطأ في المفاتيح**: تحقق من foreign keys
3. **خطأ في البيانات**: تحقق من constraints

### حلول:
```sql
-- إعادة تعيين السياسات
DROP POLICY IF EXISTS "policy_name" ON table_name;
CREATE POLICY "new_policy" ON table_name FOR ALL USING (true);

-- التحقق من المفاتيح الخارجية
SELECT * FROM information_schema.table_constraints 
WHERE constraint_type = 'FOREIGN KEY';
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

**ملاحظة:** هذا السكريبت آمن ويحترم الجداول الموجودة، فقط يضيف الجداول المفقودة للوحة التحكم.
