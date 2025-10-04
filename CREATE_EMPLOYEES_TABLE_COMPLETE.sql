-- ========================================
-- كود SQL كامل لإنشاء جدول الموظفين في Supabase
-- ========================================

-- حذف الجدول إذا كان موجوداً (للتأكد من إنشاء جديد)
DROP TABLE IF EXISTS employees CASCADE;

-- إنشاء جدول الموظفين مع جميع الحقول المطلوبة
CREATE TABLE employees (
    -- المعرفات الأساسية
    id TEXT PRIMARY KEY,
    employee_id TEXT UNIQUE NOT NULL,
    
    -- المعلومات الشخصية
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    national_id TEXT UNIQUE,
    
    -- معلومات العمل
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    role TEXT NOT NULL,
    
    -- الحالة والراتب
    status TEXT NOT NULL DEFAULT 'active',
    salary DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true,
    
    -- التواريخ
    hire_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- معلومات إضافية
    profile_image_url TEXT,
    address TEXT,
    emergency_contact TEXT,
    emergency_phone TEXT,
    notes TEXT
);

-- إنشاء فهرس لتحسين الأداء
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_employee_id ON employees(employee_id);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_employees_created_at ON employees(created_at);

-- تمكين Row Level Security
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- إنشاء سياسة للوصول العام (يمكن تعديلها لاحقاً حسب الحاجة)
CREATE POLICY "Allow all operations on employees" ON employees
    FOR ALL USING (true) WITH CHECK (true);

-- إدراج بيانات تجريبية للاختبار
INSERT INTO employees (
    id, 
    employee_id, 
    name, 
    email, 
    phone, 
    national_id,
    department, 
    position, 
    role,
    status, 
    salary, 
    is_active,
    hire_date,
    address,
    emergency_contact,
    emergency_phone,
    notes
) VALUES 
(
    'emp_001', 
    'EMP001', 
    'نورا أحمد محمد', 
    'nora.ahmed@company.com', 
    '+966506789012', 
    '1234567890',
    'operations', 
    'مدير العمليات', 
    'manager',
    'active', 
    8000.00, 
    true,
    '2024-01-15',
    'الرياض، حي النرجس، شارع الملك فهد',
    'أحمد محمد (الأب)',
    '+966501234567',
    'موظف متميز في إدارة العمليات'
),
(
    'emp_002', 
    'EMP002', 
    'عبدالرحمن محمد السالم', 
    'abdulrahman.salem@company.com', 
    '+966507890123', 
    '2345678901',
    'support', 
    'موظف دعم فني', 
    'support_agent',
    'active', 
    5000.00, 
    true,
    '2024-02-01',
    'جدة، حي الزهراء، شارع الأمير سلطان',
    'فاطمة السالم (الأم)',
    '+966502345678',
    'خبرة في حل المشاكل التقنية'
),
(
    'emp_003', 
    'EMP003', 
    'فاطمة عبدالله السالم', 
    'fatima.abdullah@company.com', 
    '+966508901234', 
    '3456789012',
    'hr', 
    'موظف موارد بشرية', 
    'hr_specialist',
    'active', 
    6000.00, 
    true,
    '2024-03-01',
    'الدمام، حي الفيصلية، شارع الملك عبدالعزيز',
    'عبدالله السالم (الأب)',
    '+966503456789',
    'متخصصة في إدارة الموارد البشرية'
),
(
    'emp_004', 
    'EMP004', 
    'محمد أحمد القحطاني', 
    'mohammed.qhtani@company.com', 
    '+966509012345', 
    '4567890123',
    'finance', 
    'محاسب', 
    'accountant',
    'active', 
    5500.00, 
    true,
    '2024-04-01',
    'الرياض، حي العليا، شارع التحلية',
    'سارة القحطاني (الأخت)',
    '+966504567890',
    'خبرة في المحاسبة المالية'
),
(
    'emp_005', 
    'EMP005', 
    'سارة محمد العتيبي', 
    'sarah.otaibi@company.com', 
    '+966500123456', 
    '5678901234',
    'marketing', 
    'أخصائية تسويق', 
    'marketing_specialist',
    'inactive', 
    4500.00, 
    false,
    '2024-05-01',
    'الرياض، حي الملز، شارع العليا',
    'خالد العتيبي (الأخ)',
    '+966505678901',
    'متخصصة في التسويق الرقمي'
);

-- التحقق من إنشاء الجدول والبيانات
SELECT 'تم إنشاء جدول الموظفين بنجاح!' as message;
SELECT COUNT(*) as total_employees FROM employees;
SELECT 'عينة من البيانات:' as sample_data;
SELECT id, name, department, position, status FROM employees LIMIT 3;
