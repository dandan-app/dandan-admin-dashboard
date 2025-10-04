# حل مشكلة "خطأ في تحميل الموظفين"

## 🚨 المشكلة:
صفحة إدارة الموظفين تظهر "خطأ في تحميل الموظفين"

## ✅ الحل خطوة بخطوة:

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

-- تمكين Row Level Security
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- إنشاء سياسة بسيطة للوصول
CREATE POLICY "Allow all operations on employees" ON employees
    FOR ALL USING (true) WITH CHECK (true);

-- إدراج بيانات تجريبية
INSERT INTO employees (id, name, email, phone, employee_id, department, position, salary, hire_date, status, is_active) VALUES
('emp_001', 'نورا أحمد', 'nora@example.com', '+966506789012', 'EMP001', 'operations', 'مدير العمليات', 8000.00, '2024-01-15', 'active', true),
('emp_002', 'عبدالرحمن محمد', 'abdulrahman@example.com', '+966507890123', 'EMP002', 'support', 'موظف دعم', 5000.00, '2024-02-01', 'active', true),
('emp_003', 'فاطمة السالم', 'fatima@example.com', '+966508901234', 'EMP003', 'hr', 'موظف موارد بشرية', 6000.00, '2024-03-01', 'active', true);

-- التحقق من إنشاء الجدول
SELECT 'تم إنشاء جدول الموظفين بنجاح!' as message;
SELECT COUNT(*) as total_employees FROM employees;
```

4. **اضغط على `Run`**

5. **تحقق من النجاح:**
   - يجب أن تظهر رسالة "تم إنشاء جدول الموظفين بنجاح!"
   - يجب أن تظهر "total_employees: 3"

### الخطوة 2: إعادة تشغيل التطبيق

1. **أوقف التطبيق الحالي:**
   - في Terminal، اضغط `Ctrl + C`

2. **أعد تشغيل التطبيق:**
   ```bash
   flutter run -d web-server --web-port 8081
   ```

3. **انتظر حتى يظهر:**
   ```
   lib/main.dart is being served at http://localhost:8081
   ```

### الخطوة 3: اختبار صفحة الموظفين

1. **اذهب إلى التطبيق:**
   - http://localhost:8081

2. **اذهب إلى "إدارة الموظفين"**

3. **يجب أن تظهر:**
   - قائمة الموظفين (3 موظفين)
   - بدون أخطاء

## 🔧 إذا استمرت المشكلة:

### اختبار الاتصال:

1. **افتح Developer Tools في المتصفح:**
   - اضغط `F12`
   - اذهب إلى `Console`

2. **ابحث عن أخطاء:**
   - ابحث عن رسائل خطأ حمراء
   - ابحث عن "PostgrestException"

### التحقق من Supabase:

1. **اذهب إلى Table Editor:**
   - في Supabase Dashboard
   - اذهب إلى `Table Editor`
   - تأكد من وجود جدول `employees`

2. **تحقق من البيانات:**
   - اضغط على جدول `employees`
   - يجب أن ترى 3 صفوف من البيانات

### إعادة إنشاء الجدول:

إذا لم يعمل الحل، جرب هذا الكود:

```sql
-- حذف كل شيء وإعادة إنشاء
DROP TABLE IF EXISTS employees CASCADE;

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

-- بدون RLS مؤقتاً للاختبار
-- ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

INSERT INTO employees (id, name, email, phone, employee_id, department, position, salary, hire_date, status, is_active) VALUES
('emp_001', 'نورا أحمد', 'nora@example.com', '+966506789012', 'EMP001', 'operations', 'مدير العمليات', 8000.00, '2024-01-15', 'active', true);
```

## ✅ النتيجة المتوقعة:

بعد تنفيذ الحل:
- ✅ جدول `employees` موجود في Supabase
- ✅ صفحة إدارة الموظفين تعمل بدون أخطاء
- ✅ تظهر قائمة الموظفين
- ✅ يمكن إضافة/تعديل/حذف الموظفين

## 📞 إذا استمرت المشكلة:

أرسل لي:
1. رسالة الخطأ الكاملة من Console
2. لقطة شاشة من Supabase Table Editor
3. تأكيد أن الجدول تم إنشاؤه بنجاح
