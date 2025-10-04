-- إنشاء جدول الموظفين البسيط
-- انسخ هذا الكود والصقه في SQL Editor في Supabase

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
