# دليل نشر لوحة التحكم على Supabase

## 🎯 الهدف
نشر لوحة تحكم دندن الإدارية على Supabase للحصول على رابط دائم

## 📋 المتطلبات
1. مشروع Supabase: `dandan-admin`
2. Node.js مثبت
3. Flutter CLI مثبت
4. حساب Supabase

## 🚀 خيارات النشر

### الخيار 1: Netlify (مستحسن)

#### أ) إعداد Netlify:
1. اذهب إلى [Netlify](https://netlify.com)
2. سجل حساب جديد أو سجل الدخول
3. اربط حساب GitHub الخاص بك

#### ب) بناء المشروع:
```bash
# بناء المشروع للإنتاج
flutter build web --release

# نسخ الملفات المبنية
cp -r build/web/* netlify_site/
```

#### ج) إعداد Netlify:
1. اذهب إلى Netlify Dashboard
2. اضغط "New site from Git"
3. اختر مستودع GitHub
4. إعدادات البناء:
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`

#### د) النتيجة:
```
https://dandan-admin-dashboard.netlify.app
```

### الخيار 2: Vercel

#### أ) إعداد Vercel:
1. اذهب إلى [Vercel](https://vercel.com)
2. سجل حساب جديد
3. اربط حساب GitHub

#### ب) إعداد المشروع:
1. اضغط "New Project"
2. اختر مستودع GitHub
3. إعدادات البناء:
   - Framework Preset: `Other`
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`

#### ج) النتيجة:
```
https://dandan-admin-dashboard.vercel.app
```

### الخيار 3: GitHub Pages

#### أ) إعداد GitHub Pages:
1. اذهب إلى GitHub repository
2. Settings > Pages
3. Source: GitHub Actions

#### ب) إنشاء workflow:
إنشاء ملف `.github/workflows/deploy.yml`:

```yaml
name: Deploy Flutter Web to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build web
      run: flutter build web --release
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: build/web
```

#### ج) النتيجة:
```
https://username.github.io/dandan-admin-dashboard
```

### الخيار 4: Supabase Edge Functions (متقدم)

#### أ) إعداد Supabase CLI:
```bash
npm install -g supabase
```

#### ب) تسجيل الدخول:
```bash
supabase login
```

#### ج) ربط المشروع:
```bash
supabase link --project-ref lhhlysnqflbsfdjdgavu
```

#### د) إنشاء Edge Function:
```bash
supabase functions new serve-flutter-app
```

#### هـ) كود الـ Function:
```typescript
// supabase/functions/serve-flutter-app/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const url = new URL(req.url)
  
  // تقديم ملفات Flutter Web
  if (url.pathname === "/") {
    const html = await Deno.readTextFile("./index.html")
    return new Response(html, {
      headers: { "Content-Type": "text/html" },
    })
  }
  
  // تقديم ملفات أخرى
  try {
    const file = await Deno.readFile(`.${url.pathname}`)
    return new Response(file)
  } catch {
    return new Response("Not Found", { status: 404 })
  }
})
```

## 🎯 التوصية: Netlify

### المميزات:
- ✅ سهل الإعداد
- ✅ رابط دائم مجاني
- ✅ CDN عالمي
- ✅ HTTPS تلقائي
- ✅ تحديثات تلقائية من GitHub
- ✅ إحصائيات مفصلة

### الخطوات السريعة:
1. اذهب إلى [Netlify](https://netlify.com)
2. اضغط "New site from Git"
3. اختر GitHub repository
4. إعدادات البناء:
   ```
   Build command: flutter build web --release
   Publish directory: build/web
   ```
5. اضغط "Deploy site"

### النتيجة:
```
https://dandan-admin-dashboard.netlify.app
```

## 🔧 إعدادات إضافية

### Custom Domain (اختياري):
1. في Netlify Dashboard
2. Domain settings
3. Add custom domain
4. إضافة: `admin.dandan.sa`

### Environment Variables:
```bash
# في Netlify Dashboard > Site settings > Environment variables
SUPABASE_URL=https://lhhlysnqflbsfdjdgavu.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 📊 مراقبة الأداء

### Netlify Analytics:
- متاح في Netlify Dashboard
- إحصائيات الزوار
- سرعة التحميل
- الأخطاء

### Supabase Dashboard:
- مراقبة قاعدة البيانات
- إحصائيات الاستعلامات
- استخدام التخزين

## 🚨 استكشاف الأخطاء

### مشكلة: البناء فاشل
```bash
# تنظيف المشروع
flutter clean
flutter pub get
flutter build web --release
```

### مشكلة: التطبيق لا يعمل
- تحقق من إعدادات Supabase
- تأكد من صحة Environment Variables
- راجع console للأخطاء

### مشكلة: بطء التحميل
- تحقق من حجم الملفات
- استخدم Flutter web optimization
- فعّل caching في Netlify

## 📱 اختبار النشر

### اختبار محلي:
```bash
# بناء المشروع
flutter build web --release

# تشغيل خادم محلي
cd build/web
python -m http.server 8080
```

### اختبار الإنتاج:
1. افتح الرابط الجديد
2. تأكد من تحميل التطبيق
3. اختبر الوظائف الأساسية
4. تحقق من الاتصال بـ Supabase

---

**الرابط الدائم سيكون**: `https://dandan-admin-dashboard.netlify.app`

**تم النشر بنجاح! 🎉**
