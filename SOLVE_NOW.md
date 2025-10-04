# 🚨 حل فوري لمشكلة إدارة الموظفين

## المشكلة:
صفحة إدارة الموظفين تظهر "خطأ في تحميل الموظفين"

## السبب:
جدول `employees` غير موجود في Supabase

## ✅ الحل السريع (5 دقائق):

### الخطوة 1: إنشاء جدول الموظفين

1. **اذهب إلى Supabase Dashboard:**
   - https://supabase.com/dashboard
   - اختر مشروع `dandan-admin`

2. **افتح SQL Editor:**
   - اضغط على `SQL Editor` في القائمة الجانبية
   - اضغط على `New query`

3. **انسخ والصق هذا الكود:**

```sql
-- إنشاء جدول الموظفين
CREATE TABLE IF NOT EXISTS employees (
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

### الخطوة 2: اختبار التطبيق

1. **اذهب إلى التطبيق:**
   - http://localhost:8080

2. **اضغط على "إدارة الموظفين"**

3. **يجب أن تظهر:**
   - قائمة الموظفين (3 موظفين)
   - بدون أخطاء

## 🎉 النتيجة:

بعد تنفيذ الحل:
- ✅ جدول `employees` موجود في Supabase
- ✅ صفحة إدارة الموظفين تعمل بدون أخطاء
- ✅ تظهر قائمة الموظفين
- ✅ يمكن إضافة/تعديل/حذف الموظفين

## 📞 إذا لم يعمل:

1. **تحقق من Console في المتصفح:**
   - اضغط `F12`
   - اذهب إلى `Console`
   - ابحث عن أخطاء حمراء

2. **تحقق من Supabase:**
   - اذهب إلى `Table Editor`
   - تأكد من وجود جدول `employees`
   - تأكد من وجود 3 صفوف من البيانات

3. **أرسل لي:**
   - رسالة الخطأ من Console
   - لقطة شاشة من Supabase Table Editor

**المشكلة ستُحل فوراً بعد إنشاء الجدول! 🌹**
