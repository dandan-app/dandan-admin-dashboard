#!/bin/bash

# سكريبت نشر نظام دندن الإداري للإنتاج
echo "🚀 بدء عملية النشر للإنتاج..."

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter غير مثبت. يرجى تثبيت Flutter أولاً."
    exit 1
fi

# التحقق من وجود Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI غير مثبت. يرجى تثبيت Firebase CLI أولاً."
    echo "تشغيل: npm install -g firebase-tools"
    exit 1
fi

# تنظيف المشروع
echo "🧹 تنظيف المشروع..."
flutter clean

# بناء المشروع للإنتاج
echo "🔨 بناء المشروع للإنتاج..."
flutter build web --release

if [ $? -eq 0 ]; then
    echo "✅ تم بناء المشروع بنجاح"
else
    echo "❌ فشل في بناء المشروع"
    exit 1
fi

# التحقق من تسجيل الدخول إلى Firebase
echo "🔐 التحقق من تسجيل الدخول إلى Firebase..."
firebase projects:list > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ لم يتم تسجيل الدخول إلى Firebase. يرجى تسجيل الدخول أولاً:"
    echo "firebase login"
    exit 1
fi

# نشر المشروع
echo "🌐 نشر المشروع على Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo "🎉 تم النشر بنجاح!"
    echo "🔗 الرابط المؤقت: https://dandn-admin-dashboard.web.app"
    echo "🔗 الرابط المخصص: https://admin.dandan.sa"
    echo ""
    echo "📋 خطوات ربط الدومين المخصص:"
    echo "1. اذهب إلى Firebase Console: https://console.firebase.google.com"
    echo "2. اختر مشروع dndn-86c02"
    echo "3. اذهب إلى Hosting > Custom domains"
    echo "4. أضف admin.dandan.sa"
    echo "5. اتبع التعليمات لإعداد DNS"
else
    echo "❌ فشل في النشر"
    exit 1
fi
