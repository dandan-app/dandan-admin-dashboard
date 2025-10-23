-- سكريبت إصلاح قاعدة البيانات الآمن - مشروع dndnapp
-- هذا السكريبت يتحقق من وجود الجداول قبل إضافة الحقول

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

-- التحقق من الحقول الموجودة في جدول users (إذا كان موجوداً)
DO $$ 
DECLARE
    rec RECORD;
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users' AND table_schema = 'public') THEN
        RAISE NOTICE '📋 حقول جدول users:';
        FOR rec IN 
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'users' AND table_schema = 'public'
            ORDER BY ordinal_position
        LOOP
            RAISE NOTICE '  - %: %', rec.column_name, rec.data_type;
        END LOOP;
    ELSE
        RAISE NOTICE '❌ جدول users غير موجود';
    END IF;
END $$;

-- إنشاء الجداول المفقودة أولاً
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

-- إضافة الحقول المفقودة إلى الجداول الموجودة
-- إضافة الحقول المفقودة إلى جدول users
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users' AND table_schema = 'public') THEN
        RAISE NOTICE '🔧 إضافة الحقول المفقودة إلى جدول users...';
        
        -- إضافة حقل role إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'role'
        ) THEN
            ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user';
            RAISE NOTICE '  ✅ تم إضافة حقل role';
        ELSE
            RAISE NOTICE '  ℹ️ حقل role موجود بالفعل';
        END IF;
        
        -- إضافة حقل is_active إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'is_active'
        ) THEN
            ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT true;
            RAISE NOTICE '  ✅ تم إضافة حقل is_active';
        ELSE
            RAISE NOTICE '  ℹ️ حقل is_active موجود بالفعل';
        END IF;
        
        -- إضافة حقل last_login إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'last_login'
        ) THEN
            ALTER TABLE users ADD COLUMN last_login TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  ✅ تم إضافة حقل last_login';
        ELSE
            RAISE NOTICE '  ℹ️ حقل last_login موجود بالفعل';
        END IF;
        
        -- إضافة حقل address إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'address'
        ) THEN
            ALTER TABLE users ADD COLUMN address JSONB;
            RAISE NOTICE '  ✅ تم إضافة حقل address';
        ELSE
            RAISE NOTICE '  ℹ️ حقل address موجود بالفعل';
        END IF;
        
        -- إضافة حقل profile_image_url إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'profile_image_url'
        ) THEN
            ALTER TABLE users ADD COLUMN profile_image_url TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل profile_image_url';
        ELSE
            RAISE NOTICE '  ℹ️ حقل profile_image_url موجود بالفعل';
        END IF;
    ELSE
        RAISE NOTICE '❌ جدول users غير موجود - سيتم إنشاؤه';
    END IF;
END $$;

-- إضافة الحقول المفقودة إلى جدول drivers (إذا كان موجوداً)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'drivers' AND table_schema = 'public') THEN
        RAISE NOTICE '🔧 إضافة الحقول المفقودة إلى جدول drivers...';
        
        -- إضافة حقل license_number إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'license_number'
        ) THEN
            ALTER TABLE drivers ADD COLUMN license_number TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل license_number';
        ELSE
            RAISE NOTICE '  ℹ️ حقل license_number موجود بالفعل';
        END IF;
        
        -- إضافة حقل vehicle_type إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'vehicle_type'
        ) THEN
            ALTER TABLE drivers ADD COLUMN vehicle_type TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل vehicle_type';
        ELSE
            RAISE NOTICE '  ℹ️ حقل vehicle_type موجود بالفعل';
        END IF;
        
        -- إضافة حقل vehicle_model إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'vehicle_model'
        ) THEN
            ALTER TABLE drivers ADD COLUMN vehicle_model TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل vehicle_model';
        ELSE
            RAISE NOTICE '  ℹ️ حقل vehicle_model موجود بالفعل';
        END IF;
        
        -- إضافة حقل vehicle_plate إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'vehicle_plate'
        ) THEN
            ALTER TABLE drivers ADD COLUMN vehicle_plate TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل vehicle_plate';
        ELSE
            RAISE NOTICE '  ℹ️ حقل vehicle_plate موجود بالفعل';
        END IF;
        
        -- إضافة حقل status إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'status'
        ) THEN
            ALTER TABLE drivers ADD COLUMN status TEXT DEFAULT 'offline';
            RAISE NOTICE '  ✅ تم إضافة حقل status';
        ELSE
            RAISE NOTICE '  ℹ️ حقل status موجود بالفعل';
        END IF;
        
        -- إضافة حقل rating إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'rating'
        ) THEN
            ALTER TABLE drivers ADD COLUMN rating DECIMAL(3,2) DEFAULT 0.0;
            RAISE NOTICE '  ✅ تم إضافة حقل rating';
        ELSE
            RAISE NOTICE '  ℹ️ حقل rating موجود بالفعل';
        END IF;
        
        -- إضافة حقل total_rides إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'total_rides'
        ) THEN
            ALTER TABLE drivers ADD COLUMN total_rides INTEGER DEFAULT 0;
            RAISE NOTICE '  ✅ تم إضافة حقل total_rides';
        ELSE
            RAISE NOTICE '  ℹ️ حقل total_rides موجود بالفعل';
        END IF;
        
        -- إضافة حقل is_active إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'is_active'
        ) THEN
            ALTER TABLE drivers ADD COLUMN is_active BOOLEAN DEFAULT true;
            RAISE NOTICE '  ✅ تم إضافة حقل is_active';
        ELSE
            RAISE NOTICE '  ℹ️ حقل is_active موجود بالفعل';
        END IF;
        
        -- إضافة حقل last_active إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'last_active'
        ) THEN
            ALTER TABLE drivers ADD COLUMN last_active TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  ✅ تم إضافة حقل last_active';
        ELSE
            RAISE NOTICE '  ℹ️ حقل last_active موجود بالفعل';
        END IF;
        
        -- إضافة حقل location إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'location'
        ) THEN
            ALTER TABLE drivers ADD COLUMN location JSONB;
            RAISE NOTICE '  ✅ تم إضافة حقل location';
        ELSE
            RAISE NOTICE '  ℹ️ حقل location موجود بالفعل';
        END IF;
        
        -- إضافة حقل profile_image_url إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'profile_image_url'
        ) THEN
            ALTER TABLE drivers ADD COLUMN profile_image_url TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل profile_image_url';
        ELSE
            RAISE NOTICE '  ℹ️ حقل profile_image_url موجود بالفعل';
        END IF;
    ELSE
        RAISE NOTICE '❌ جدول drivers غير موجود - سيتم إنشاؤه';
    END IF;
