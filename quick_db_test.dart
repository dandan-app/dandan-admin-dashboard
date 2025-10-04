import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  print('🔄 بدء اختبار قاعدة البيانات...');
  
  try {
    // تهيئة Supabase
    await Supabase.initialize(
      url: 'https://lhhlysnqflbsfdjdgavu.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoaGx5c25xZmxic2ZkamRnYXZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzNjM3MjcsImV4cCI6MjA3NDkzOTcyN30.KrX4tKeSxBQaVUrwE8_w0pExjwbyNF6XBZsl0b5-B0U',
    );
    
    print('✅ تم تهيئة Supabase بنجاح!');
    
    final client = Supabase.instance.client;
    
    // اختبار الجداول المختلفة
    final tables = ['users', 'employees', 'drivers', 'orders', 'notifications', 'app_settings'];
    
    for (String table in tables) {
      try {
        final result = await client.from(table).select().limit(1);
        print('✅ جدول $table: متاح (${result.length} صف)');
      } catch (e) {
        print('❌ جدول $table: خطأ - $e');
      }
    }
    
    // اختبار إحصائيات بسيطة
    try {
      final users = await client.from('users').select();
      final employees = await client.from('employees').select();
      final drivers = await client.from('drivers').select();
      final orders = await client.from('orders').select();
      
      print('\n📊 إحصائيات قاعدة البيانات:');
      print('👥 المستخدمين: ${users.length}');
      print('👨‍💼 الموظفين: ${employees.length}');
      print('🚗 السائقين: ${drivers.length}');
      print('📦 الطلبات: ${orders.length}');
      
    } catch (e) {
      print('❌ خطأ في الحصول على الإحصائيات: $e');
    }
    
    print('\n🎉 تم اختبار قاعدة البيانات بنجاح!');
    
  } catch (e) {
    print('❌ خطأ في الاتصال: $e');
  }
}

