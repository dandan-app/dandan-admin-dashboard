-- Safe database schema fix for dndnapp project
-- This script checks for existing tables before adding columns

-- Check existing tables
SELECT 
    table_name,
    CASE 
        WHEN table_name IN ('users', 'drivers', 'employees', 'orders', 'notifications', 'app_settings') 
        THEN 'EXISTS'
        ELSE 'MISSING'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('users', 'drivers', 'employees', 'orders', 'notifications', 'app_settings')
ORDER BY table_name;

-- Check existing columns in users table (if exists)
DO $$ 
DECLARE
    rec RECORD;
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users' AND table_schema = 'public') THEN
        RAISE NOTICE 'Users table columns:';
        FOR rec IN 
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'users' AND table_schema = 'public'
            ORDER BY ordinal_position
        LOOP
            RAISE NOTICE '  - %: %', rec.column_name, rec.data_type;
        END LOOP;
    ELSE
        RAISE NOTICE 'Users table does not exist';
    END IF;
END $$;

-- Create missing tables first
-- Users table (if not exists)
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

-- Drivers table (if not exists)
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

-- Employees table (if not exists)
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

-- Orders table (if not exists)
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

-- Notifications table (if not exists)
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

-- App settings table (if not exists)
CREATE TABLE IF NOT EXISTS app_settings (
    id TEXT PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add missing columns to existing tables
-- Add missing columns to users table
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users' AND table_schema = 'public') THEN
        RAISE NOTICE 'Adding missing columns to users table...';
        
        -- Add role column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'role'
        ) THEN
            ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user';
            RAISE NOTICE '  Added role column';
        ELSE
            RAISE NOTICE '  role column already exists';
        END IF;
        
        -- Add is_active column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'is_active'
        ) THEN
            ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT true;
            RAISE NOTICE '  Added is_active column';
        ELSE
            RAISE NOTICE '  is_active column already exists';
        END IF;
        
        -- Add last_login column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'last_login'
        ) THEN
            ALTER TABLE users ADD COLUMN last_login TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  Added last_login column';
        ELSE
            RAISE NOTICE '  last_login column already exists';
        END IF;
        
        -- Add address column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'address'
        ) THEN
            ALTER TABLE users ADD COLUMN address JSONB;
            RAISE NOTICE '  Added address column';
        ELSE
            RAISE NOTICE '  address column already exists';
        END IF;
        
        -- Add profile_image_url column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'users' AND column_name = 'profile_image_url'
        ) THEN
            ALTER TABLE users ADD COLUMN profile_image_url TEXT;
            RAISE NOTICE '  Added profile_image_url column';
        ELSE
            RAISE NOTICE '  profile_image_url column already exists';
        END IF;
    ELSE
        RAISE NOTICE 'Users table does not exist - will be created';
    END IF;
END $$;

-- Add missing columns to drivers table (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'drivers' AND table_schema = 'public') THEN
        RAISE NOTICE 'Adding missing columns to drivers table...';
        
        -- Add license_number column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'license_number'
        ) THEN
            ALTER TABLE drivers ADD COLUMN license_number TEXT;
            RAISE NOTICE '  Added license_number column';
        ELSE
            RAISE NOTICE '  license_number column already exists';
        END IF;
        
        -- Add vehicle_type column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'vehicle_type'
        ) THEN
            ALTER TABLE drivers ADD COLUMN vehicle_type TEXT;
            RAISE NOTICE '  Added vehicle_type column';
        ELSE
            RAISE NOTICE '  vehicle_type column already exists';
        END IF;
        
        -- Add vehicle_model column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'vehicle_model'
        ) THEN
            ALTER TABLE drivers ADD COLUMN vehicle_model TEXT;
            RAISE NOTICE '  Added vehicle_model column';
        ELSE
            RAISE NOTICE '  vehicle_model column already exists';
        END IF;
        
        -- Add vehicle_plate column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'vehicle_plate'
        ) THEN
            ALTER TABLE drivers ADD COLUMN vehicle_plate TEXT;
            RAISE NOTICE '  Added vehicle_plate column';
        ELSE
            RAISE NOTICE '  vehicle_plate column already exists';
        END IF;
        
        -- Add status column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'status'
        ) THEN
            ALTER TABLE drivers ADD COLUMN status TEXT DEFAULT 'offline';
            RAISE NOTICE '  Added status column';
        ELSE
            RAISE NOTICE '  status column already exists';
        END IF;
        
        -- Add rating column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'rating'
        ) THEN
            ALTER TABLE drivers ADD COLUMN rating DECIMAL(3,2) DEFAULT 0.0;
            RAISE NOTICE '  Added rating column';
        ELSE
            RAISE NOTICE '  rating column already exists';
        END IF;
        
        -- Add total_rides column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'total_rides'
        ) THEN
            ALTER TABLE drivers ADD COLUMN total_rides INTEGER DEFAULT 0;
            RAISE NOTICE '  Added total_rides column';
        ELSE
            RAISE NOTICE '  total_rides column already exists';
        END IF;
        
        -- Add is_active column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'is_active'
        ) THEN
            ALTER TABLE drivers ADD COLUMN is_active BOOLEAN DEFAULT true;
            RAISE NOTICE '  Added is_active column';
        ELSE
            RAISE NOTICE '  is_active column already exists';
        END IF;
        
        -- Add last_active column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'last_active'
        ) THEN
            ALTER TABLE drivers ADD COLUMN last_active TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  Added last_active column';
        ELSE
            RAISE NOTICE '  last_active column already exists';
        END IF;
        
        -- Add location column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'location'
        ) THEN
            ALTER TABLE drivers ADD COLUMN location JSONB;
            RAISE NOTICE '  Added location column';
        ELSE
            RAISE NOTICE '  location column already exists';
        END IF;
        
        -- Add profile_image_url column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers' AND column_name = 'profile_image_url'
        ) THEN
            ALTER TABLE drivers ADD COLUMN profile_image_url TEXT;
            RAISE NOTICE '  Added profile_image_url column';
        ELSE
            RAISE NOTICE '  profile_image_url column already exists';
        END IF;
    ELSE
        RAISE NOTICE 'Drivers table does not exist - will be created';
    END IF;
