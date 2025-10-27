# نظام دندن الإداري - Vercel Deployment

## 🎯 نظرة عامة
لوحة تحكم إدارية متكاملة لنظام دندن للنقل، مطورة بـ Flutter Web ومربوطة بـ Supabase.

## 🔗 الروابط

### ✅ الرابط الرئيسي على Vercel:
**https://dandan-admin-dashboard.vercel.app**

### 🎯 الرابط المخصص (بعد إعداد DNS):
**https://admin.dandan.sa**

## 🚀 المميزات

### 📊 لوحة التحكم
- إحصائيات حقيقية من قاعدة البيانات Supabase
- رسوم بيانية تفاعلية
- الأنشطة الأخيرة
- بيانات مباشرة ومحدثة

### 👥 إدارة المستخدمين
- عرض جميع المستخدمين
- أدوار مختلفة (admin, operations, support, financial)
- حالة النشاط
- معلومات مفصلة

### 📦 إدارة الطلبات
- قائمة شاملة للطلبات
- حالات مختلفة (في الانتظار، مؤكد، قيد التنفيذ، مكتمل، ملغي)
- تفاصيل العميل والموقع
- تتبع الوقت

### 🚛 إدارة السائقين
- معلومات السائقين
- حالة التوفر
- تقييمات ورحلات
- موقع GPS

### 👨‍💼 إدارة الموظفين
- معلومات الموظفين
- حالات مختلفة (نشط، غير نشط، معلق، منتهي)
- تفاصيل الوظيفة والراتب
- تتبع الأداء

## 🛠️ التقنيات المستخدمة

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Hosting**: Vercel
- **Charts**: FL Chart
- **State Management**: Flutter Bloc
- **Routing**: Go Router

## 📁 هيكل المشروع

```
lib/
├── config/
│   ├── supabase_config.dart         # إعدادات Supabase
│   └── environment_config.dart     # إعدادات البيئة
├── models/
│   ├── user_model.dart             # نموذج المستخدم
│   ├── order_model.dart            # نموذج الطلب
│   ├── driver_model.dart           # نموذج السائق
│   └── employee_model.dart         # نموذج الموظف
├── services/
│   └── supabase_database_service.dart # خدمات قاعدة البيانات
├── utils/
│   └── sample_data.dart            # البيانات التجريبية
└── main.dart                       # الملف الرئيسي
```

## 🔧 إعدادات الإنتاج

### Supabase Configuration
- **Project URL**: https://jusynjgjjlvmrvbrnqik.supabase.co
- **Anon Key**: متوفر في متغيرات البيئة
- **Database**: PostgreSQL مع RLS

### Vercel Environment Variables
```
SUPABASE_URL=https://jusynjgjjlvmrvbrnqik.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 🚀 النشر على Vercel

### النشر التلقائي:
1. ربط المستودع مع Vercel
2. إعداد متغيرات البيئة
3. النشر التلقائي عند كل push

### النشر اليدوي:
```bash
# بناء المشروع
flutter build web --release

# نشر على Vercel
vercel --prod
```

## 🔄 التحديثات

### إضافة بيانات تجريبية:
1. افتح التطبيق
2. اضغط على "إضافة بيانات تجريبية"
3. انتظر رسالة النجاح

### إعادة النشر:
```bash
git add .
git commit -m "تحديث جديد"
git push origin main
# Vercel سيقوم بالنشر التلقائي
```

## 📊 المراقبة

### Vercel Dashboard:
- **المشروع**: https://vercel.com/dashboard
- **Analytics**: متاح في Vercel Dashboard
- **Logs**: تتبع الأخطاء والأداء

### Supabase Dashboard:
- **المشروع**: https://supabase.com/dashboard
- **Database**: مراقبة قاعدة البيانات
- **Auth**: إدارة المستخدمين

## 🔒 الأمان

### Supabase Security:
- Row Level Security (RLS)
- حماية قاعدة البيانات
- صلاحيات المستخدمين
- قواعد الوصول

### HTTPS:
- شهادة SSL تلقائية من Vercel
- إعادة توجيه من HTTP إلى HTTPS
- حماية البيانات

## 📱 التوافق

### المتصفحات المدعومة:
- ✅ Chrome (أحدث إصدار)
- ✅ Firefox (أحدث إصدار)
- ✅ Safari (أحدث إصدار)
- ✅ Edge (أحدث إصدار)

### الأجهزة:
- ✅ Desktop
- ✅ Tablet
- ✅ Mobile (responsive)

## 🆘 الدعم الفني

### المشاكل الشائعة:
1. **الدومين لا يعمل**: تحقق من إعدادات DNS في Vercel
2. **SSL لا يعمل**: انتظر 5-10 دقائق
3. **البيانات لا تظهر**: اضغط على "إضافة بيانات تجريبية"
4. **خطأ في الاتصال**: تحقق من متغيرات البيئة في Vercel

### جهات الاتصال:
- Vercel Support: https://vercel.com/support
- Supabase Support: https://supabase.com/support
- Flutter Web: https://flutter.dev/web

## 📈 الأداء

### سرعة التحميل:
- ⚡ تحميل سريع (< 3 ثوان)
- 🚀 CDN عالمي من Vercel
- 📦 تحسين الملفات تلقائياً

### الاستقرار:
- 🔄 Uptime 99.9%
- 🛡️ نسخ احتياطية تلقائية
- 🔧 صيانة تلقائية

## 🔄 Migration من Firebase

تم إنجاز الهجرة بنجاح من Firebase إلى Supabase:

### ✅ تم إنجازه:
- إزالة جميع ملفات Firebase
- تحديث الكود للعمل مع Supabase
- إعداد متغيرات البيئة في Vercel
- تحديث إعدادات النشر

### 🎯 الفوائد:
- أداء أفضل مع PostgreSQL
- تكلفة أقل
- مرونة أكبر في الاستعلامات
- دعم أفضل للعلاقات المعقدة

---

**تم النشر بنجاح على Vercel! 🎉**

**الرابط الرئيسي**: https://dandan-admin-dashboard.vercel.app
**الرابط المخصص**: https://admin.dandan.sa (بعد إعداد DNS)
