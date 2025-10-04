#!/bin/bash

# سكريبت بناء مبسط لـ Flutter Web على Netlify
# يستخدم Flutter المثبت مسبقاً

set -e

echo "🚀 بدء بناء Flutter Web على Netlify (النسخة المبسطة)..."

# عرض معلومات البيئة
echo "🔍 معلومات البيئة:"
echo "المسار الحالي: $(pwd)"
echo "NETLIFY_BUILD_BASE: ${NETLIFY_BUILD_BASE:-غير محدد}"

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

# التحقق من Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter غير مثبت!"
    echo "يرجى تثبيت Flutter في بيئة البناء"
    exit 1
fi

echo "✅ Flutter متاح: $(flutter --version | head -1)"

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
