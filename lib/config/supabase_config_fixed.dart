import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfigFixed {
  static SupabaseClient? _client;
  
  // إعدادات Supabase - مشروع dndnapp (القاعدة الرسمية)
  // استخدام القيم الثابتة مع معالجة الأخطاء
  
  static const String supabaseUrl = 'https://jusynjgjjlvmrvbrnqik.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI';
  
  // تهيئة Supabase مع معالجة الأخطاء
  static Future<void> initialize() async {
    try {
      print('🔗 تهيئة Supabase مع:');
      print('URL: $supabaseUrl');
      print('Anon Key: ${supabaseAnonKey.substring(0, 20)}...');
      
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      
      print('✅ تم تهيئة Supabase بنجاح');
      
      // اختبار الاتصال
      await _testConnection();
      
    } catch (e) {
      print('❌ خطأ في تهيئة Supabase: $e');
      print('🔧 جاري المحاولة مرة أخرى...');
      
      // محاولة ثانية بعد تأخير قصير
      await Future.delayed(Duration(seconds: 2));
      
      try {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
        _client = Supabase.instance.client;
        print('✅ تم تهيئة Supabase في المحاولة الثانية');
      } catch (e2) {
        print('❌ فشل في تهيئة Supabase: $e2');
        throw Exception('فشل في الاتصال بـ Supabase: $e2');
      }
    }
  }
  
  // اختبار الاتصال
  static Future<void> _testConnection() async {
    try {
      final client = Supabase.instance.client;
      
      // اختبار بسيط - جلب البيانات
      print('🔍 اختبار الاتصال...');
      
      final response = await client.from('users').select().limit(1);
      print('✅ تم الاتصال بنجاح!');
      print('📊 عدد المستخدمين: ${response.length}');
      
    } catch (e) {
      print('⚠️ تحذير: لا يمكن جلب البيانات من جدول users: $e');
      print('💡 قد يكون الجدول فارغاً أو غير موجود');
      
      // محاولة اختبار الاتصال الأساسي
      try {
        final client = Supabase.instance.client;
        final response = await client.from('users').select('count').limit(1);
        print('✅ الاتصال يعمل، لكن قد تكون هناك مشكلة في الجدول');
      } catch (e2) {
        print('❌ خطأ في الاتصال: $e2');
        throw Exception('فشل في الاتصال بقاعدة البيانات: $e2');
      }
    }
  }
  
  // الحصول على مثيل Supabase
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase لم يتم تهيئته بعد. يرجى استدعاء initialize() أولاً.');
    }
    return _client!;
  }
  
  // التحقق من حالة التهيئة
  static bool get isInitialized => _client != null;
  
  // الحصول على Auth
  static GoTrueClient get auth => client.auth;
  
  // الحصول على Database
  static SupabaseQueryBuilder get database => client.from('');
  
  // إعادة تهيئة الاتصال
  static Future<void> reconnect() async {
    print('🔄 إعادة الاتصال بـ Supabase...');
    _client = null;
    await initialize();
  }
  
  // التحقق من صحة الاتصال
  static Future<bool> isConnected() async {
    try {
      if (_client == null) return false;
      
      // اختبار بسيط
      await _client!.from('users').select().limit(1);
      return true;
    } catch (e) {
      print('❌ فشل في التحقق من الاتصال: $e');
      return false;
    }
  }
}
