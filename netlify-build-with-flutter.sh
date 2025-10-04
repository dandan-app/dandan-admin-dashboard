#!/bin/bash

# سكريبت بناء Flutter Web لـ Netlify مع تثبيت Flutter
# يثبت Flutter تلقائياً ويبني المشروع

set -e

echo "🚀 بدء بناء Flutter Web على Netlify مع تثبيت Flutter..."

# عرض معلومات البيئة
echo "🔍 معلومات البيئة:"
echo "المسار الحالي: $(pwd)"
echo "NETLIFY_BUILD_BASE: ${NETLIFY_BUILD_BASE:-غير محدد}"
echo "HOME: $HOME"
echo "OS: $(uname -a)"

# الانتقال إلى المجلد الصحيح
if [ -n "$NETLIFY_BUILD_BASE" ]; then
    echo "📂 الانتقال إلى: $NETLIFY_BUILD_BASE"
    cd "$NETLIFY_BUILD_BASE"
fi

# عرض محتويات المجلد
echo "📋 محتويات المجلد:"
ls -la

# البحث عن pubspec.yaml
if [ ! -f "pubspec.yaml" ]; then
    echo "🔍 البحث عن pubspec.yaml..."
    PUBSPEC_PATH=$(find . -maxdepth 2 -name "pubspec.yaml" -type f | head -1)
    if [ -n "$PUBSPEC_PATH" ]; then
        echo "✅ تم العثور على pubspec.yaml في: $PUBSPEC_PATH"
        cd "$(dirname "$PUBSPEC_PATH")"
        echo "📂 الانتقال إلى مجلد المشروع: $(pwd)"
    else
        echo "❌ لم يتم العثور على pubspec.yaml!"
        exit 1
    fi
fi

# تثبيت Flutter
echo "📦 التحقق من Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "📦 Flutter غير مثبت، جاري التثبيت..."
    
    # إنشاء مجلد Flutter
    FLUTTER_DIR="$HOME/flutter"
    mkdir -p "$FLUTTER_DIR"
    
    echo "⬇️ تحميل Flutter..."
    cd "$FLUTTER_DIR"
    
    # تحميل Flutter للـ Linux
    if command -v wget &> /dev/null; then
        wget -O flutter_linux.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
    elif command -v curl &> /dev/null; then
        curl -L -o flutter_linux.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
    else
        echo "❌ لا يمكن تحميل Flutter: wget و curl غير متاحين!"
        exit 1
    fi
    
    # استخراج Flutter
    echo "📂 استخراج Flutter..."
    tar xf flutter_linux.tar.xz
    
    # إضافة Flutter إلى PATH
    export PATH="$PATH:$FLUTTER_DIR/flutter/bin"
    
    echo "✅ تم تثبيت Flutter بنجاح!"
else
    echo "✅ Flutter موجود بالفعل"
fi

# العودة إلى مجلد المشروع
if [ -n "$NETLIFY_BUILD_BASE" ]; then
    cd "$NETLIFY_BUILD_BASE"
    if [ -n "$PUBSPEC_PATH" ]; then
        PROJECT_DIR=$(dirname "$PUBSPEC_PATH")
        cd "$PROJECT_DIR"
    fi
fi

# التحقق من Flutter مرة أخرى
echo "🔧 التحقق من Flutter:"
flutter --version

# تنظيف وبناء
echo "🧹 تنظيف المشروع..."
flutter clean

echo "📦 تثبيت التبعيات..."
flutter pub get

echo "🔧 تفعيل Web..."
flutter config --enable-web

echo "🔨 بناء المشروع..."
flutter build web --release

# التحقق من النجاح
if [ -d "build/web" ]; then
    echo "✅ تم البناء بنجاح!"
    echo "📁 الملفات في: build/web"
    echo "📊 حجم الملفات:"
    du -sh build/web/*
    echo "🎉 جاهز للنشر!"
else
    echo "❌ فشل البناء!"
    exit 1
fi