END $$;

-- Add missing columns to orders table (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'orders' AND table_schema = 'public') THEN
        RAISE NOTICE 'Adding missing columns to orders table...';
        
        -- Add driver_id column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'driver_id'
        ) THEN
            ALTER TABLE orders ADD COLUMN driver_id TEXT;
            RAISE NOTICE '  Added driver_id column';
        ELSE
            RAISE NOTICE '  driver_id column already exists';
        END IF;
        
        -- Add pickup_location column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'pickup_location'
        ) THEN
            ALTER TABLE orders ADD COLUMN pickup_location JSONB;
            RAISE NOTICE '  Added pickup_location column';
        ELSE
            RAISE NOTICE '  pickup_location column already exists';
        END IF;
        
        -- Add delivery_location column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'delivery_location'
        ) THEN
            ALTER TABLE orders ADD COLUMN delivery_location JSONB;
            RAISE NOTICE '  Added delivery_location column';
        ELSE
            RAISE NOTICE '  delivery_location column already exists';
        END IF;
        
        -- Add items column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'items'
        ) THEN
            ALTER TABLE orders ADD COLUMN items JSONB;
            RAISE NOTICE '  Added items column';
        ELSE
            RAISE NOTICE '  items column already exists';
        END IF;
        
        -- Add total_amount column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'total_amount'
        ) THEN
            ALTER TABLE orders ADD COLUMN total_amount DECIMAL(10,2);
            RAISE NOTICE '  Added total_amount column';
        ELSE
            RAISE NOTICE '  total_amount column already exists';
        END IF;
        
        -- Add delivery_fee column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'delivery_fee'
        ) THEN
            ALTER TABLE orders ADD COLUMN delivery_fee DECIMAL(10,2) DEFAULT 0;
            RAISE NOTICE '  Added delivery_fee column';
        ELSE
            RAISE NOTICE '  delivery_fee column already exists';
        END IF;
        
        -- Add status column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'status'
        ) THEN
            ALTER TABLE orders ADD COLUMN status TEXT DEFAULT 'pending';
            RAISE NOTICE '  Added status column';
        ELSE
            RAISE NOTICE '  status column already exists';
        END IF;
        
        -- Add payment_method column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'payment_method'
        ) THEN
            ALTER TABLE orders ADD COLUMN payment_method TEXT;
            RAISE NOTICE '  Added payment_method column';
        ELSE
            RAISE NOTICE '  payment_method column already exists';
        END IF;
        
        -- Add payment_status column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'payment_status'
        ) THEN
            ALTER TABLE orders ADD COLUMN payment_status TEXT DEFAULT 'pending';
            RAISE NOTICE '  Added payment_status column';
        ELSE
            RAISE NOTICE '  payment_status column already exists';
        END IF;
        
        -- Add notes column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'notes'
        ) THEN
            ALTER TABLE orders ADD COLUMN notes TEXT;
            RAISE NOTICE '  Added notes column';
        ELSE
            RAISE NOTICE '  notes column already exists';
        END IF;
        
        -- Add updated_at column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'updated_at'
        ) THEN
            ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
            RAISE NOTICE '  Added updated_at column';
        ELSE
            RAISE NOTICE '  updated_at column already exists';
        END IF;
        
        -- Add scheduled_at column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'scheduled_at'
        ) THEN
            ALTER TABLE orders ADD COLUMN scheduled_at TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  Added scheduled_at column';
        ELSE
            RAISE NOTICE '  scheduled_at column already exists';
        END IF;
        
        -- Add completed_at column if not exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'orders' AND column_name = 'completed_at'
        ) THEN
            ALTER TABLE orders ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;
            RAISE NOTICE '  Added completed_at column';
        ELSE
            RAISE NOTICE '  completed_at column already exists';
        END IF;
    ELSE
        RAISE NOTICE 'Orders table does not exist - will be created';
    END IF;
END $$;

-- Create indexes for performance (only if not exists)
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