END $$;

-- إضافة الحقول المفقودة إلى جدول orders (إذا كان موجوداً)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'orders' AND table_schema = 'public') THEN
        RAISE NOTICE '🔧 إضافة الحقول المفقودة إلى جدول orders...';
        
        -- إضافة حقل driver_id إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'driver_id'
        ) THEN
            ALTER TABLE orders ADD COLUMN driver_id TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل driver_id';
        ELSE
            RAISE NOTICE '  ℹ️ حقل driver_id موجود بالفعل';
        END IF;
        
        -- إضافة حقل pickup_location إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'pickup_location'
        ) THEN
            ALTER TABLE orders ADD COLUMN pickup_location JSONB;
            RAISE NOTICE '  ✅ تم إضافة حقل pickup_location';
        ELSE
            RAISE NOTICE '  ℹ️ حقل pickup_location موجود بالفعل';
        END IF;
        
        -- إضافة حقل delivery_location إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'delivery_location'
        ) THEN
            ALTER TABLE orders ADD COLUMN delivery_location JSONB;
            RAISE NOTICE '  ✅ تم إضافة حقل delivery_location';
        ELSE
            RAISE NOTICE '  ℹ️ حقل delivery_location موجود بالفعل';
        END IF;
        
        -- إضافة حقل items إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'items'
        ) THEN
            ALTER TABLE orders ADD COLUMN items JSONB;
            RAISE NOTICE '  ✅ تم إضافة حقل items';
        ELSE
            RAISE NOTICE '  ℹ️ حقل items موجود بالفعل';
        END IF;
        
        -- إضافة حقل total_amount إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'total_amount'
        ) THEN
            ALTER TABLE orders ADD COLUMN total_amount DECIMAL(10,2);
            RAISE NOTICE '  ✅ تم إضافة حقل total_amount';
        ELSE
            RAISE NOTICE '  ℹ️ حقل total_amount موجود بالفعل';
        END IF;
        
        -- إضافة حقل delivery_fee إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'delivery_fee'
        ) THEN
            ALTER TABLE orders ADD COLUMN delivery_fee DECIMAL(10,2) DEFAULT 0;
            RAISE NOTICE '  ✅ تم إضافة حقل delivery_fee';
        ELSE
            RAISE NOTICE '  ℹ️ حقل delivery_fee موجود بالفعل';
        END IF;
        
        -- إضافة حقل status إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'status'
        ) THEN
            ALTER TABLE orders ADD COLUMN status TEXT DEFAULT 'pending';
            RAISE NOTICE '  ✅ تم إضافة حقل status';
        ELSE
            RAISE NOTICE '  ℹ️ حقل status موجود بالفعل';
        END IF;
        
        -- إضافة حقل payment_method إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'payment_method'
        ) THEN
            ALTER TABLE orders ADD COLUMN payment_method TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل payment_method';
        ELSE
            RAISE NOTICE '  ℹ️ حقل payment_method موجود بالفعل';
        END IF;
        
        -- إضافة حقل payment_status إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'payment_status'
        ) THEN
            ALTER TABLE orders ADD COLUMN payment_status TEXT DEFAULT 'pending';
            RAISE NOTICE '  ✅ تم إضافة حقل payment_status';
        ELSE
            RAISE NOTICE '  ℹ️ حقل payment_status موجود بالفعل';
        END IF;
        
        -- إضافة حقل notes إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'notes'
        ) THEN
            ALTER TABLE orders ADD COLUMN notes TEXT;
            RAISE NOTICE '  ✅ تم إضافة حقل notes';
        ELSE
            RAISE NOTICE '  ℹ️ حقل notes موجود بالفعل';
        END IF;
        
        -- إضافة حقل updated_at إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'updated_at'
        ) THEN
            ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
            RAISE NOTICE '  ✅ تم إضافة حقل updated_at';
        ELSE
            RAISE NOTICE '  ℹ️ حقل updated_at موجود بالفعل';
        END IF;
        
        -- إضافة حقل scheduled_at إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'scheduled_at'
        ) THEN
            ALTER TABLE orders ADD COLUMN scheduled_at TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  ✅ تم إضافة حقل scheduled_at';
        ELSE
            RAISE NOTICE '  ℹ️ حقل scheduled_at موجود بالفعل';
        END IF;
        
        -- إضافة حقل completed_at إذا لم يكن موجوداً
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'completed_at'
        ) THEN
            ALTER TABLE orders ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  ✅ تم إضافة حقل completed_at';
        ELSE
            RAISE NOTICE '  ℹ️ حقل completed_at موجود بالفعل';
        END IF;
    ELSE
        RAISE NOTICE '❌ جدول orders غير موجود - سيتم إنشاؤه';
    END IF;
