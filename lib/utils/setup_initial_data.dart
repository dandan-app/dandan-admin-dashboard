import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import '../services/app_settings_service.dart';

class SetupInitialData {
  static final FirebaseFirestore _db = FirebaseConfig.firestore;

  // ========== إعداد البيانات الأساسية ==========
  
  // إعداد جميع البيانات الأساسية
  static Future<bool> setupAllInitialData() async {
    try {
      print('🚀 بدء إعداد البيانات الأساسية...');
      
      // 1. إعداد إعدادات التطبيق
      await setupAppSettings();
      print('✅ تم إعداد إعدادات التطبيق');
      
      // 2. إعداد المدن والمناطق
      await setupCitiesAndRegions();
      print('✅ تم إعداد المدن والمناطق');
      
      // 3. إعداد أنواع المركبات
      await setupVehicleTypes();
      print('✅ تم إعداد أنواع المركبات');
      
      // 4. إعداد فئات الطلبات
      await setupOrderCategories();
      print('✅ تم إعداد فئات الطلبات');
      
      // 5. إعداد قوالب الإشعارات
      await setupNotificationTemplates();
      print('✅ تم إعداد قوالب الإشعارات');
      
      print('🎉 تم إعداد جميع البيانات الأساسية بنجاح!');
      return true;
    } catch (e) {
      print('❌ خطأ في إعداد البيانات الأساسية: $e');
      return false;
    }
  }

  // ========== إعداد إعدادات التطبيق ==========
  
  static Future<void> setupAppSettings() async {
    await AppSettingsService.initializeDefaultSettings();
    
    // إعدادات إضافية
    await AppSettingsService.updateSetting('delivery_settings', {
      'max_delivery_distance': 100.0, // كم
      'delivery_time_slots': [
        {'start': '08:00', 'end': '12:00', 'label': 'صباحاً'},
        {'start': '12:00', 'end': '16:00', 'label': 'ظهراً'},
        {'start': '16:00', 'end': '20:00', 'label': 'مساءً'},
        {'start': '20:00', 'end': '23:00', 'label': 'ليلاً'},
      ],
      'express_delivery_enabled': true,
      'express_delivery_fee': 10.0,
    });

    await AppSettingsService.updateSetting('payment_settings', {
      'cash_enabled': true,
      'card_enabled': true,
      'wallet_enabled': true,
      'installment_enabled': false,
      'minimum_wallet_balance': 10.0,
    });
  }

  // ========== إعداد المدن والمناطق ==========
  
  static Future<void> setupCitiesAndRegions() async {
    final cities = [
      {
        'id': 'riyadh',
        'name': 'الرياض',
        'name_en': 'Riyadh',
        'country': 'SA',
        'active': true,
        'coordinates': {'latitude': 24.7136, 'longitude': 46.6753},
        'delivery_zones': [
          {
            'id': 'riyadh_north',
            'name': 'شمال الرياض',
            'polygon': [], // إحداثيات المنطقة
            'delivery_fee': 5.0,
          },
          {
            'id': 'riyadh_south',
            'name': 'جنوب الرياض',
            'polygon': [],
            'delivery_fee': 5.0,
          },
          {
            'id': 'riyadh_east',
            'name': 'شرق الرياض',
            'polygon': [],
            'delivery_fee': 7.0,
          },
          {
            'id': 'riyadh_west',
            'name': 'غرب الرياض',
            'polygon': [],
            'delivery_fee': 7.0,
          },
        ],
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'jeddah',
        'name': 'جدة',
        'name_en': 'Jeddah',
        'country': 'SA',
        'active': true,
        'coordinates': {'latitude': 21.3891, 'longitude': 39.8579},
        'delivery_zones': [
          {
            'id': 'jeddah_north',
            'name': 'شمال جدة',
            'polygon': [],
            'delivery_fee': 5.0,
          },
          {
            'id': 'jeddah_south',
            'name': 'جنوب جدة',
            'polygon': [],
            'delivery_fee': 5.0,
          },
        ],
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'dammam',
        'name': 'الدمام',
        'name_en': 'Dammam',
        'country': 'SA',
        'active': true,
        'coordinates': {'latitude': 26.4207, 'longitude': 50.0888},
        'delivery_zones': [
          {
            'id': 'dammam_center',
            'name': 'وسط الدمام',
            'polygon': [],
            'delivery_fee': 5.0,
          },
        ],
        'created_at': FieldValue.serverTimestamp(),
      },
    ];

    for (var city in cities) {
      await _db.collection('cities').doc(city['id'] as String).set(city);
    }
  }

  // ========== إعداد أنواع المركبات ==========
  
