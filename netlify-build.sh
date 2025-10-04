#!/bin/bash

# سكريبت بناء Flutter Web لـ Netlify
# يثبت Flutter تلقائياً ويبني المشروع

set -e  # توقف عند أي خطأ

echo "🚀 بدء بناء Flutter Web على Netlify..."

# عرض معلومات البيئة
echo "🔍 معلومات البيئة:"
echo "المسار الحالي: $(pwd)"
echo "NETLIFY_BUILD_BASE: ${NETLIFY_BUILD_BASE:-غير محدد}"
echo "HOME: $HOME"
echo "PATH: $PATH"

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
if [ -n "$NETLIFY_BUILD_BASE" ]; then
    cd "$NETLIFY_BUILD_BASE"
    echo "📂 الانتقال إلى مجلد Netlify: $NETLIFY_BUILD_BASE"
else
    echo "📂 البقاء في المجلد الحالي: $(pwd)"
fi

# عرض محتويات المجلد للتشخيص
echo "📋 محتويات المجلد الحالي:"
ls -la

# التحقق من وجود pubspec.yaml
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ ملف pubspec.yaml غير موجود في المجلد الحالي!"
    echo "المسار الحالي: $(pwd)"
    echo "🔍 البحث عن pubspec.yaml في المجلدات الفرعية..."
    
    # البحث عن pubspec.yaml في المجلدات الفرعية
    PUBSPEC_PATH=$(find . -name "pubspec.yaml" -type f | head -1)
    if [ -n "$PUBSPEC_PATH" ]; then
        echo "✅ تم العثور على pubspec.yaml في: $PUBSPEC_PATH"
        PROJECT_DIR=$(dirname "$PUBSPEC_PATH")
        echo "📂 الانتقال إلى مجلد المشروع: $PROJECT_DIR"
        cd "$PROJECT_DIR"
    else
        echo "❌ لم يتم العثور على pubspec.yaml في أي مكان!"
        echo "الرجاء التأكد من أن المشروع يحتوي على ملف pubspec.yaml"
        exit 1
    fi
else
    echo "✅ تم العثور على pubspec.yaml في المجلد الحالي"
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
