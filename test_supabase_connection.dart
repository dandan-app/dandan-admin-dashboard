import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  print('🧪 اختبار الاتصال بـ Supabase...');
  
  // إعدادات Supabase - مشروع dndnapp
  const supabaseUrl = 'https://jusynjgjjlvmrvbrnqik.supabase.co';
  const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI';
  
  print('🔗 URL: $supabaseUrl');
  print('🔑 Key: ${supabaseAnonKey.substring(0, 20)}...');
  
  try {
    // تهيئة Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    print('✅ تم تهيئة Supabase بنجاح');
    
    // اختبار الاتصال
    final client = Supabase.instance.client;
    
    // اختبار بسيط - جلب البيانات
    print('🔍 اختبار الاتصال...');
    
    try {
      // محاولة جلب البيانات من جدول users
      final response = await client.from('users').select().limit(1);
      print('✅ تم الاتصال بنجاح!');
      print('📊 عدد المستخدمين: ${response.length}');
    } catch (e) {
      print('❌ خطأ في جلب البيانات: $e');
      
      // محاولة اختبار الاتصال الأساسي
      try {
        final response = await client.from('users').select('count').limit(1);
        print('✅ الاتصال يعمل، لكن قد تكون هناك مشكلة في الجدول');
      } catch (e2) {
        print('❌ خطأ في الاتصال: $e2');
      }
    }
    
  } catch (e) {
    print('❌ فشل في تهيئة Supabase: $e');
    
    // اقتراحات لحل المشكلة
    print('\n🔧 اقتراحات لحل المشكلة:');
    print('1. تحقق من صحة URL: $supabaseUrl');
    print('2. تحقق من صحة Anon Key');
    print('3. تأكد من أن المشروع نشط في Supabase');
    print('4. تحقق من إعدادات الشبكة');
  }
}