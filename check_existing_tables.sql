-- سكريبت للتحقق من الجداول الموجودة في مشروع dndnapp
-- هذا السكريبت يتحقق من الجداول الموجودة ويضيف فقط الجداول المفقودة

-- التحقق من الجداول الموجودة
SELECT 
    table_name,
    CASE 
        WHEN table_name IN ('users', 'drivers', 'employees', 'orders', 'notifications', 'app_settings') 
        THEN '✅ موجود'
        ELSE '❌ مفقود'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('users', 'drivers', 'employees', 'orders', 'notifications', 'app_settings')
ORDER BY table_name;

-- إضافة الجداول المفقودة فقط
-- جدول المستخدمين (إذا لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    role TEXT NOT NULL DEFAULT 'user',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE,
    address JSONB,
    profile_image_url TEXT
);

-- جدول السائقين (إذا لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS drivers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    license_number TEXT UNIQUE NOT NULL,
    vehicle_type TEXT NOT NULL,
    vehicle_model TEXT,
    vehicle_plate TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'offline',
    rating DECIMAL(3,2) DEFAULT 0.0,
    total_rides INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_active TIMESTAMP WITH TIME ZONE,
    location JSONB,
    profile_image_url TEXT
);

-- جدول الموظفين (إذا لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS employees (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    employee_id TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL DEFAULT 'operator',
    department TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'active',
    national_id TEXT,
    passport_number TEXT,
    hire_date DATE NOT NULL,
    termination_date DATE,
    salary DECIMAL(10,2),
    emergency_contact TEXT,
    emergency_phone TEXT,
    address TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE,
    profile_image_url TEXT
);

-- جدول الطلبات (إذا لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS orders (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    driver_id TEXT REFERENCES drivers(id),
    pickup_address TEXT NOT NULL,
    delivery_address TEXT NOT NULL,
    pickup_location JSONB,
    delivery_location JSONB,
    items JSONB NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'pending',
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    scheduled_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- جدول الإشعارات (إذا لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS notifications (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    data JSONB
);

-- جدول إعدادات التطبيق (إذا لم يكن موجوداً)
CREATE TABLE IF NOT EXISTS app_settings (
    id TEXT PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء الفهارس لتحسين الأداء (فقط إذا لم تكن موجودة)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

CREATE INDEX IF NOT EXISTS idx_drivers_email ON drivers(email);
CREATE INDEX IF NOT EXISTS idx_drivers_status ON drivers(status);
CREATE INDEX IF NOT EXISTS idx_drivers_created_at ON drivers(created_at);

CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_employee_id ON employees(employee_id);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_driver_id ON orders(driver_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);

-- تمكين Row Level Security (RLS) - فقط إذا لم يكن مفعلاً
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'users' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE users ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'drivers' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE drivers ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'employees' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'orders' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'notifications' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'app_settings' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

-- إنشاء سياسات الأمان (فقط إذا لم تكن موجودة)
-- سياسة للقراءة العامة
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON users FOR SELECT USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON drivers FOR SELECT USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'employees' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON employees FOR SELECT USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'orders' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON orders FOR SELECT USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'notifications' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON notifications FOR SELECT USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'app_settings' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON app_settings FOR SELECT USING (true);
    END IF;
END $$;

-- سياسة للكتابة
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable insert for all users'
    ) THEN
        CREATE POLICY "Enable insert for all users" ON users FOR INSERT WITH CHECK (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable update for all users'
    ) THEN
        CREATE POLICY "Enable update for all users" ON users FOR UPDATE USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable delete for all users'
    ) THEN
        CREATE POLICY "Enable delete for all users" ON users FOR DELETE USING (true);
    END IF;
END $$;

-- نفس السياسات للجداول الأخرى
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable insert for all users'
    ) THEN
        CREATE POLICY "Enable insert for all users" ON drivers FOR INSERT WITH CHECK (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable update for all users'
    ) THEN
        CREATE POLICY "Enable update for all users" ON drivers FOR UPDATE USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable delete for all users'
    ) THEN
        CREATE POLICY "Enable delete for all users" ON drivers FOR DELETE USING (true);
    END IF;
END $$;

-- إضافة بيانات تجريبية للوحة التحكم (اختيارية)
-- يمكن حذف هذا القسم إذا كنت لا تريد بيانات تجريبية

-- إضافة إعدادات التطبيق الافتراضية
INSERT INTO app_settings (id, key, value, description) 
VALUES 
    ('app-config-1', 'app_name', '"نظام دندن الإداري"', 'اسم التطبيق'),
    ('app-config-2', 'app_version', '"1.0.0"', 'إصدار التطبيق'),
    ('app-config-3', 'maintenance_mode', 'false', 'وضع الصيانة'),
    ('app-config-4', 'max_file_size', '10485760', 'الحد الأقصى لحجم الملف (10MB)'),
    ('app-config-5', 'supported_formats', '["jpg", "jpeg", "png", "pdf"]', 'الصيغ المدعومة')
ON CONFLICT (id) DO NOTHING;

-- طباعة رسالة نجاح
DO $$ 
BEGIN
    RAISE NOTICE '✅ تم التحقق من الجداول الموجودة وإضافة المفقودة!';
    RAISE NOTICE '📊 الجداول المتاحة: users, drivers, employees, orders, notifications, app_settings';
    RAISE NOTICE '🔒 تم تفعيل Row Level Security';
    RAISE NOTICE '📋 تم إنشاء الفهارس لتحسين الأداء';
    RAISE NOTICE '⚙️ تم إضافة إعدادات التطبيق الافتراضية';
END $$;
