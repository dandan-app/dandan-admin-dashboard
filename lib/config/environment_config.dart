class EnvironmentConfig {
  // إعدادات Supabase - مشروع dndnapp (القاعدة الرسمية)
  // استخدام القيم الثابتة لضمان الاتصال الصحيح
  
  // الحصول على Supabase URL
  static String get supabaseUrl {
    // القيمة الثابتة لمشروع dndnapp
    const url = 'https://jusynjgjjlvmrvbrnqik.supabase.co';
    print('🔗 استخدام Supabase URL: $url');
    return url;
  }
  
  // الحصول على Supabase Anon Key
  static String get supabaseAnonKey {
    // القيمة الثابتة لمشروع dndnapp
    const key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI';
    print('🔑 استخدام Supabase Anon Key');
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
