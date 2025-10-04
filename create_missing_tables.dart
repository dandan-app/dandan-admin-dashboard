import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔄 إنشاء الجداول المفقودة في Supabase...');
  
  const String supabaseUrl = 'https://lhhlysnqflbsfdjdgavu.supabase.co';
  const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoaGx5c25xZmxic2ZkamRnYXZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzNjM3MjcsImV4cCI6MjA3NDkzOTcyN30.KrX4tKeSxBQaVUrwE8_w0pExjwbyNF6XBZsl0b5-B0U';
  
  // SQL statements لإنشاء الجداول المفقودة
  final createTablesSQL = '''
-- جدول المستخدمين
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

-- جدول السائقين
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

-- جدول الطلبات
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

-- جدول الإشعارات
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

-- جدول إعدادات التطبيق
CREATE TABLE IF NOT EXISTS app_settings (
    id TEXT PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- تمكين Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- إنشاء سياسات الأمان
CREATE POLICY "Enable read access for all users" ON users FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON drivers FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON orders FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON notifications FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON app_settings FOR SELECT USING (true);

CREATE POLICY "Enable insert for all users" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON users FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON users FOR DELETE USING (true);

CREATE POLICY "Enable insert for all users" ON drivers FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON drivers FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON drivers FOR DELETE USING (true);

CREATE POLICY "Enable insert for all users" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON orders FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON orders FOR DELETE USING (true);

CREATE POLICY "Enable insert for all users" ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON notifications FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON notifications FOR DELETE USING (true);

CREATE POLICY "Enable insert for all users" ON app_settings FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for all users" ON app_settings FOR UPDATE USING (true);
CREATE POLICY "Enable delete for all users" ON app_settings FOR DELETE USING (true);
''';

  try {
    print('🔄 إرسال SQL لإنشاء الجداول...');
    
    final client = HttpClient();
    final request = await client.postUrl(
      Uri.parse('$supabaseUrl/rest/v1/rpc/exec_sql')
    );
    
    request.headers.set('apikey', anonKey);
    request.headers.set('Authorization', 'Bearer $anonKey');
    request.headers.set('Content-Type', 'application/json');
    
    final body = json.encode({
      'sql': createTablesSQL
    });
    
    request.write(body);
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ تم إنشاء الجداول بنجاح!');
      print('الاستجابة: $responseBody');
    } else {
      print('❌ خطأ في إنشاء الجداول: ${response.statusCode}');
      print('الاستجابة: $responseBody');
    }
    
    client.close();
    
  } catch (e) {
    print('❌ خطأ في إنشاء الجداول: $e');
  }
  
  // إدراج بيانات تجريبية
  await insertSampleData(supabaseUrl, anonKey);
  
  print('\n🎉 تم إنشاء الجداول وإدراج البيانات التجريبية!');
}

Future<void> insertSampleData(String supabaseUrl, String anonKey) async {
  print('🔄 إدراج بيانات تجريبية...');
  
  try {
    final client = HttpClient();
    
    // إدراج مستخدمين تجريبيين
    final usersData = [
      {
        'id': 'user_001',
        'name': 'أحمد محمد العلي',
        'email': 'ahmed@example.com',
        'phone': '+966501234567',
        'role': 'admin',
        'is_active': true
      },
      {
        'id': 'user_002',
        'name': 'فاطمة السالم',
        'email': 'fatima@example.com',
        'phone': '+966502345678',
        'role': 'user',
        'is_active': true
      }
    ];
    
    for (var user in usersData) {
      final request = await client.postUrl(
        Uri.parse('$supabaseUrl/rest/v1/users')
      );
      
      request.headers.set('apikey', anonKey);
      request.headers.set('Authorization', 'Bearer $anonKey');
      request.headers.set('Content-Type', 'application/json');
      
      request.write(json.encode(user));
      final response = await request.close();
      
      if (response.statusCode == 201) {
        print('✅ تم إدراج مستخدم: ${user['name']}');
      } else {
        print('❌ خطأ في إدراج مستخدم: ${user['name']}');
      }
    }
    
    // إدراج سائقين تجريبيين
    final driversData = [
      {
        'id': 'driver_001',
        'name': 'سعد الأحمد',
        'email': 'saad@example.com',
        'phone': '+966504567890',
        'license_number': 'DL123456',
        'vehicle_type': 'سيارة',
        'vehicle_plate': 'أ ب ج 1234',
        'status': 'available',
        'rating': 4.5,
        'total_rides': 150,
        'is_active': true
      }
    ];
    
    for (var driver in driversData) {
      final request = await client.postUrl(
        Uri.parse('$supabaseUrl/rest/v1/drivers')
      );
      
      request.headers.set('apikey', anonKey);
      request.headers.set('Authorization', 'Bearer $anonKey');
      request.headers.set('Content-Type', 'application/json');
      
      request.write(json.encode(driver));
      final response = await request.close();
      
      if (response.statusCode == 201) {
        print('✅ تم إدراج سائق: ${driver['name']}');
      } else {
        print('❌ خطأ في إدراج سائق: ${driver['name']}');
      }
    }
    
    client.close();
    
  } catch (e) {
    print('❌ خطأ في إدراج البيانات التجريبية: $e');
  }
}

