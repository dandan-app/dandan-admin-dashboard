# نظام دندن الإداري - الإنتاج

## 🎯 نظرة عامة
لوحة تحكم إدارية متكاملة لنظام دندن للنقل، مطورة بـ Flutter Web ومربوطة بـ Firebase.

## 🔗 الروابط

### ✅ الرابط المؤقت (يعمل الآن):
**https://dandn-admin-dashboard.web.app**

### 🎯 الرابط المخصص (بعد إعداد DNS):
**https://admin.dandan.sa**

## 🚀 المميزات

### 📊 لوحة التحكم
- إحصائيات حقيقية من قاعدة البيانات
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

## 🛠️ التقنيات المستخدمة

- **Frontend**: Flutter Web
- **Backend**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Hosting**: Firebase Hosting
- **Charts**: FL Chart
- **State Management**: Flutter Bloc
- **Routing**: Go Router

## 📁 هيكل المشروع

```
lib/
├── config/
│   └── firebase_config.dart      # إعدادات Firebase
├── models/
│   ├── user_model.dart           # نموذج المستخدم
│   ├── order_model.dart          # نموذج الطلب
│   └── driver_model.dart         # نموذج السائق
├── services/
│   └── database_service.dart     # خدمات قاعدة البيانات
├── utils/
│   └── sample_data.dart          # البيانات التجريبية
└── main.dart                     # الملف الرئيسي
```

## 🔧 إعدادات الإنتاج

### Firebase Configuration
- **Project ID**: dndn-86c02
- **Site ID**: dandn-admin-dashboard
- **Custom Domain**: admin.dandan.sa

### DNS Settings
```
Type: A
Name: admin
Value: 151.101.1.195
TTL: 300

Type: A
Name: admin
Value: 151.101.65.195
TTL: 300
```

## 🚀 النشر

### النشر التلقائي:
```bash
./deploy_production.sh
```

### النشر اليدوي:
```bash
flutter build web --release
firebase deploy --only hosting
```

## 🔄 التحديثات

### إضافة بيانات تجريبية:
1. افتح التطبيق
2. اضغط على "إضافة بيانات تجريبية"
3. انتظر رسالة النجاح

### إعادة النشر:
```bash
flutter build web --release
firebase deploy --only hosting
```

## 📊 المراقبة

### Firebase Console:
- **المشروع**: https://console.firebase.google.com/project/dndn-86c02
- **Hosting**: https://console.firebase.google.com/project/dndn-86c02/hosting
- **Firestore**: https://console.firebase.google.com/project/dndn-86c02/firestore

### Analytics:
- متاح في Firebase Console
- تتبع المستخدمين والجلسات
- تقارير الأداء

## 🔒 الأمان

### Firebase Security Rules:
- حماية قاعدة البيانات
- صلاحيات المستخدمين
- قواعد الوصول

### HTTPS:
- شهادة SSL تلقائية
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
1. **الدومين لا يعمل**: تحقق من إعدادات DNS
2. **SSL لا يعمل**: انتظر 5-10 دقائق
3. **البيانات لا تظهر**: اضغط على "إضافة بيانات تجريبية"

### جهات الاتصال:
- Firebase Support: https://firebase.google.com/support
- Flutter Web: https://flutter.dev/web

## 📈 الأداء

### سرعة التحميل:
- ⚡ تحميل سريع (< 3 ثوان)
- 🚀 CDN عالمي
- 📦 تحسين الملفات

### الاستقرار:
- 🔄 Uptime 99.9%
- 🛡️ نسخ احتياطية تلقائية
- 🔧 صيانة تلقائية

---

**تم النشر بنجاح! 🎉**

**الرابط المؤقت**: https://dandn-admin-dashboard.web.app
**الرابط المخصص**: https://admin.dandan.sa (بعد إعداد DNS)
