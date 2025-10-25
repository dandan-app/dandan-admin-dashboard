class EnvironmentConfig {
  // إعدادات Supabase - مشروع dndnapp (القاعدة الرسمية)
  // استخدام القيم الثابتة لضمان الاتصال الصحيح
  
  // الحصول على Supabase URL - يدعم متغيرات البيئة في Vercel
  static String get supabaseUrl {
    // محاولة قراءة من متغيرات البيئة أولاً (للـ Vercel)
    const envUrl = String.fromEnvironment('SUPABASE_URL');
    if (envUrl.isNotEmpty) {
      print('🔗 استخدام Supabase URL من البيئة: $envUrl');
      return envUrl;
    }
    
    // القيمة الثابتة كـ fallback لمشروع dndnapp
    const url = 'https://jusynjgjjlvmrvbrnqik.supabase.co';
    print('🔗 استخدام Supabase URL الثابت: $url');
    return url;
  }
  
  // الحصول على Supabase Anon Key - يدعم متغيرات البيئة في Vercel
  static String get supabaseAnonKey {
    // محاولة قراءة من متغيرات البيئة أولاً (للـ Vercel)
    const envKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (envKey.isNotEmpty) {
      print('🔑 استخدام Supabase Anon Key من البيئة');
      return envKey;
    }
    
    // القيمة الثابتة كـ fallback لمشروع dndnapp
    const key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI';
    print('🔑 استخدام Supabase Anon Key الثابت');
    return key;
  }
  
  // طباعة معلومات التصحيح
  static void printDebugInfo() {
    print('=== معلومات البيئة ===');
    print('SUPABASE_URL: ${supabaseUrl}');
    print('SUPABASE_ANON_KEY: ${supabaseAnonKey.substring(0, 20)}...');
    print('مشروع: dndnapp (القاعدة الرسمية)');
    print('=====================');
  }
}
