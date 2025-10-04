#!/bin/bash

# سكريبت ربط الدومين المخصص admin.dandan.sa
echo "🌐 بدء عملية ربط الدومين المخصص..."

# التحقق من تسجيل الدخول إلى Firebase
echo "🔐 التحقق من تسجيل الدخول إلى Firebase..."
firebase projects:list > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ لم يتم تسجيل الدخول إلى Firebase. يرجى تسجيل الدخول أولاً:"
    echo "firebase login"
    exit 1
fi

# إضافة الدومين المخصص
echo "🔗 إضافة الدومين المخصص admin.dandan.sa..."
firebase hosting:sites:get dandn-admin-dashboard

echo ""
echo "📋 خطوات ربط الدومين المخصص:"
echo "1. اذهب إلى Firebase Console: https://console.firebase.google.com/project/dndn-86c02/hosting"
echo "2. اضغط على 'Add custom domain'"
echo "3. أدخل: admin.dandan.sa"
echo "4. اتبع التعليمات لإعداد DNS"
echo ""
echo "🔧 إعدادات DNS المطلوبة:"
echo "Type: A"
echo "Name: admin"
echo "Value: 151.101.1.195"
echo "TTL: 300"
echo ""
echo "Type: A"
echo "Name: admin" 
echo "Value: 151.101.65.195"
echo "TTL: 300"
echo ""
echo "أو استخدم CNAME:"
echo "Type: CNAME"
echo "Name: admin"
echo "Value: dandn-admin-dashboard.web.app"
echo "TTL: 300"
echo ""
echo "✅ بعد إعداد DNS، سيصبح الرابط متاحاً على:"
echo "🔗 https://admin.dandan.sa"
echo ""
echo "⏱️ قد يستغرق DNS من 5 دقائق إلى 48 ساعة للانتشار"
