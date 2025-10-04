-- إصلاح جدول الموظفين الحالي
-- يرجى تشغيل هذا الملف في SQL Editor في Supabase Dashboard

-- إضافة الأعمدة المفقودة
ALTER TABLE employees 
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'operator',
ADD COLUMN IF NOT EXISTS national_id TEXT,
ADD COLUMN IF NOT EXISTS passport_number TEXT,
ADD COLUMN IF NOT EXISTS termination_date DATE,
ADD COLUMN IF NOT EXISTS emergency_contact TEXT,
ADD COLUMN IF NOT EXISTS emergency_phone TEXT,
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS last_login TIMESTAMP WITH TIME ZONE;

-- تحديث الأعمدة الموجودة
ALTER TABLE employees 
ALTER COLUMN hire_date TYPE DATE,
ALTER COLUMN created_at SET DEFAULT NOW();

-- إزالة الأعمدة غير المستخدمة (إذا كانت موجودة)
ALTER TABLE employees 
DROP COLUMN IF EXISTS position,
DROP COLUMN IF EXISTS is_active,
DROP COLUMN IF EXISTS updated_at;

-- إنشاء الفهارس
CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_employee_id ON employees(employee_id);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);
CREATE INDEX IF NOT EXISTS idx_employees_role ON employees(role);
