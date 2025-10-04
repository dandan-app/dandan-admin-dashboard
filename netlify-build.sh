#!/bin/bash

# سكريبت بناء Flutter Web لـ Netlify
# يثبت Flutter تلقائياً ويبني المشروع

set -e  # توقف عند أي خطأ

echo "🚀 بدء بناء Flutter Web على Netlify..."

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    echo "📦 Flutter غير مثبت، جاري التثبيت..."
    
    # إنشاء مجلد Flutter
    FLUTTER_DIR="$HOME/flutter"
    mkdir -p "$FLUTTER_DIR"
    cd "$FLUTTER_DIR"
    
    # تحميل Flutter
    echo "⬇️ تحميل Flutter..."
    wget -O flutter_linux.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
    
    # استخراج Flutter
    echo "📂 استخراج Flutter..."
    tar xf flutter_linux.tar.xz
    
    # إضافة Flutter إلى PATH
    export PATH="$PATH:$FLUTTER_DIR/flutter/bin"
    
    # إضافة PATH للجلسة الحالية
    echo 'export PATH="$PATH:$HOME/flutter/flutter/bin"' >> ~/.bashrc
    
    echo "✅ تم تثبيت Flutter بنجاح!"
else
    echo "✅ Flutter موجود بالفعل"
fi

# العودة إلى مجلد المشروع
cd "$NETLIFY_BUILD_BASE"

# التحقق من وجود pubspec.yaml
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ ملف pubspec.yaml غير موجود!"
    echo "تأكد من أنك في مجلد المشروع الصحيح"
    exit 1
fi

echo "🧹 تنظيف المشروع..."
flutter clean

echo "📦 تثبيت التبعيات..."
flutter pub get

echo "🔧 تفعيل Flutter Web..."
flutter config --enable-web

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
    echo "🎉 البناء مكتمل وجاهز للنشر!"
    
else
    echo "❌ فشل في بناء المشروع!"
    echo "تحقق من الأخطاء أعلاه"
    exit 1
fi
