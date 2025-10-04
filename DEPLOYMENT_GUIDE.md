# دليل نشر نظام دندن الإداري

## 🚀 النشر على Firebase Hosting

### المتطلبات:
1. حساب Google
2. Firebase CLI مثبت
3. مشروع Firebase جاهز

### خطوات النشر:

#### 1. تثبيت Firebase CLI:
```bash
npm install -g firebase-tools
```

#### 2. تسجيل الدخول إلى Firebase:
```bash
firebase login
```

#### 3. تهيئة المشروع:
```bash
firebase init hosting
```

#### 4. بناء المشروع:
```bash
flutter build web
```

#### 5. نشر المشروع:
```bash
firebase deploy --only hosting
```

### 🔗 الرابط الدائم:
بعد النشر، ستحصل على رابط دائم مثل:
```
https://dandn-admin-dashboard.web.app
```

### 📱 المميزات:
- ✅ رابط دائم ومستقر
- ✅ HTTPS آمن
- ✅ CDN عالمي
- ✅ تحديث تلقائي
- ✅ نسخ احتياطية

### 🔄 إعادة النشر:
عند إجراء تغييرات على الكود:
```bash
flutter build web
firebase deploy --only hosting
```

### 📊 مراقبة الأداء:
- Firebase Console: https://console.firebase.google.com
- Analytics: متاح في Firebase Console
- Crashlytics: لتتبع الأخطاء

### 🛠️ إعدادات إضافية:
- Custom Domain: يمكن ربط نطاق مخصص
- SSL Certificate: تلقائي من Firebase
- Caching: محسن للأداء

## 📞 الدعم الفني:
- Firebase Support: https://firebase.google.com/support
- Flutter Web: https://flutter.dev/web
