-- فحص بنية جدول الموظفين الحالي
-- يرجى تشغيل هذا الملف في SQL Editor في Supabase Dashboard

-- عرض بنية الجدول
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'employees' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- عرض بيانات الجدول الحالية (إن وجدت)
SELECT * FROM employees LIMIT 5;
