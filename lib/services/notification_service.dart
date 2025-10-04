import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';

class NotificationService {
  static final FirebaseFirestore _db = FirebaseConfig.firestore;

  // ========== إدارة الإشعارات ==========
  
  // الحصول على جميع الإشعارات
  static Stream<List<Map<String, dynamic>>> getNotifications() {
    return _db.collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // الحصول على الإشعارات غير المرسلة
  static Stream<List<Map<String, dynamic>>> getPendingNotifications() {
    return _db.collection('notifications')
        .where('sent', isEqualTo: false)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // إرسال إشعار جديد
  static Future<bool> sendNotification({
    required String title,
    required String body,
    required String targetType, // 'all', 'customers', 'drivers', 'user'
    List<String>? targetIds,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      await _db.collection('notifications').add({
        'title': title,
        'body': body,
        'type': data?['type'] ?? 'general',
        'target_type': targetType,
        'target_ids': targetIds ?? [],
        'data': data ?? {},
        'image_url': imageUrl,
        'sent': false,
        'created_at': FieldValue.serverTimestamp(),
        'scheduled_at': null,
      });
      return true;
    } catch (e) {
      print('خطأ في إرسال الإشعار: $e');
      return false;
    }
  }

  // إرسال إشعار مجدول
  static Future<bool> scheduleNotification({
    required String title,
    required String body,
    required String targetType,
    required DateTime scheduledAt,
    List<String>? targetIds,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      await _db.collection('notifications').add({
        'title': title,
        'body': body,
        'type': data?['type'] ?? 'general',
        'target_type': targetType,
        'target_ids': targetIds ?? [],
        'data': data ?? {},
        'image_url': imageUrl,
        'sent': false,
        'created_at': FieldValue.serverTimestamp(),
        'scheduled_at': Timestamp.fromDate(scheduledAt),
      });
      return true;
    } catch (e) {
      print('خطأ في جدولة الإشعار: $e');
      return false;
    }
  }

  // تحديث حالة الإشعار إلى مرسل
  static Future<bool> markAsSent(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).update({
        'sent': true,
        'sent_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('خطأ في تحديث حالة الإشعار: $e');
      return false;
    }
  }

  // حذف إشعار
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).delete();
      return true;
    } catch (e) {
      print('خطأ في حذف الإشعار: $e');
      return false;
    }
  }

  // ========== إشعارات خاصة بالطلبات ==========
  
  // إشعار طلب جديد للسائقين
  static Future<bool> notifyNewOrder({
    required String orderId,
    required String customerId,
    required String pickupAddress,
    required String deliveryAddress,
    double? totalPrice,
  }) async {
    return await sendNotification(
      title: 'طلب جديد متاح',
      body: 'طلب نقل من $pickupAddress إلى $deliveryAddress',
      targetType: 'drivers',
      data: {
        'type': 'new_order',
        'order_id': orderId,
        'customer_id': customerId,
        'action': 'view_order',
        'total_price': totalPrice,
      },
    );
  }

  // إشعار تغيير حالة الطلب للعميل
  static Future<bool> notifyOrderStatusChange({
    required String orderId,
    required String customerId,
    required String status,
    String? driverName,
  }) async {
    String title = '';
    String body = '';

    switch (status) {
      case 'accepted':
        title = 'تم قبول طلبك';
        body = driverName != null 
            ? 'تم قبول طلبك من قبل السائق $driverName'
            : 'تم قبول طلبك من قبل أحد السائقين';
        break;
      case 'in_progress':
        title = 'جاري تنفيذ طلبك';
        body = 'السائق في الطريق لاستلام الطلب';
        break;
      case 'delivered':
        title = 'تم تسليم طلبك';
        body = 'تم تسليم طلبك بنجاح';
        break;
      case 'cancelled':
        title = 'تم إلغاء طلبك';
        body = 'تم إلغاء طلبك، يمكنك إنشاء طلب جديد';
        break;
      default:
        title = 'تحديث على طلبك';
        body = 'تم تحديث حالة طلبك';
    }

    return await sendNotification(
      title: title,
      body: body,
      targetType: 'user',
      targetIds: [customerId],
      data: {
        'type': 'order_update',
        'order_id': orderId,
        'status': status,
        'action': 'view_order',
      },
    );
  }

  // ========== إشعارات النظام ==========
  
  // إشعار وضع الصيانة
  static Future<bool> notifyMaintenanceMode({
    required bool enabled,
    String? message,
    DateTime? scheduledAt,
  }) async {
    String title = enabled ? 'وضع الصيانة' : 'انتهاء الصيانة';
    String body = enabled 
        ? (message ?? 'النظام تحت الصيانة حالياً')
        : 'تم انتهاء أعمال الصيانة، يمكنك استخدام التطبيق الآن';

    if (scheduledAt != null) {
      return await scheduleNotification(
        title: title,
        body: body,
        targetType: 'all',
        scheduledAt: scheduledAt,
        data: {
          'type': 'maintenance',
          'maintenance_mode': enabled,
          'action': 'refresh_app',
        },
      );
    } else {
      return await sendNotification(
        title: title,
        body: body,
        targetType: 'all',
        data: {
          'type': 'maintenance',
          'maintenance_mode': enabled,
          'action': 'refresh_app',
        },
      );
    }
  }

  // إشعار تحديث التطبيق
  static Future<bool> notifyAppUpdate({
    required String version,
    required bool forceUpdate,
    String? updateMessage,
  }) async {
    String title = forceUpdate ? 'تحديث مطلوب' : 'تحديث متاح';
    String body = updateMessage ?? 'إصدار جديد متاح من التطبيق ($version)';

    return await sendNotification(
      title: title,
      body: body,
      targetType: 'all',
      data: {
        'type': 'app_update',
        'version': version,
        'force_update': forceUpdate,
        'action': 'update_app',
      },
    );
  }

  // إشعار عام للجميع
  static Future<bool> sendGeneralAnnouncement({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    return await sendNotification(
      title: title,
      body: body,
      targetType: 'all',
      imageUrl: imageUrl,
      data: {
        'type': 'announcement',
        'action': 'view_announcement',
        ...?additionalData,
      },
    );
  }

  // ========== إحصائيات الإشعارات ==========
  
  // عدد الإشعارات المرسلة اليوم
  static Future<int> getTodayNotificationsCount() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final snapshot = await _db.collection('notifications')
          .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('sent', isEqualTo: true)
          .get();
          
      return snapshot.docs.length;
    } catch (e) {
      print('خطأ في حساب إشعارات اليوم: $e');
      return 0;
    }
  }

  // عدد الإشعارات المعلقة
  static Future<int> getPendingNotificationsCount() async {
    try {
      final snapshot = await _db.collection('notifications')
          .where('sent', isEqualTo: false)
          .get();
          
      return snapshot.docs.length;
    } catch (e) {
      print('خطأ في حساب الإشعارات المعلقة: $e');
      return 0;
    }
  }
}
