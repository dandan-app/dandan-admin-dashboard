# حل مشكلة الاتصال بـ Supabase

## 🚨 المشكلة
```
Error: Load failed (api.supabase.com)
```

## 🔍 التشخيص

### 1. تحقق من URL
```
https://jusynjgjjlvmrvbrnqik.supabase.co
```

### 2. تحقق من Anon Key
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI
```

## 🛠️ الحلول

### الحل 1: التحقق من Supabase Dashboard
1. اذهب إلى [supabase.com](https://supabase.com)
2. اختر مشروع `dndnapp`
3. تحقق من أن المشروع نشط
4. تحقق من إعدادات API

### الحل 2: اختبار الاتصال المباشر
```bash
curl -X GET "https://jusynjgjjlvmrvbrnqik.supabase.co/rest/v1/users" \
  -H "apikey: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI"
```

### الحل 3: إعادة إنشاء المفاتيح
1. اذهب إلى Supabase Dashboard
2. Settings > API
3. انسخ URL و Anon Key الجديدين
4. حدث الملفات التالية:
   - `lib/config/environment_config.dart`
   - `web/env.js`

### الحل 4: التحقق من الشبكة
```bash
# اختبار الاتصال
ping jusynjgjjlvmrvbrnqik.supabase.co

# اختبار HTTPS
curl -I https://jusynjgjjlvmrvbrnqik.supabase.co
```

## 🔧 إصلاح الكود

### 1. تحديث environment_config.dart
```dart
class EnvironmentConfig {
  static String get supabaseUrl {
    // تأكد من أن URL صحيح
    const url = 'https://jusynjgjjlvmrvbrnqik.supabase.co';
    print('🔗 استخدام Supabase URL: $url');
    return url;
  }
  
  static String get supabaseAnonKey {
    // تأكد من أن المفتاح صحيح
    const key = 'YOUR_ANON_KEY_HERE';
    print('🔑 استخدام Supabase Anon Key');
    return key;
  }
}
```

### 2. تحديث web/env.js
```javascript
const env = {
  SUPABASE_URL: 'https://jusynjgjjlvmrvbrnqik.supabase.co',
  SUPABASE_ANON_KEY: 'YOUR_ANON_KEY_HERE'
};
```

## 🧪 اختبار الاتصال

### 1. اختبار بسيط
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void testConnection() async {
  try {
    await Supabase.initialize(
      url: 'https://jusynjgjjlvmrvbrnqik.supabase.co',
      anonKey: 'YOUR_ANON_KEY_HERE',
    );
    
    final client = Supabase.instance.client;
    final response = await client.from('users').select().limit(1);
    print('✅ الاتصال يعمل!');
  } catch (e) {
    print('❌ خطأ في الاتصال: $e');
  }
}
```

### 2. اختبار في المتصفح
افتح Developer Tools (F12) واذهب إلى Console، ثم شغل:
```javascript
fetch('https://jusynjgjjlvmrvbrnqik.supabase.co/rest/v1/users', {
  headers: {
    'apikey': 'YOUR_ANON_KEY_HERE',
    'Authorization': 'Bearer YOUR_ANON_KEY_HERE'
  }
})
.then(response => response.json())
.then(data => console.log('✅ الاتصال يعمل:', data))
.catch(error => console.error('❌ خطأ:', error));
```

## 📋 قائمة التحقق

- [ ] تحقق من صحة URL
- [ ] تحقق من صحة Anon Key
- [ ] تأكد من أن المشروع نشط في Supabase
- [ ] تحقق من إعدادات الشبكة
- [ ] اختبر الاتصال المباشر
- [ ] حدث المفاتيح إذا لزم الأمر

## 🆘 إذا استمرت المشكلة

1. **تحقق من Supabase Status**: [status.supabase.com](https://status.supabase.com)
2. **تحقق من إعدادات المشروع**: تأكد من أن المشروع نشط
3. **تحقق من المفاتيح**: تأكد من أن Anon Key صحيح
4. **تحقق من الشبكة**: تأكد من عدم وجود حجب للشبكة
5. **اتصل بالدعم**: إذا لم تحل المشكلة

## 📞 الدعم

- Supabase Support: [supabase.com/support](https://supabase.com/support)
- Discord: [discord.supabase.com](https://discord.supabase.com)
- GitHub Issues: [github.com/supabase/supabase](https://github.com/supabase/supabase)
