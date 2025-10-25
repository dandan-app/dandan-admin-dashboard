# 🚀 دليل نشر لوحة التحكم على Vercel

## نظرة عامة
هذا الدليل يوضح كيفية نشر لوحة التحكم Flutter Web على منصة Vercel للحصول على رابط ثابت ودائم.

## 📋 المتطلبات المسبقة

### 1. حساب Vercel
- إنشاء حساب مجاني على [vercel.com](https://vercel.com)
- ربط الحساب بـ GitHub

### 2. مشروع GitHub
- رفع كود المشروع إلى GitHub
- التأكد من وجود الملفات المطلوبة

## 🛠️ الملفات المطلوبة

### 1. ملف التكوين `vercel.json`
```json
{
  "version": 2,
  "buildCommand": "chmod +x vercel-build.sh && ./vercel-build.sh",
  "outputDirectory": "build/web",
  "installCommand": "echo 'Installing Flutter...'",
  "env": {
    "FLUTTER_VERSION": "3.24.0",
    "SUPABASE_URL": "https://jusyngjjjlvmvbrnqik.supabase.co",
    "SUPABASE_ANON_KEY": "your-anon-key"
  }
}
```

### 2. سكريبت البناء `vercel-build.sh`
- يقوم بتثبيت Flutter تلقائياً
- يبني المشروع للويب
- يحضر الملفات للنشر

## 🚀 خطوات النشر

### الطريقة الأولى: من خلال موقع Vercel

#### 1. تسجيل الدخول إلى Vercel
- اذهب إلى [vercel.com](https://vercel.com)
- سجل الدخول بحساب GitHub

#### 2. إنشاء مشروع جديد
- اضغط على "New Project"
- اختر مستودع GitHub الخاص بالمشروع
- اختر مجلد المشروع إذا كان في مجلد فرعي

#### 3. تكوين المشروع
```
Project Name: dandan-admin-dashboard
Framework Preset: Other
Root Directory: ./
Build Command: chmod +x vercel-build.sh && ./vercel-build.sh
Output Directory: build/web
Install Command: echo 'Installing Flutter...'
```

#### 4. متغيرات البيئة
أضف المتغيرات التالية في قسم Environment Variables:
```
FLUTTER_VERSION = 3.24.0
SUPABASE_URL = https://jusyngjjjlvmvbrnqik.supabase.co
SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### 5. النشر
- اضغط على "Deploy"
- انتظر اكتمال عملية البناء (5-10 دقائق)

### الطريقة الثانية: من خلال Vercel CLI

#### 1. تثبيت Vercel CLI
```bash
npm i -g vercel
```

#### 2. تسجيل الدخول
```bash
vercel login
```

#### 3. النشر
```bash
cd path/to/your/project
vercel --prod
```

## 🔗 الحصول على الرابط الثابت

### 1. الرابط التلقائي
بعد النشر الناجح، ستحصل على رابط مثل:
```
https://dandan-admin-dashboard.vercel.app
```

### 2. رابط مخصص (اختياري)
يمكنك ربط نطاق مخصص:
- اذهب إلى إعدادات المشروع في Vercel
- اختر "Domains"
- أضف النطاق المخصص

## ⚙️ التكوين المتقدم

### 1. متغيرات البيئة
```javascript
// في ملف lib/config/environment_config.dart
class EnvironmentConfig {
  static String get supabaseUrl => 
    const String.fromEnvironment('SUPABASE_URL') ?? 
    'https://jusyngjjjlvmvbrnqik.supabase.co';
    
  static String get supabaseAnonKey => 
    const String.fromEnvironment('SUPABASE_ANON_KEY') ?? 
    'your-default-key';
}
```

### 2. إعدادات الأمان
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        }
      ]
    }
  ]
}
```

## 🔄 النشر التلقائي

### 1. ربط GitHub
- كل push إلى branch main سيؤدي إلى نشر تلقائي
- يمكن تخصيص الـ branch في إعدادات Vercel

### 2. معاينة التغييرات
- كل Pull Request سيحصل على رابط معاينة
- يمكن اختبار التغييرات قبل الدمج

## 🐛 حل المشاكل الشائعة

### 1. خطأ "Flutter command not found"
**الحل:** التأكد من وجود `vercel-build.sh` وأنه قابل للتنفيذ
```bash
chmod +x vercel-build.sh
```

### 2. خطأ "pubspec.yaml not found"
**الحل:** التأكد من أن `Root Directory` يشير إلى المجلد الصحيح

### 3. خطأ في الاتصال بـ Supabase
**الحل:** التأكد من صحة متغيرات البيئة:
```
SUPABASE_URL = https://jusyngjjjlvmvbrnqik.supabase.co
SUPABASE_ANON_KEY = (المفتاح الصحيح)
```

### 4. خطأ في البناء
**الحل:** فحص logs البناء في Vercel Dashboard

## 📊 مراقبة الأداء

### 1. Analytics
- Vercel يوفر إحصائيات مجانية
- يمكن مراقبة الزيارات والأداء

### 2. Logs
- يمكن عرض logs البناء والتشغيل
- مفيد لحل المشاكل

## 🎯 النتيجة المتوقعة

بعد اتباع هذا الدليل، ستحصل على:

✅ **رابط ثابت ودائم** للوحة التحكم  
✅ **نشر تلقائي** عند كل تحديث  
✅ **أداء عالي** مع CDN عالمي  
✅ **SSL مجاني** وأمان متقدم  
✅ **معاينة التغييرات** قبل النشر  

## 📞 الدعم

في حالة مواجهة أي مشاكل:
1. فحص logs البناء في Vercel
2. التأكد من صحة ملف `vercel.json`
3. التأكد من صحة متغيرات البيئة
4. التواصل مع فريق الدعم

---

**ملاحظة:** هذا الدليل محدث لإصدار Flutter 3.24.0 ومشروع dndnapp Supabase.
