import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  
  // إعدادات Supabase - مشروع dndnapp (القاعدة الرسمية)
  static const String supabaseUrl = 'https://jusynjgjjlvmrvbrnqik.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI';
  
  // تهيئة Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
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
}
