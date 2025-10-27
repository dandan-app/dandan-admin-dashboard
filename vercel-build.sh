#!/bin/bash

# سكريبت بناء Flutter Web لـ Vercel
echo "🚀 بدء بناء مشروع دندن الإداري..."

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter غير مثبت. يرجى تثبيت Flutter أولاً."
    exit 1
fi

# التحقق من إصدار Flutter
echo "📱 إصدار Flutter:"
flutter --version

# تنظيف المشروع
echo "🧹 تنظيف المشروع..."
flutter clean

# الحصول على التبعيات
echo "📦 الحصول على التبعيات..."
flutter pub get

# بناء المشروع للإنتاج
echo "🔨 بناء المشروع للإنتاج..."
flutter build web --release --web-renderer html

# التحقق من نجاح البناء
if [ -d "build/web" ]; then
    echo "✅ تم بناء المشروع بنجاح!"
    echo "📁 مجلد البناء: build/web"
    ls -la build/web/
else
    echo "❌ فشل في بناء المشروع!"
    exit 1
fi

echo "🎉 انتهى البناء بنجاح!"