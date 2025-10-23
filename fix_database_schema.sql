-- سكريبت إصلاح قاعدة البيانات - مشروع dndnapp
-- هذا السكريبت يتحقق من الجداول الموجودة ويضيف الحقول المفقودة

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

-- التحقق من الحقول الموجودة في جدول users
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' AND table_schema = 'public'
ORDER BY ordinal_position;

-- إضافة الحقول المفقودة إلى جدول users (إذا كان موجوداً)
DO $$ 
BEGIN
    -- إضافة حقل role إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'role'
    ) THEN
        ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user';
    END IF;
    
    -- إضافة حقل is_active إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'is_active'
    ) THEN
        ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT true;
    END IF;
    
    -- إضافة حقل last_login إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'last_login'
    ) THEN
        ALTER TABLE users ADD COLUMN last_login TIMESTAMP WITH TIME ZONE;
    END IF;
    
    -- إضافة حقل address إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'address'
    ) THEN
        ALTER TABLE users ADD COLUMN address JSONB;
    END IF;
    
    -- إضافة حقل profile_image_url إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'profile_image_url'
    ) THEN
        ALTER TABLE users ADD COLUMN profile_image_url TEXT;
    END IF;
END $$;

-- إضافة الحقول المفقودة إلى جدول drivers (إذا كان موجوداً)
DO $$ 
BEGIN
    -- إضافة حقل license_number إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'license_number'
    ) THEN
        ALTER TABLE drivers ADD COLUMN license_number TEXT;
    END IF;
    
    -- إضافة حقل vehicle_type إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'vehicle_type'
    ) THEN
        ALTER TABLE drivers ADD COLUMN vehicle_type TEXT;
    END IF;
    
    -- إضافة حقل vehicle_model إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'vehicle_model'
    ) THEN
        ALTER TABLE drivers ADD COLUMN vehicle_model TEXT;
    END IF;
    
    -- إضافة حقل vehicle_plate إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'vehicle_plate'
    ) THEN
        ALTER TABLE drivers ADD COLUMN vehicle_plate TEXT;
    END IF;
    
    -- إضافة حقل status إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'status'
    ) THEN
        ALTER TABLE drivers ADD COLUMN status TEXT DEFAULT 'offline';
    END IF;
    
    -- إضافة حقل rating إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'rating'
    ) THEN
        ALTER TABLE drivers ADD COLUMN rating DECIMAL(3,2) DEFAULT 0.0;
    END IF;
    
    -- إضافة حقل total_rides إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'total_rides'
    ) THEN
        ALTER TABLE drivers ADD COLUMN total_rides INTEGER DEFAULT 0;
    END IF;
    
    -- إضافة حقل is_active إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'is_active'
    ) THEN
        ALTER TABLE drivers ADD COLUMN is_active BOOLEAN DEFAULT true;
    END IF;
    
    -- إضافة حقل last_active إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'last_active'
    ) THEN
        ALTER TABLE drivers ADD COLUMN last_active TIMESTAMP WITH TIME ZONE;
    END IF;
    
    -- إضافة حقل location إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'location'
    ) THEN
        ALTER TABLE drivers ADD COLUMN location JSONB;
    END IF;
    
    -- إضافة حقل profile_image_url إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers' AND column_name = 'profile_image_url'
    ) THEN
        ALTER TABLE drivers ADD COLUMN profile_image_url TEXT;
    END IF;
END $$;

-- إضافة الحقول المفقودة إلى جدول orders (إذا كان موجوداً)
DO $$ 
BEGIN
    -- إضافة حقل driver_id إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'driver_id'
    ) THEN
        ALTER TABLE orders ADD COLUMN driver_id TEXT;
    END IF;
    
    -- إضافة حقل pickup_location إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'pickup_location'
    ) THEN
        ALTER TABLE orders ADD COLUMN pickup_location JSONB;
    END IF;
    
    -- إضافة حقل delivery_location إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'delivery_location'
    ) THEN
        ALTER TABLE orders ADD COLUMN delivery_location JSONB;
    END IF;
    
    -- إضافة حقل items إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'items'
    ) THEN
        ALTER TABLE orders ADD COLUMN items JSONB;
    END IF;
    
    -- إضافة حقل total_amount إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'total_amount'
    ) THEN
        ALTER TABLE orders ADD COLUMN total_amount DECIMAL(10,2);
    END IF;
    
    -- إضافة حقل delivery_fee إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'delivery_fee'
    ) THEN
        ALTER TABLE orders ADD COLUMN delivery_fee DECIMAL(10,2) DEFAULT 0;
    END IF;
    
    -- إضافة حقل status إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'status'
    ) THEN
        ALTER TABLE orders ADD COLUMN status TEXT DEFAULT 'pending';
    END IF;
    
    -- إضافة حقل payment_method إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'payment_method'
    ) THEN
        ALTER TABLE orders ADD COLUMN payment_method TEXT;
    END IF;
    
    -- إضافة حقل payment_status إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'payment_status'
    ) THEN
        ALTER TABLE orders ADD COLUMN payment_status TEXT DEFAULT 'pending';
    END IF;
    
    -- إضافة حقل notes إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'notes'
    ) THEN
        ALTER TABLE orders ADD COLUMN notes TEXT;
    END IF;
    
    -- إضافة حقل updated_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
    
    -- إضافة حقل scheduled_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'scheduled_at'
    ) THEN
        ALTER TABLE orders ADD COLUMN scheduled_at TIMESTAMP WITH TIME ZONE;
    END IF;
    
    -- إضافة حقل completed_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'completed_at'
    ) THEN
        ALTER TABLE orders ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;
    END IF;
END $$;

-- إنشاء الجداول المفقودة
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
    RAISE NOTICE '✅ تم إصلاح قاعدة البيانات بنجاح!';
    RAISE NOTICE '📊 تم التحقق من الجداول الموجودة وإضافة الحقول المفقودة';
    RAISE NOTICE '🔒 تم تفعيل Row Level Security';
    RAISE NOTICE '📋 تم إنشاء الفهارس لتحسين الأداء';
    RAISE NOTICE '⚙️ تم إضافة إعدادات التطبيق الافتراضية';
END $$;
