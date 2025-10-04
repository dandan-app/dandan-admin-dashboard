import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';

class AppSettingsService {
  static final FirebaseFirestore _db = FirebaseConfig.firestore;

  // ========== إدارة إعدادات التطبيق ==========
  
  // الحصول على جميع الإعدادات
  static Stream<Map<String, dynamic>> getAppSettings() {
    return _db.collection('app_settings')
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> settings = {};
      for (var doc in snapshot.docs) {
        settings[doc.id] = doc.data();
      }
      return settings;
    });
  }

  // الحصول على إعداد محدد
  static Future<Map<String, dynamic>?> getSetting(String settingId) async {
    try {
      final doc = await _db.collection('app_settings').doc(settingId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('خطأ في الحصول على الإعداد: $e');
      return null;
    }
  }

  // تحديث إعداد
  static Future<bool> updateSetting(String settingId, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = FieldValue.serverTimestamp();
      await _db.collection('app_settings').doc(settingId).set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('خطأ في تحديث الإعداد: $e');
      return false;
    }
  }

  // ========== إعدادات عامة ==========
  
  // تحديث وضع الصيانة
  static Future<bool> setMaintenanceMode(bool enabled, String? message) async {
    return await updateSetting('general', {
      'maintenance_mode': enabled,
      'maintenance_message': message ?? 'النظام تحت الصيانة، يرجى المحاولة لاحقاً',
    });
  }

  // تحديث معلومات التطبيق
  static Future<bool> updateAppInfo({
    String? appName,
    String? appVersion,
    String? minSupportedVersion,
    String? supportPhone,
    String? supportEmail,
  }) async {
    Map<String, dynamic> data = {};
    if (appName != null) data['app_name'] = appName;
    if (appVersion != null) data['app_version'] = appVersion;
    if (minSupportedVersion != null) data['min_supported_version'] = minSupportedVersion;
    if (supportPhone != null) data['support_phone'] = supportPhone;
    if (supportEmail != null) data['support_email'] = supportEmail;
    
    if (data.isEmpty) return false;
    
    return await updateSetting('general', data);
  }

  // ========== إعدادات الأسعار ==========
  
  // تحديث الأسعار
  static Future<bool> updatePricing({
    double? basePrice,
    double? pricePerKm,
    double? pricePerKg,
    double? minimumOrder,
    double? maximumOrder,
    String? currency,
  }) async {
    Map<String, dynamic> data = {};
    if (basePrice != null) data['base_price'] = basePrice;
    if (pricePerKm != null) data['price_per_km'] = pricePerKm;
    if (pricePerKg != null) data['price_per_kg'] = pricePerKg;
    if (minimumOrder != null) data['minimum_order'] = minimumOrder;
    if (maximumOrder != null) data['maximum_order'] = maximumOrder;
    if (currency != null) data['currency'] = currency;
    
    if (data.isEmpty) return false;
    
    return await updateSetting('pricing', data);
  }

  // ========== إعدادات الميزات ==========
  
  // تحديث الميزات
  static Future<bool> updateFeatures({
    bool? chatEnabled,
    bool? ratingEnabled,
    bool? trackingEnabled,
    bool? walletEnabled,
    bool? scheduledOrders,
    bool? multiStopOrders,
  }) async {
    Map<String, dynamic> data = {};
    if (chatEnabled != null) data['chat_enabled'] = chatEnabled;
    if (ratingEnabled != null) data['rating_enabled'] = ratingEnabled;
    if (trackingEnabled != null) data['tracking_enabled'] = trackingEnabled;
    if (walletEnabled != null) data['wallet_enabled'] = walletEnabled;
    if (scheduledOrders != null) data['scheduled_orders'] = scheduledOrders;
    if (multiStopOrders != null) data['multi_stop_orders'] = multiStopOrders;
    
    if (data.isEmpty) return false;
    
    return await updateSetting('features', data);
  }

  // ========== إنشاء الإعدادات الافتراضية ==========
  
  // إنشاء جميع الإعدادات الافتراضية
  static Future<bool> initializeDefaultSettings() async {
    try {
      // الإعدادات العامة
      await updateSetting('general', {
        'app_name': 'دندن للنقل',
        'app_version': '1.0.0',
        'min_supported_version': '1.0.0',
        'maintenance_mode': false,
        'maintenance_message': 'النظام تحت الصيانة، يرجى المحاولة لاحقاً',
        'support_phone': '+966500000000',
        'support_email': 'support@dandn.sa',
      });

      // إعدادات الأسعار
      await updateSetting('pricing', {
        'base_price': 15.0,
        'price_per_km': 2.5,
        'price_per_kg': 1.0,
        'minimum_order': 20.0,
        'maximum_order': 500.0,
        'currency': 'SAR',
      });

      // إعدادات الميزات
      await updateSetting('features', {
        'chat_enabled': true,
        'rating_enabled': true,
        'tracking_enabled': true,
        'wallet_enabled': true,
        'scheduled_orders': true,
        'multi_stop_orders': false,
      });

      return true;
    } catch (e) {
      print('خطأ في إنشاء الإعدادات الافتراضية: $e');
      return false;
    }
  }
}
