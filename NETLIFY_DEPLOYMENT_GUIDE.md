# 🚀 دليل نشر Flutter Web على Netlify

## 📋 المتطلبات
- حساب GitHub
- حساب Netlify
- مشروع Flutter Web جاهز

## 🛠️ الحلول المتاحة

### الحل الأول: البناء المحلي (سريع)
إذا كنت تريد نشر المشروع بسرعة:

1. **بناء المشروع محلياً:**
```bash
flutter build web --release
```

2. **رفع مجلد build/web إلى Netlify:**
   - اذهب إلى [netlify.com](https://netlify.com)
   - اضغط "New site from Git" أو "Deploy manually"
   - اسحب مجلد `build/web` إلى منطقة النشر
   - احصل على الرابط الفوري

### الحل الثاني: النشر التلقائي (مستدام)
للحصول على نشر تلقائي مع كل تحديث:

## 🔧 إعداد النشر التلقائي

### الخطوة 1: إعداد GitHub Repository
1. ادفع الكود إلى GitHub
2. تأكد من وجود الملفات التالية:
   - `netlify-build.sh`
   - `netlify.toml`
   - `.github/workflows/netlify-deploy.yml`

### الخطوة 2: إعداد Netlify
1. اذهب إلى [netlify.com](https://netlify.com)
2. اضغط "New site from Git"
3. اختر GitHub كمنصة
4. اختر repository الخاص بك
5. إعدادات البناء:
   - **Build command:** `chmod +x netlify-build.sh && ./netlify-build.sh`
   - **Publish directory:** `build/web`
   - **Branch to deploy:** `main`

### الخطوة 3: متغيرات البيئة (اختياري)
إذا كنت تستخدم Firebase أو Supabase، أضف المتغيرات في Netlify:
1. اذهب إلى Site settings > Environment variables
2. أضف المتغيرات المطلوبة

### الخطوة 4: إعداد GitHub Secrets (للنشر التلقائي)
1. اذهب إلى GitHub Repository > Settings > Secrets and variables > Actions
2. أضف الأسرار التالية:
   ```
   NETLIFY_AUTH_TOKEN: [من Netlify Account Settings]
   NETLIFY_SITE_ID: [من Netlify Site Settings]
   ```

## 🎯 طرق النشر المختلفة

### 1. النشر المباشر على Netlify
```bash
# بناء المشروع
flutter build web --release

# رفع الملفات يدوياً إلى Netlify
```

### 2. النشر عبر GitHub Actions
```bash
# ادفع التغييرات إلى GitHub
git add .
git commit -m "Update app"
git push origin main

# GitHub Actions سيقوم بالبناء والنشر تلقائياً
```

### 3. النشر عبر Netlify CLI
```bash
# تثبيت Netlify CLI
npm install -g netlify-cli

# تسجيل الدخول
netlify login

# بناء المشروع
flutter build web --release

# النشر
netlify deploy --prod --dir=build/web
```

## 🔍 استكشاف الأخطاء

### خطأ: "flutter: command not found"
**الحل:** استخدم `netlify-build.sh` الذي يثبت Flutter تلقائياً

### خطأ: "Build failed"
**الحلول:**
1. تحقق من `pubspec.yaml`
2. تأكد من وجود جميع التبعيات
3. تحقق من إعدادات `netlify.toml`

### خطأ: "Web renderer issues"
**الحل:** أضف `--web-renderer html` لأمر البناء

## 📊 مراقبة النشر

### Netlify Dashboard
- **Deploys:** مراقبة عمليات النشر
- **Analytics:** إحصائيات الزوار
- **Functions:** مراقبة الوظائف
- **Forms:** مراقبة النماذج

### GitHub Actions
- **Actions tab:** مراقبة عمليات البناء
- **Logs:** تفاصيل كل خطوة
- **Artifacts:** ملفات البناء المحفوظة

## 🔄 التحديثات المستقبلية

### تحديث تلقائي
```bash
git add .
git commit -m "New features"
git push origin main
# النشر سيتم تلقائياً
```

### تحديث يدوي
```bash
flutter build web --release
netlify deploy --prod --dir=build/web
```

## 🎉 النتيجة النهائية

بعد اكتمال الإعداد، ستحصل على:
- ✅ رابط دائم مثل: `https://your-app-name.netlify.app`
- ✅ HTTPS آمن
- ✅ CDN عالمي
- ✅ تحديث تلقائي مع كل push
- ✅ إحصائيات مفصلة
- ✅ نسخ احتياطية

## 📞 الدعم

### Netlify Support
- [Documentation](https://docs.netlify.com/)
- [Community](https://community.netlify.com/)
- [Status Page](https://www.netlifystatus.com/)

### Flutter Web Support
- [Flutter Web Guide](https://flutter.dev/web)
- [Flutter Community](https://flutter.dev/community)

---

**ملاحظة:** هذا الدليل يعمل مع Flutter 3.24.0 وأحدث. تأكد من تحديث الإصدارات عند الحاجة.