-- Enable Row Level Security (RLS) - only if not enabled
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = 'users' AND n.nspname = 'public' AND c.relrowsecurity = true
    ) THEN
        ALTER TABLE users ENABLE ROW LEVEL SECURITY;
        RAISE NOTICE 'Enabled RLS on users table';
    ELSE
        RAISE NOTICE 'RLS already enabled on users table';
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
        RAISE NOTICE 'Enabled RLS on drivers table';
    ELSE
        RAISE NOTICE 'RLS already enabled on drivers table';
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
        RAISE NOTICE 'Enabled RLS on employees table';
    ELSE
        RAISE NOTICE 'RLS already enabled on employees table';
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
        RAISE NOTICE 'Enabled RLS on orders table';
    ELSE
        RAISE NOTICE 'RLS already enabled on orders table';
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
        RAISE NOTICE 'Enabled RLS on notifications table';
    ELSE
        RAISE NOTICE 'RLS already enabled on notifications table';
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
        RAISE NOTICE 'Enabled RLS on app_settings table';
    ELSE
        RAISE NOTICE 'RLS already enabled on app_settings table';
    END IF;
END $$;

-- Create security policies (only if not exists)
-- Read access policy
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON users FOR SELECT USING (true);
        RAISE NOTICE 'Created read policy for users table';
    ELSE
        RAISE NOTICE 'Read policy already exists for users table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON drivers FOR SELECT USING (true);
        RAISE NOTICE 'Created read policy for drivers table';
    ELSE
        RAISE NOTICE 'Read policy already exists for drivers table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'employees' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON employees FOR SELECT USING (true);
        RAISE NOTICE 'Created read policy for employees table';
    ELSE
        RAISE NOTICE 'Read policy already exists for employees table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'orders' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON orders FOR SELECT USING (true);
        RAISE NOTICE 'Created read policy for orders table';
    ELSE
        RAISE NOTICE 'Read policy already exists for orders table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'notifications' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON notifications FOR SELECT USING (true);
        RAISE NOTICE 'Created read policy for notifications table';
    ELSE
        RAISE NOTICE 'Read policy already exists for notifications table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'app_settings' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users" ON app_settings FOR SELECT USING (true);
        RAISE NOTICE 'Created read policy for app_settings table';
    ELSE
        RAISE NOTICE 'Read policy already exists for app_settings table';
    END IF;
END $$;

-- Write access policies
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable insert for all users'
    ) THEN
        CREATE POLICY "Enable insert for all users" ON users FOR INSERT WITH CHECK (true);
        RAISE NOTICE 'Created insert policy for users table';
    ELSE
        RAISE NOTICE 'Insert policy already exists for users table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable update for all users'
    ) THEN
        CREATE POLICY "Enable update for all users" ON users FOR UPDATE USING (true);
        RAISE NOTICE 'Created update policy for users table';
    ELSE
        RAISE NOTICE 'Update policy already exists for users table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' AND policyname = 'Enable delete for all users'
    ) THEN
        CREATE POLICY "Enable delete for all users" ON users FOR DELETE USING (true);
        RAISE NOTICE 'Created delete policy for users table';
    ELSE
        RAISE NOTICE 'Delete policy already exists for users table';
    END IF;
END $$;

-- Same policies for other tables
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable insert for all users'
    ) THEN
        CREATE POLICY "Enable insert for all users" ON drivers FOR INSERT WITH CHECK (true);
        RAISE NOTICE 'Created insert policy for drivers table';
    ELSE
        RAISE NOTICE 'Insert policy already exists for drivers table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable update for all users'
    ) THEN
        CREATE POLICY "Enable update for all users" ON drivers FOR UPDATE USING (true);
        RAISE NOTICE 'Created update policy for drivers table';
    ELSE
        RAISE NOTICE 'Update policy already exists for drivers table';
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'drivers' AND policyname = 'Enable delete for all users'
    ) THEN
        CREATE POLICY "Enable delete for all users" ON drivers FOR DELETE USING (true);
        RAISE NOTICE 'Created delete policy for drivers table';
    ELSE
        RAISE NOTICE 'Delete policy already exists for drivers table';
    END IF;
END $$;

-- Add default app settings (optional)
INSERT INTO app_settings (id, key, value, description) 
VALUES 
    ('app-config-1', 'app_name', '"Dandan Admin System"', 'Application name'),
    ('app-config-2', 'app_version', '"1.0.0"', 'Application version'),
    ('app-config-3', 'maintenance_mode', 'false', 'Maintenance mode'),
    ('app-config-4', 'max_file_size', '10485760', 'Maximum file size (10MB)'),
    ('app-config-5', 'supported_formats', '["jpg", "jpeg", "png", "pdf"]', 'Supported formats')
ON CONFLICT (id) DO NOTHING;

-- Success message
DO $$ 
BEGIN
    RAISE NOTICE 'Database schema fixed successfully!';
    RAISE NOTICE 'Checked existing tables and added missing columns';
    RAISE NOTICE 'Enabled Row Level Security';
    RAISE NOTICE 'Created indexes for performance';
    RAISE NOTICE 'Added default app settings';
    RAISE NOTICE 'Database is ready for admin dashboard!';
END $$;
