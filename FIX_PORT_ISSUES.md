# حل مشاكل المنافذ (Port Issues)

## 🚨 المشكلة:
```
SocketException: Failed to create server socket (OS Error: Address already in use, errno = 48)
```

## ✅ الحلول:

### الحل 1: إيقاف العمليات المستخدمة للمنافذ

```bash
# إيقاف العمليات على المنافذ 8080 و 8081
lsof -ti:8080,8081 | xargs kill -9

# أو إيقاف جميع عمليات Flutter
pkill -f "flutter run"
```

### الحل 2: استخدام منفذ مختلف

```bash
# استخدام منفذ مختلف
flutter run -d web-server --web-port 8082
# أو
flutter run -d web-server --web-port 8083
# أو
flutter run -d web-server --web-port 8084
```

### الحل 3: البحث عن المنافذ المتاحة

```bash
# البحث عن المنافذ المستخدمة
netstat -an | grep LISTEN | grep -E "808[0-9]|809[0-9]"

# البحث عن عمليات Flutter
ps aux | grep flutter
```

### الحل 4: إعادة تشغيل النظام (إذا لزم الأمر)

```bash
# إعادة تشغيل جميع العمليات
sudo reboot
```

## 🎯 الحل الموصى به:

1. **أوقف جميع عمليات Flutter:**
   ```bash
   pkill -f "flutter run"
   ```

2. **استخدم منفذ مختلف:**
   ```bash
   flutter run -d web-server --web-port 8082
   ```

3. **تحقق من نجاح التشغيل:**
   - يجب أن تظهر: `lib/main.dart is being served at http://localhost:8082`

## 📱 الوصول للتطبيق:

- **المنفذ الجديد**: http://localhost:8082
- **اختبار صفحة الموظفين**: http://localhost:8082 → إدارة الموظفين

## 🔧 نصائح إضافية:

### لتجنب مشاكل المنافذ في المستقبل:

1. **استخدم منافذ مختلفة للمشاريع المختلفة:**
   - مشروع 1: 8080
   - مشروع 2: 8081
   - مشروع 3: 8082

2. **أوقف التطبيق بشكل صحيح:**
   - اضغط `Ctrl + C` في Terminal
   - أو اضغط `q` في Flutter console

3. **تحقق من المنافذ قبل التشغيل:**
   ```bash
   lsof -i :8080
   ```

## ✅ النتيجة:

بعد تطبيق الحل:
- ✅ التطبيق يعمل على http://localhost:8082
- ✅ لا توجد أخطاء في Terminal
- ✅ صفحة إدارة الموظفين تعمل بشكل طبيعي

## 📞 إذا استمرت المشكلة:

1. **تحقق من العمليات النشطة:**
   ```bash
   ps aux | grep flutter
   ```

2. **أعد تشغيل Terminal:**
   - أغلق Terminal الحالي
   - افتح Terminal جديد

3. **استخدم منفذ عالي:**
   ```bash
   flutter run -d web-server --web-port 9000
   ```
