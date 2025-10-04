# حل مشكلة جدول الموظفين

## 🚨 المشكلة:
```
PostgrestException: Could not find the table 'public.employees' (PGRST205)
```

## ✅ الحل:

### 1. إنشاء جدول الموظفين فقط:

1. اذهب إلى [Supabase Dashboard](https://supabase.com/dashboard)
2. اختر مشروع `dandan-admin`
3. اذهب إلى `SQL Editor`
4. انسخ الكود التالي والصقه:

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

-- إنشاء الفهارس
CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_employee_id ON employees(employee_id);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);

-- تمكين Row Level Security
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- إنشاء سياسات الأمان
CREATE POLICY "Enable read access for all users" ON employees FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON employees FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON employees FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON employees FOR DELETE USING (true);

-- إدراج بيانات تجريبية
INSERT INTO employees (id, name, email, phone, employee_id, department, position, salary, hire_date, status, is_active, created_at) VALUES
('emp_001', 'نورا أحمد', 'nora@example.com', '+966506789012', 'EMP001', 'operations', 'مدير العمليات', 8000.00, '2024-01-15', 'active', true, NOW()),
('emp_002', 'عبدالرحمن محمد', 'abdulrahman@example.com', '+966507890123', 'EMP002', 'support', 'موظف دعم', 5000.00, '2024-02-01', 'active', true, NOW()),
('emp_003', 'فاطمة السالم', 'fatima@example.com', '+966508901234', 'EMP003', 'hr', 'موظف موارد بشرية', 6000.00, '2024-03-01', 'active', true, NOW());
```

5. اضغط على `Run`

### 2. إنشاء جميع الجداول (اختياري):

إذا كنت تريد إنشاء جميع الجداول مرة واحدة، استخدم ملف `create_all_tables.sql`

### 3. التحقق من النجاح:

بعد تنفيذ الكود:
1. اذهب إلى `Table Editor`
2. تأكد من وجود جدول `employees`
3. تحقق من وجود البيانات التجريبية

### 4. اختبار التطبيق:

1. اذهب إلى التطبيق: http://localhost:8081
2. اذهب إلى "إدارة الموظفين"
3. يجب أن تظهر قائمة الموظفين بدون أخطاء

## 🔧 استكشاف الأخطاء:

### إذا ظهر خطأ في السياسات:
```sql
-- حذف السياسات القديمة
DROP POLICY IF EXISTS "Enable read access for all users" ON employees;
DROP POLICY IF EXISTS "Enable insert for all users" ON employees;
DROP POLICY IF EXISTS "Enable update for all users" ON employees;
DROP POLICY IF EXISTS "Enable delete for all users" ON employees;

-- إعادة إنشاء السياسات
CREATE POLICY "Enable read access for all users" ON employees FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON employees FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON employees FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON employees FOR DELETE USING (true);
```

### إذا ظهر خطأ في الفهارس:
```sql
-- حذف الفهارس القديمة
DROP INDEX IF EXISTS idx_employees_email;
DROP INDEX IF EXISTS idx_employees_employee_id;
DROP INDEX IF EXISTS idx_employees_department;
DROP INDEX IF EXISTS idx_employees_status;

-- إعادة إنشاء الفهارس
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_employee_id ON employees(employee_id);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_status ON employees(status);
```

## ✅ النتيجة المتوقعة:

بعد تنفيذ الحل:
- ✅ جدول `employees` سيكون موجوداً
- ✅ البيانات التجريبية ستظهر
- ✅ صفحة إدارة الموظفين ستعمل بدون أخطاء
- ✅ يمكن إضافة/تعديل/حذف الموظفين

## 📞 الدعم:

إذا استمرت المشكلة، تأكد من:
1. صحة Project URL و Anon Key
2. اتصال الإنترنت
3. صلاحيات المشروع في Supabase
