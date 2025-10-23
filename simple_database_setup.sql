-- Simple database setup for dndnapp project
-- This script creates tables and adds missing columns safely

-- First, check what tables exist
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

-- Create users table if not exists
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

-- Create drivers table if not exists
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

-- Create employees table if not exists
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

-- Create orders table if not exists
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

-- Create notifications table if not exists
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

-- Create app_settings table if not exists
CREATE TABLE IF NOT EXISTS app_settings (
    id TEXT PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add missing columns to users table (if table exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users' AND table_schema = 'public') THEN
        -- Add role column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'role') THEN
            ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user';
        END IF;
        
        -- Add is_active column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'is_active') THEN
            ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT true;
        END IF;
        
        -- Add last_login column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'last_login') THEN
            ALTER TABLE users ADD COLUMN last_login TIMESTAMP WITH TIME ZONE;
        END IF;
        
        -- Add address column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'address') THEN
            ALTER TABLE users ADD COLUMN address JSONB;
        END IF;
        
        -- Add profile_image_url column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'profile_image_url') THEN
            ALTER TABLE users ADD COLUMN profile_image_url TEXT;
        END IF;
    END IF;
END $$;

-- Add missing columns to drivers table (if table exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'drivers' AND table_schema = 'public') THEN
        -- Add license_number column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'license_number') THEN
            ALTER TABLE drivers ADD COLUMN license_number TEXT;
        END IF;
        
        -- Add vehicle_type column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'vehicle_type') THEN
            ALTER TABLE drivers ADD COLUMN vehicle_type TEXT;
        END IF;
        
        -- Add vehicle_model column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'vehicle_model') THEN
            ALTER TABLE drivers ADD COLUMN vehicle_model TEXT;
        END IF;
        
        -- Add vehicle_plate column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'vehicle_plate') THEN
            ALTER TABLE drivers ADD COLUMN vehicle_plate TEXT;
        END IF;
        
        -- Add status column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'status') THEN
            ALTER TABLE drivers ADD COLUMN status TEXT DEFAULT 'offline';
        END IF;
        
        -- Add rating column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'rating') THEN
            ALTER TABLE drivers ADD COLUMN rating DECIMAL(3,2) DEFAULT 0.0;
        END IF;
        
        -- Add total_rides column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'total_rides') THEN
            ALTER TABLE drivers ADD COLUMN total_rides INTEGER DEFAULT 0;
        END IF;
        
        -- Add is_active column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'is_active') THEN
            ALTER TABLE drivers ADD COLUMN is_active BOOLEAN DEFAULT true;
        END IF;
        
        -- Add last_active column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'last_active') THEN
            ALTER TABLE drivers ADD COLUMN last_active TIMESTAMP WITH TIME ZONE;
        END IF;
        
        -- Add location column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'location') THEN
            ALTER TABLE drivers ADD COLUMN location JSONB;
        END IF;
        
        -- Add profile_image_url column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'drivers' AND column_name = 'profile_image_url') THEN
            ALTER TABLE drivers ADD COLUMN profile_image_url TEXT;
        END IF;
    END IF;
END $$;

-- Add missing columns to orders table (if table exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'orders' AND table_schema = 'public') THEN
        -- Add driver_id column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'driver_id') THEN
            ALTER TABLE orders ADD COLUMN driver_id TEXT;
        END IF;
        
        -- Add pickup_location column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'pickup_location') THEN
            ALTER TABLE orders ADD COLUMN pickup_location JSONB;
        END IF;
        
        -- Add delivery_location column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivery_location') THEN
            ALTER TABLE orders ADD COLUMN delivery_location JSONB;
        END IF;
        
        -- Add items column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'items') THEN
            ALTER TABLE orders ADD COLUMN items JSONB;
        END IF;
        
        -- Add total_amount column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'total_amount') THEN
            ALTER TABLE orders ADD COLUMN total_amount DECIMAL(10,2);
        END IF;
        
        -- Add delivery_fee column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivery_fee') THEN
            ALTER TABLE orders ADD COLUMN delivery_fee DECIMAL(10,2) DEFAULT 0;
        END IF;
        
        -- Add status column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'status') THEN
            ALTER TABLE orders ADD COLUMN status TEXT DEFAULT 'pending';
        END IF;
        
        -- Add payment_method column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'payment_method') THEN
            ALTER TABLE orders ADD COLUMN payment_method TEXT;
        END IF;
        
        -- Add payment_status column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'payment_status') THEN
            ALTER TABLE orders ADD COLUMN payment_status TEXT DEFAULT 'pending';
        END IF;
        
        -- Add notes column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'notes') THEN
            ALTER TABLE orders ADD COLUMN notes TEXT;
        END IF;
        
        -- Add updated_at column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'updated_at') THEN
            ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        END IF;
        
        -- Add scheduled_at column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'scheduled_at') THEN
            ALTER TABLE orders ADD COLUMN scheduled_at TIMESTAMP WITH TIME ZONE;
        END IF;
        
        -- Add completed_at column if not exists
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'completed_at') THEN
            ALTER TABLE orders ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;
        END IF;
    END IF;
END $$;

-- Create indexes for performance
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

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- Create basic security policies
CREATE POLICY "Enable read access for all users" ON users FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON users FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON users FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON drivers FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON drivers FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON drivers FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON drivers FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON employees FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON employees FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON employees FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON employees FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON orders FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON orders FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON orders FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON notifications FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON notifications FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON notifications FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON app_settings FOR SELECT USING (true);
CREATE POLICY "Enable insert for all users" ON app_settings FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON app_settings FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON app_settings FOR DELETE USING (true);

-- Add default app settings
INSERT INTO app_settings (id, key, value, description) 
VALUES 
    ('app-config-1', 'app_name', '"Dandan Admin System"', 'Application name'),
    ('app-config-2', 'app_version', '"1.0.0"', 'Application version'),
    ('app-config-3', 'maintenance_mode', 'false', 'Maintenance mode'),
    ('app-config-4', 'max_file_size', '10485760', 'Maximum file size (10MB)'),
    ('app-config-5', 'supported_formats', '["jpg", "jpeg", "png", "pdf"]', 'Supported formats')
ON CONFLICT (id) DO NOTHING;

-- Success message
SELECT 'Database setup completed successfully!' as message;
