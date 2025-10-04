# دليل إعداد Supabase

## 🎯 الهدف
ربط لوحة تحكم دندن الإدارية مع مشروع Supabase الجديد `dandan-admin`

## 📋 المتطلبات
1. مشروع Supabase: `dandan-admin`
2. Project URL من Supabase Dashboard
3. Anon Key من Supabase Dashboard
4. Flutter CLI مثبت

## 🚀 خطوات الإعداد

### 1. إعداد قاعدة البيانات

#### أ) إنشاء الجداول:
1. اذهب إلى Supabase Dashboard: https://supabase.com/dashboard
2. اختر مشروع `dandan-admin`
3. اذهب إلى `SQL Editor`
4. انسخ محتوى ملف `supabase_schema.sql`
5. الصق الكود في SQL Editor واضغط `Run`

#### ب) إعداد التخزين (Storage):
1. اذهب إلى `Storage` في القائمة الجانبية
2. أنشئ bucket جديد باسم `images`
3. فعّل `Public bucket` إذا كنت تريد الوصول العام للصور

### 2. تحديث إعدادات التطبيق

#### أ) تحديث ملف التكوين:
1. افتح `lib/config/supabase_config.dart`
2. استبدل `YOUR_SUPABASE_URL` بـ Project URL من Supabase
3. استبدل `YOUR_SUPABASE_ANON_KEY` بـ Anon Key من Supabase

```dart
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

### 3. تشغيل التطبيق

```bash
# تثبيت التبعيات
flutter pub get

# تشغيل التطبيق
flutter run -d web-server --web-port 8080
```

## 📊 الجداول المطلوبة

### 1. جدول المستخدمين (users)
- `id`: معرف فريد
- `name`: الاسم الكامل
- `email`: البريد الإلكتروني
- `phone`: رقم الهاتف
- `role`: دور المستخدم (admin, user, driver)
- `is_active`: حالة النشاط
- `created_at`: تاريخ الإنشاء
- `last_login`: آخر تسجيل دخول
- `address`: العنوان (JSON)
- `profile_image_url`: رابط الصورة الشخصية

### 2. جدول السائقين (drivers)
- `id`: معرف فريد
- `name`: الاسم الكامل
- `email`: البريد الإلكتروني
- `phone`: رقم الهاتف
- `license_number`: رقم الرخصة
- `vehicle_type`: نوع المركبة
- `vehicle_model`: موديل المركبة
- `vehicle_plate`: رقم اللوحة
- `status`: الحالة (available, busy, offline, suspended)
- `rating`: التقييم
- `total_rides`: إجمالي الرحلات
- `is_active`: حالة النشاط
- `created_at`: تاريخ الإنشاء
- `last_active`: آخر نشاط
- `location`: الموقع (JSON)
- `profile_image_url`: رابط الصورة الشخصية

### 3. جدول الموظفين (employees)
- `id`: معرف فريد
- `name`: الاسم الكامل
- `email`: البريد الإلكتروني
- `phone`: رقم الهاتف
- `employee_id`: رقم الموظف
- `department`: القسم
- `position`: المنصب
- `salary`: الراتب
- `hire_date`: تاريخ التوظيف
- `status`: الحالة (active, inactive, suspended, terminated)
- `is_active`: حالة النشاط
- `created_at`: تاريخ الإنشاء
- `updated_at`: تاريخ التحديث
- `profile_image_url`: رابط الصورة الشخصية
- `address`: العنوان (JSON)
- `emergency_contact`: جهة الاتصال في الطوارئ (JSON)

### 4. جدول الطلبات (orders)
- `id`: معرف فريد
- `user_id`: معرف المستخدم
- `driver_id`: معرف السائق
- `pickup_address`: عنوان الاستلام
- `delivery_address`: عنوان التسليم
- `pickup_location`: موقع الاستلام (JSON)
- `delivery_location`: موقع التسليم (JSON)
- `items`: العناصر (JSON)
- `total_amount`: المبلغ الإجمالي
- `delivery_fee`: رسوم التوصيل
- `status`: الحالة (pending, confirmed, in_progress, completed, cancelled)
- `payment_method`: طريقة الدفع
- `payment_status`: حالة الدفع
- `notes`: ملاحظات
- `created_at`: تاريخ الإنشاء
- `updated_at`: تاريخ التحديث
- `scheduled_at`: وقت الجدولة
- `completed_at`: وقت الإكمال

### 5. جدول الإشعارات (notifications)
- `id`: معرف فريد
- `user_id`: معرف المستخدم
- `title`: العنوان
- `message`: الرسالة
- `type`: نوع الإشعار
- `is_read`: تم القراءة
- `created_at`: تاريخ الإنشاء
- `data`: بيانات إضافية (JSON)

### 6. جدول إعدادات التطبيق (app_settings)
- `id`: معرف فريد
- `key`: المفتاح
- `value`: القيمة (JSON)
- `description`: الوصف
- `updated_at`: تاريخ التحديث

## 🔧 إعدادات الأمان

تم تمكين Row Level Security (RLS) على جميع الجداول. يمكنك تخصيص السياسات حسب متطلبات الأمان:

1. اذهب إلى `Authentication` > `Policies`
2. قم بتعديل السياسات حسب الحاجة
3. يمكنك إضافة سياسات أكثر تفصيلاً للتحكم في الوصول

## 📱 اختبار التطبيق

### 1. اختبار الاتصال:
- تأكد من ظهور لوحة التحكم بدون أخطاء
- تحقق من تحميل الإحصائيات

### 2. اختبار إدارة المستخدمين:
- إضافة مستخدم جديد
- تعديل بيانات مستخدم
- حذف مستخدم

### 3. اختبار إدارة الطلبات:
- عرض الطلبات
- تحديث حالة الطلب
- حذف طلب

### 4. اختبار إدارة الموظفين:
- إضافة موظف جديد
- تعديل بيانات موظف
- حذف موظف

## 🚨 استكشاف الأخطاء

### مشكلة: خطأ في الاتصال
- تأكد من صحة Project URL و Anon Key
- تحقق من إعدادات الشبكة

### مشكلة: خطأ في الصلاحيات
- تحقق من إعدادات RLS
- تأكد من صحة السياسات

### مشكلة: خطأ في البيانات
- تحقق من هيكل الجداول
- تأكد من تطابق أسماء الأعمدة

## 📞 الدعم

- **Supabase Dashboard**: https://supabase.com/dashboard
- **Documentation**: https://supabase.com/docs
- **Community**: https://github.com/supabase/supabase/discussions

---

**تم إعداد المشروع بنجاح! 🎉**
