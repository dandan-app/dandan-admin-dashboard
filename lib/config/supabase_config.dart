import 'package:supabase_flutter/supabase_flutter.dart';
import 'environment_config.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  
  // إعدادات Supabase - مشروع dndnapp (القاعدة الرسمية)
  static String get supabaseUrl => EnvironmentConfig.supabaseUrl;
  static String get supabaseAnonKey => EnvironmentConfig.supabaseAnonKey;
  
  // تهيئة Supabase
  static Future<void> initialize() async {
    // طباعة معلومات التصحيح
    EnvironmentConfig.printDebugInfo();
    
    print('🔗 تهيئة Supabase مع:');
    print('URL: ${supabaseUrl}');
    print('Anon Key: ${supabaseAnonKey.substring(0, 20)}...');
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
    
    print('✅ تم تهيئة Supabase بنجاح');
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
