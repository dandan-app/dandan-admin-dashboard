# حل سريع لمشكلة إدارة الموظفين

## 🚨 المشكلة:
صفحة إدارة الموظفين تظهر "خطأ في تحميل الموظفين"

## ✅ الحل السريع:

### الخطوة 1: إنشاء جدول الموظفين في Supabase

1. **اذهب إلى Supabase Dashboard:**
   - https://supabase.com/dashboard
   - اختر مشروع `dandan-admin`

2. **افتح SQL Editor:**
   - اذهب إلى `SQL Editor`
   - اضغط على `New query`

3. **انسخ والصق هذا الكود:**

```sql
-- حذف الجدول إذا كان موجوداً
DROP TABLE IF EXISTS employees CASCADE;

-- إنشاء جدول الموظفين
CREATE TABLE employees (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    employee_id TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    salary DECIMAL(10,2),
    hire_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'active',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    profile_image_url TEXT,
    address JSONB,
    emergency_contact JSONB
);

-- إدراج بيانات تجريبية
INSERT INTO employees (id, name, email, phone, employee_id, department, position, salary, hire_date, status, is_active) VALUES
('emp_001', 'نورا أحمد', 'nora@example.com', '+966506789012', 'EMP001', 'operations', 'مدير العمليات', 8000.00, '2024-01-15', 'active', true),
('emp_002', 'عبدالرحمن محمد', 'abdulrahman@example.com', '+966507890123', 'EMP002', 'support', 'موظف دعم', 5000.00, '2024-02-01', 'active', true),
('emp_003', 'فاطمة السالم', 'fatima@example.com', '+966508901234', 'EMP003', 'hr', 'موظف موارد بشرية', 6000.00, '2024-03-01', 'active', true);
```

4. **اضغط على `Run`**

5. **تحقق من النجاح:**
   - يجب أن تظهر رسالة "تم إنشاء جدول الموظفين بنجاح!"
   - يجب أن تظهر "total_employees: 3"

### الخطوة 2: اختبار التطبيق

1. **اذهب إلى التطبيق:**
   - http://localhost:8080

2. **اذهب إلى "إدارة الموظفين"**

3. **يجب أن تظهر:**
   - قائمة الموظفين (3 موظفين)
   - بدون أخطاء

## 🔧 إذا استمرت المشكلة:

### تحقق من Console في المتصفح:
1. اضغط `F12`
2. اذهب إلى `Console`
3. ابحث عن أخطاء حمراء
4. أرسل لي رسالة الخطأ

### تحقق من Supabase:
1. اذهب إلى `Table Editor`
2. تأكد من وجود جدول `employees`
3. تأكد من وجود 3 صفوف من البيانات

## ✅ النتيجة المتوقعة:

بعد تنفيذ الحل:
- ✅ جدول `employees` موجود في Supabase
- ✅ صفحة إدارة الموظفين تعمل بدون أخطاء
- ✅ تظهر قائمة الموظفين (3 موظفين)
- ✅ يمكن إضافة/تعديل/حذف الموظفين

## 📞 إذا لم يعمل:

أرسل لي:
1. رسالة الخطأ من Console
2. لقطة شاشة من Supabase Table Editor
3. تأكيد أن الجدول تم إنشاؤه بنجاح