END $$;

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
        RAISE NOTICE '🔒 تم تفعيل RLS على جدول users';
    ELSE
        RAISE NOTICE 'ℹ️ RLS مفعل بالفعل على جدول users';
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
        RAISE NOTICE '🔒 تم تفعيل RLS على جدول drivers';
    ELSE
        RAISE NOTICE 'ℹ️ RLS مفعل بالفعل على جدول drivers';
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
        RAISE NOTICE '🔒 تم تفعيل RLS على جدول employees';
    ELSE
        RAISE NOTICE 'ℹ️ RLS مفعل بالفعل على جدول employees';
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
        RAISE NOTICE '🔒 تم تفعيل RLS على جدول orders';
    ELSE
        RAISE NOTICE 'ℹ️ RLS مفعل بالفعل على جدول orders';
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
        RAISE NOTICE '🔒 تم تفعيل RLS على جدول notifications';
    ELSE
        RAISE NOTICE 'ℹ️ RLS مفعل بالفعل على جدول notifications';
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
        RAISE NOTICE '🔒 تم تفعيل RLS على جدول app_settings';
    ELSE
        RAISE NOTICE 'ℹ️ RLS مفعل بالفعل على جدول app_settings';
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
        RAISE NOTICE '🔐 تم إنشاء سياسة القراءة لجدول users';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة القراءة موجودة بالفعل لجدول users';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON drivers FOR SELECT USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة القراءة لجدول drivers';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة القراءة موجودة بالفعل لجدول drivers';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'employees' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON employees FOR SELECT USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة القراءة لجدول employees';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة القراءة موجودة بالفعل لجدول employees';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'orders' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON orders FOR SELECT USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة القراءة لجدول orders';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة القراءة موجودة بالفعل لجدول orders';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'notifications' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON notifications FOR SELECT USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة القراءة لجدول notifications';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة القراءة موجودة بالفعل لجدول notifications';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'app_settings' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON app_settings FOR SELECT USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة القراءة لجدول app_settings';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة القراءة موجودة بالفعل لجدول app_settings';
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
        RAISE NOTICE '🔐 تم إنشاء سياسة الإدراج لجدول users';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة الإدراج موجودة بالفعل لجدول users';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable update for all users'
    ) THEN
        CREATE POLICY "Enable update for all users" ON users FOR UPDATE USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة التحديث لجدول users';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة التحديث موجودة بالفعل لجدول users';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable delete for all users'
    ) THEN
        CREATE POLICY "Enable delete for all users" ON users FOR DELETE USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة الحذف لجدول users';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة الحذف موجودة بالفعل لجدول users';
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
        RAISE NOTICE '🔐 تم إنشاء سياسة الإدراج لجدول drivers';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة الإدراج موجودة بالفعل لجدول drivers';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable update for all users'
    ) THEN
        CREATE POLICY "Enable update for all users" ON drivers FOR UPDATE USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة التحديث لجدول drivers';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة التحديث موجودة بالفعل لجدول drivers';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable delete for all users'
    ) THEN
        CREATE POLICY "Enable delete for all users" ON drivers FOR DELETE USING (true);
        RAISE NOTICE '🔐 تم إنشاء سياسة الحذف لجدول drivers';
    ELSE
        RAISE NOTICE 'ℹ️ سياسة الحذف موجودة بالفعل لجدول drivers';
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
    RAISE NOTICE '🎉 قاعدة البيانات جاهزة للوحة التحكم!';
END $$;
