# متغيرات البيئة المطلوبة لـ Netlify

## إعدادات Supabase - مشروع dndnapp

### متغيرات البيئة في Netlify:

1. اذهب إلى Netlify Dashboard
2. اختر الموقع
3. Site settings > Environment variables
4. أضف المتغيرات التالية:

```
SUPABASE_URL = https://jusynjgjjlvmrvbrnqik.supabase.co
SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI
```

### متغيرات إضافية (اختيارية):

```
APP_ENV = production
DEBUG_MODE = false
```

## التحقق من الإعدادات:

1. تأكد من أن المتغيرات موجودة في Netlify
2. أعد نشر الموقع بعد إضافة المتغيرات
3. تحقق من سجل النشر للتأكد من عدم وجود أخطاء

## ملاحظات:

- هذه المفاتيح خاصة بمشروع dndnapp (القاعدة الرسمية)
- تم حذف مشروع dandan-admin القديم
- جميع العمليات ستتم على قاعدة واحدة بدون تعارض
