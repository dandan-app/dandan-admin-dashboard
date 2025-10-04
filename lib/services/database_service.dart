import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/driver_model.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseConfig.firestore;

  // ========== إدارة المستخدمين ==========
  
  // الحصول على جميع المستخدمين
  static Stream<List<UserModel>> getUsers() {
    return _db.collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // الحصول على مستخدم واحد
  static Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('خطأ في الحصول على المستخدم: $e');
      return null;
    }
  }

  // إضافة مستخدم جديد
  static Future<bool> addUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toMap());
      return true;
    } catch (e) {
      print('خطأ في إضافة المستخدم: $e');
      return false;
    }
  }

  // تحديث مستخدم
  static Future<bool> updateUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      print('خطأ في تحديث المستخدم: $e');
      return false;
    }
  }

  // حذف مستخدم
  static Future<bool> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      print('خطأ في حذف المستخدم: $e');
      return false;
    }
  }

  // ========== إدارة الطلبات ==========
  
  // الحصول على جميع الطلبات
  static Stream<List<OrderModel>> getOrders() {
    return _db.collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // الحصول على طلبات بحالة معينة
  static Stream<List<OrderModel>> getOrdersByStatus(OrderStatus status) {
    return _db.collection('orders')
        .where('status', isEqualTo: status.toString().split('.').last)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // الحصول على طلب واحد
  static Future<OrderModel?> getOrder(String orderId) async {
    try {
      final doc = await _db.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('خطأ في الحصول على الطلب: $e');
      return null;
    }
  }

  // إضافة طلب جديد
  static Future<bool> addOrder(OrderModel order) async {
    try {
      await _db.collection('orders').doc(order.id).set(order.toMap());
      return true;
    } catch (e) {
      print('خطأ في إضافة الطلب: $e');
      return false;
    }
  }

  // تحديث طلب
  static Future<bool> updateOrder(OrderModel order) async {
    try {
      await _db.collection('orders').doc(order.id).update(order.toMap());
      return true;
    } catch (e) {
      print('خطأ في تحديث الطلب: $e');
      return false;
    }
  }

  // حذف طلب
  static Future<bool> deleteOrder(String orderId) async {
    try {
      await _db.collection('orders').doc(orderId).delete();
      return true;
    } catch (e) {
      print('خطأ في حذف الطلب: $e');
      return false;
    }
  }

  // ========== إدارة السائقين ==========
  
  // الحصول على جميع السائقين
  static Stream<List<DriverModel>> getDrivers() {
    return _db.collection('drivers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DriverModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // الحصول على سائقين متاحين
  static Stream<List<DriverModel>> getAvailableDrivers() {
    return _db.collection('drivers')
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DriverModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // الحصول على سائق واحد
  static Future<DriverModel?> getDriver(String driverId) async {
    try {
      final doc = await _db.collection('drivers').doc(driverId).get();
      if (doc.exists) {
        return DriverModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('خطأ في الحصول على السائق: $e');
      return null;
    }
  }

  // إضافة سائق جديد
  static Future<bool> addDriver(DriverModel driver) async {
    try {
      await _db.collection('drivers').doc(driver.id).set(driver.toMap());
      return true;
    } catch (e) {
      print('خطأ في إضافة السائق: $e');
      return false;
    }
  }

  // تحديث سائق
  static Future<bool> updateDriver(DriverModel driver) async {
    try {
      await _db.collection('drivers').doc(driver.id).update(driver.toMap());
      return true;
    } catch (e) {
      print('خطأ في تحديث السائق: $e');
      return false;
    }
  }

  // حذف سائق
  static Future<bool> deleteDriver(String driverId) async {
    try {
      await _db.collection('drivers').doc(driverId).delete();
      return true;
    } catch (e) {
      print('خطأ في حذف السائق: $e');
      return false;
    }
  }

  // ========== الإحصائيات ==========
  
  // الحصول على إحصائيات الطلبات
  static Future<Map<String, int>> getOrderStats() async {
    try {
      final ordersSnapshot = await _db.collection('orders').get();
      final orders = ordersSnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();

      return {
        'total': orders.length,
        'pending': orders.where((o) => o.status == OrderStatus.pending).length,
        'confirmed': orders.where((o) => o.status == OrderStatus.confirmed).length,
        'inProgress': orders.where((o) => o.status == OrderStatus.inProgress).length,
        'completed': orders.where((o) => o.status == OrderStatus.completed).length,
        'cancelled': orders.where((o) => o.status == OrderStatus.cancelled).length,
      };
    } catch (e) {
      print('خطأ في الحصول على إحصائيات الطلبات: $e');
      return {
        'total': 0,
        'pending': 0,
        'confirmed': 0,
        'inProgress': 0,
        'completed': 0,
        'cancelled': 0,
      };
    }
  }

  // الحصول على إحصائيات المستخدمين
  static Future<Map<String, int>> getUserStats() async {
    try {
      final usersSnapshot = await _db.collection('users').get();
      final users = usersSnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();

      return {
        'total': users.length,
        'active': users.where((u) => u.isActive).length,
        'inactive': users.where((u) => !u.isActive).length,
      };
    } catch (e) {
      print('خطأ في الحصول على إحصائيات المستخدمين: $e');
      return {
        'total': 0,
        'active': 0,
        'inactive': 0,
      };
    }
  }

  // الحصول على إحصائيات السائقين
  static Future<Map<String, int>> getDriverStats() async {
    try {
      final driversSnapshot = await _db.collection('drivers').get();
      final drivers = driversSnapshot.docs
          .map((doc) => DriverModel.fromMap(doc.data(), doc.id))
          .toList();

      return {
        'total': drivers.length,
        'available': drivers.where((d) => d.status == DriverStatus.available).length,
        'busy': drivers.where((d) => d.status == DriverStatus.busy).length,
        'offline': drivers.where((d) => d.status == DriverStatus.offline).length,
        'suspended': drivers.where((d) => d.status == DriverStatus.suspended).length,
      };
    } catch (e) {
      print('خطأ في الحصول على إحصائيات السائقين: $e');
      return {
        'total': 0,
        'available': 0,
        'busy': 0,
        'offline': 0,
        'suspended': 0,
      };
    }
  }
}
