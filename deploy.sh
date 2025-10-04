#!/bin/bash

# سكريبت نشر لوحة تحكم دندن الإدارية
# يعمل مع Netlify, Vercel, GitHub Pages

echo "🚀 بدء نشر لوحة تحكم دندن الإدارية..."

# تنظيف المشروع
echo "🧹 تنظيف المشروع..."
flutter clean

# تثبيت التبعيات
echo "📦 تثبيت التبعيات..."
flutter pub get

# بناء المشروع
echo "🔨 بناء المشروع للإنتاج..."
flutter build web --release

# التحقق من نجاح البناء
if [ -d "build/web" ]; then
    echo "✅ تم بناء المشروع بنجاح!"
    echo "📁 الملفات المبنية موجودة في: build/web"
    
    # عرض حجم الملفات
    echo "📊 حجم الملفات:"
    du -sh build/web/*
    
    echo ""
    echo "🎯 خطوات النشر:"
    echo ""
    echo "1️⃣ للنشر على Netlify:"
    echo "   - اذهب إلى https://netlify.com"
    echo "   - اضغط 'New site from Git'"
    echo "   - اختر GitHub repository"
    echo "   - Build command: flutter build web --release"
    echo "   - Publish directory: build/web"
    echo ""
    echo "2️⃣ للنشر على Vercel:"
    echo "   - اذهب إلى https://vercel.com"
    echo "   - اضغط 'New Project'"
    echo "   - اختر GitHub repository"
    echo "   - Framework: Other"
    echo "   - Build command: flutter build web --release"
    echo "   - Output directory: build/web"
    echo ""
    echo "3️⃣ للنشر على GitHub Pages:"
    echo "   - ادفع الكود إلى GitHub"
    echo "   - GitHub Actions سيقوم بالنشر تلقائياً"
    echo ""
    echo "🔗 الرابط المتوقع:"
    echo "   https://dandan-admin-dashboard.netlify.app"
    echo "   أو"
    echo "   https://dandan-admin-dashboard.vercel.app"
    echo ""
    echo "🎉 جاهز للنشر!"
    
else
    echo "❌ فشل في بناء المشروع!"
    echo "تحقق من الأخطاء أعلاه"
    exit 1
fi