  static Future<void> setupVehicleTypes() async {
    final vehicleTypes = [
      {
        'id': 'motorcycle',
        'name': 'دراجة نارية',
        'name_en': 'Motorcycle',
        'icon': '🏍️',
        'max_weight': 5.0, // كيلو
        'max_dimensions': {'length': 30, 'width': 30, 'height': 30}, // سم
        'base_price_multiplier': 1.0,
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'car',
        'name': 'سيارة',
        'name_en': 'Car',
        'icon': '🚗',
        'max_weight': 50.0,
        'max_dimensions': {'length': 100, 'width': 80, 'height': 50},
        'base_price_multiplier': 1.5,
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'van',
        'name': 'فان',
        'name_en': 'Van',
        'icon': '🚐',
        'max_weight': 200.0,
        'max_dimensions': {'length': 200, 'width': 150, 'height': 150},
        'base_price_multiplier': 2.0,
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'truck',
        'name': 'شاحنة صغيرة',
        'name_en': 'Small Truck',
        'icon': '🚚',
        'max_weight': 1000.0,
        'max_dimensions': {'length': 300, 'width': 200, 'height': 200},
        'base_price_multiplier': 3.0,
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
    ];

    for (var vehicleType in vehicleTypes) {
      await _db.collection('vehicle_types').doc(vehicleType['id'] as String).set(vehicleType);
    }
  }

  // ========== إعداد فئات الطلبات ==========
  
  static Future<void> setupOrderCategories() async {
    final categories = [
      {
        'id': 'documents',
        'name': 'مستندات',
        'name_en': 'Documents',
        'icon': '📄',
        'description': 'مستندات وأوراق مهمة',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'food',
        'name': 'طعام',
        'name_en': 'Food',
        'icon': '🍕',
        'description': 'وجبات وطعام',
        'special_handling': true,
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'electronics',
        'name': 'إلكترونيات',
        'name_en': 'Electronics',
        'icon': '📱',
        'description': 'أجهزة إلكترونية',
        'fragile': true,
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'clothing',
        'name': 'ملابس',
        'name_en': 'Clothing',
        'icon': '👕',
        'description': 'ملابس وأحذية',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'gifts',
        'name': 'هدايا',
        'name_en': 'Gifts',
        'icon': '🎁',
        'description': 'هدايا ومناسبات',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'other',
        'name': 'أخرى',
        'name_en': 'Other',
        'icon': '📦',
        'description': 'فئات أخرى',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
    ];

    for (var category in categories) {
      await _db.collection('order_categories').doc(category['id'] as String).set(category);
    }
  }

  // ========== إعداد قوالب الإشعارات ==========
  
  static Future<void> setupNotificationTemplates() async {
    final templates = [
      {
        'id': 'order_created',
        'name': 'طلب جديد',
        'title': 'طلب جديد',
        'body': 'تم إنشاء طلب جديد برقم {order_id}',
        'target_type': 'admin',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_accepted',
        'name': 'قبول الطلب',
        'title': 'تم قبول طلبك',
        'body': 'تم قبول طلبك برقم {order_id} من قبل السائق {driver_name}',
        'target_type': 'customer',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_in_progress',
        'name': 'الطلب في الطريق',
        'title': 'السائق في الطريق',
        'body': 'السائق {driver_name} في الطريق لاستلام طلبك',
        'target_type': 'customer',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_delivered',
        'name': 'تم التسليم',
        'title': 'تم تسليم طلبك',
        'body': 'تم تسليم طلبك برقم {order_id} بنجاح',
        'target_type': 'customer',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'driver_new_order',
        'name': 'طلب جديد للسائق',
        'title': 'طلب جديد متاح',
        'body': 'يوجد طلب جديد في منطقتك بقيمة {total_price} ريال',
        'target_type': 'driver',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'id': 'maintenance_mode',
        'name': 'وضع الصيانة',
        'title': 'وضع الصيانة',
        'body': 'النظام تحت الصيانة، يرجى المحاولة لاحقاً',
        'target_type': 'all',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
      },
    ];

    for (var template in templates) {
      await _db.collection('notification_templates').doc(template['id'] as String).set(template);
    }
  }

  // ========== التحقق من وجود البيانات ==========
  
  static Future<bool> checkIfDataExists() async {
    try {
      // فحص إعدادات التطبيق
      final settingsSnapshot = await _db.collection('app_settings').limit(1).get();
      if (settingsSnapshot.docs.isNotEmpty) {
        return true;
      }
      
      // فحص المدن
      final citiesSnapshot = await _db.collection('cities').limit(1).get();
      if (citiesSnapshot.docs.isNotEmpty) {
        return true;
      }
      
      return false;
    } catch (e) {
      print('خطأ في فحص البيانات: $e');
      return false;
    }
  }

  // ========== إعادة تعيين البيانات ==========
  
  static Future<bool> resetAllData() async {
    try {
      print('⚠️ بدء إعادة تعيين جميع البيانات...');
      
      // قائمة Collections المراد حذفها
      final collections = [
        'app_settings',
        'cities',
        'vehicle_types',
        'order_categories',
        'notification_templates',
      ];
      
      // حذف كل collection
      for (String collection in collections) {
        final snapshot = await _db.collection(collection).get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        print('🗑️ تم حذف $collection');
      }
      
      // إعادة إنشاء البيانات
      await setupAllInitialData();
      
      print('🔄 تم إعادة تعيين جميع البيانات بنجاح!');
      return true;
    } catch (e) {
      print('❌ خطأ في إعادة تعيين البيانات: $e');
      return false;
    }
  }
}
