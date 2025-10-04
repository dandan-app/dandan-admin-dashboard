# دليل ربط الدومين المخصص admin.dandan.sa

## 🎯 الهدف
ربط لوحة تحكم دندن الإدارية بالدومين الثابت `admin.dandan.sa`

## 📋 المتطلبات
1. مشروع Firebase: `dndn-86c02`
2. دومين: `admin.dandan.sa`
3. Firebase CLI مثبت
4. صلاحيات إدارة الدومين

## 🚀 خطوات النشر

### 1. نشر المشروع على Firebase Hosting
```bash
./deploy_production.sh
```

### 2. ربط الدومين المخصص

#### أ) من Firebase Console:
1. اذهب إلى: https://console.firebase.google.com
2. اختر مشروع `dndn-86c02`
3. اذهب إلى `Hosting` في القائمة الجانبية
4. اضغط على `Add custom domain`
5. أدخل `admin.dandan.sa`
6. اتبع التعليمات لإعداد DNS

#### ب) من سطر الأوامر:
```bash
firebase hosting:sites:create dandn-admin-dashboard
firebase target:apply hosting dandn-admin-dashboard dandn-admin-dashboard
firebase deploy --only hosting
```

## 🔧 إعداد DNS

### إعدادات DNS المطلوبة:
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

### أو استخدام CNAME:
```
Type: CNAME
Name: admin
Value: dandn-admin-dashboard.web.app
TTL: 300
```

## 🔒 إعداد SSL
- SSL Certificate سيتم إنشاؤه تلقائياً من Firebase
- قد يستغرق من 5-10 دقائق للتفعيل
- سيتم إعادة التوجيه من HTTP إلى HTTPS تلقائياً

## ✅ التحقق من النشر
1. **الرابط المؤقت**: https://dandn-admin-dashboard.web.app
2. **الرابط المخصص**: https://admin.dandan.sa (بعد إعداد DNS)

## 🛠️ استكشاف الأخطاء

### مشكلة: الدومين لا يعمل
- تحقق من إعدادات DNS
- انتظر 24-48 ساعة لانتشار DNS
- استخدم `nslookup admin.dandan.sa` للتحقق

### مشكلة: SSL لا يعمل
- انتظر 5-10 دقائق
- تحقق من Firebase Console > Hosting > Custom domains

### مشكلة: التطبيق لا يظهر
- تأكد من نشر المشروع بنجاح
- تحقق من `firebase.json` إعدادات

## 📊 مراقبة الأداء
- Firebase Console: https://console.firebase.google.com/project/dndn-86c02
- Analytics: متاح في Firebase Console
- Performance: مراقبة سرعة التحميل

## 🔄 إعادة النشر
عند إجراء تغييرات:
```bash
flutter build web --release
firebase deploy --only hosting
```

## 📞 الدعم
- Firebase Support: https://firebase.google.com/support
- Flutter Web: https://flutter.dev/web
- DNS Issues: راجع مزود الدومين

---
**ملاحظة**: تأكد من أن الدومين `dandan.sa` مسجل ومتاح قبل البدء
