import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/driver_model.dart';
import '../models/employee_model.dart';

class SupabaseDatabaseService {
  static SupabaseClient get _client => SupabaseConfig.client;

  // ========== إدارة المستخدمين ==========
  
  // الحصول على جميع المستخدمين
  static Stream<List<UserModel>> getUsers() {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => UserModel.fromMap(item, item['id'])).toList());
  }

  // الحصول على مستخدم واحد
  static Future<UserModel?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromMap(response, response['id']);
    } catch (e) {
      print('خطأ في الحصول على المستخدم: $e');
      return null;
    }
  }

  // إضافة مستخدم جديد
  static Future<bool> addUser(UserModel user) async {
    try {
      await _client.from('users').insert(user.toMap());
      return true;
    } catch (e) {
      print('خطأ في إضافة المستخدم: $e');
      return false;
    }
  }

  // تحديث مستخدم
  static Future<bool> updateUser(UserModel user) async {
    try {
      await _client
          .from('users')
          .update(user.toMap())
          .eq('id', user.id);
      return true;
    } catch (e) {
      print('خطأ في تحديث المستخدم: $e');
      return false;
    }
  }

  // حذف مستخدم
  static Future<bool> deleteUser(String userId) async {
    try {
      await _client.from('users').delete().eq('id', userId);
      return true;
    } catch (e) {
      print('خطأ في حذف المستخدم: $e');
      return false;
    }
  }

  // ========== إدارة الطلبات ==========
  
  // الحصول على جميع الطلبات
  static Stream<List<OrderModel>> getOrders() {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => OrderModel.fromMap(item, item['id'])).toList());
  }

  // الحصول على طلبات بحالة معينة
  static Stream<List<OrderModel>> getOrdersByStatus(OrderStatus status) {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('status', status.toString().split('.').last)
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => OrderModel.fromMap(item, item['id'])).toList());
  }

  // الحصول على طلب واحد
  static Future<OrderModel?> getOrder(String orderId) async {
    try {
      final response = await _client
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();
      return OrderModel.fromMap(response, response['id']);
    } catch (e) {
      print('خطأ في الحصول على الطلب: $e');
      return null;
    }
  }

  // إضافة طلب جديد
  static Future<bool> addOrder(OrderModel order) async {
    try {
      await _client.from('orders').insert(order.toMap());
      return true;
    } catch (e) {
      print('خطأ في إضافة الطلب: $e');
      return false;
    }
  }

  // تحديث طلب
  static Future<bool> updateOrder(OrderModel order) async {
    try {
      await _client
          .from('orders')
          .update(order.toMap())
          .eq('id', order.id);
      return true;
    } catch (e) {
      print('خطأ في تحديث الطلب: $e');
      return false;
    }
  }

  // حذف طلب
  static Future<bool> deleteOrder(String orderId) async {
    try {
      await _client.from('orders').delete().eq('id', orderId);
      return true;
    } catch (e) {
      print('خطأ في حذف الطلب: $e');
      return false;
    }
  }

  // ========== إدارة السائقين ==========
  
  // الحصول على جميع السائقين
  static Stream<List<DriverModel>> getDrivers() {
    return _client
        .from('drivers')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => DriverModel.fromMap(item, item['id'])).toList());
  }

  // الحصول على سائقين متاحين
  static Stream<List<DriverModel>> getAvailableDrivers() {
    return _client
        .from('drivers')
        .stream(primaryKey: ['id'])
        .eq('status', 'available')
        .map((data) => data.map((item) => DriverModel.fromMap(item, item['id'])).toList());
  }

  // الحصول على سائق واحد
  static Future<DriverModel?> getDriver(String driverId) async {
    try {
      final response = await _client
          .from('drivers')
          .select()
          .eq('id', driverId)
          .single();
      return DriverModel.fromMap(response, response['id']);
    } catch (e) {
      print('خطأ في الحصول على السائق: $e');
      return null;
    }
  }

  // إضافة سائق جديد
  static Future<bool> addDriver(DriverModel driver) async {
    try {
      await _client.from('drivers').insert(driver.toMap());
      return true;
    } catch (e) {
      print('خطأ في إضافة السائق: $e');
      return false;
    }
  }

  // تحديث سائق
  static Future<bool> updateDriver(DriverModel driver) async {
    try {
      await _client
          .from('drivers')
          .update(driver.toMap())
          .eq('id', driver.id);
      return true;
    } catch (e) {
      print('خطأ في تحديث السائق: $e');
      return false;
    }
  }

  // حذف سائق
  static Future<bool> deleteDriver(String driverId) async {
    try {
      await _client.from('drivers').delete().eq('id', driverId);
      return true;
    } catch (e) {
      print('خطأ في حذف السائق: $e');
      return false;
    }
  }

  // ========== إدارة الموظفين ==========
  
  // الحصول على جميع الموظفين
  static Stream<List<EmployeeModel>> getEmployees() {
    return _client
        .from('employees')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => EmployeeModel.fromMap(item, item['id'])).toList());
  }

  // الحصول على موظف واحد
  static Future<EmployeeModel?> getEmployee(String employeeId) async {
    try {
      final response = await _client
          .from('employees')
          .select()
          .eq('id', employeeId)
          .single();
      return EmployeeModel.fromMap(response, response['id']);
    } catch (e) {
      print('خطأ في الحصول على الموظف: $e');
      return null;
    }
  }

  // إضافة موظف جديد
  static Future<bool> addEmployee(EmployeeModel employee) async {
    try {
      print('محاولة إضافة موظف: ${employee.name}');
      print('بيانات الموظف: ${employee.toMap()}');
      
      await _client.from('employees').insert(employee.toMap());
      print('تم إضافة الموظف بنجاح');
      return true;
    } catch (e) {
      print('خطأ في إضافة الموظف: $e');
      print('تفاصيل الخطأ: ${e.toString()}');
      return false;
    }
  }

  // تحديث موظف
  static Future<bool> updateEmployee(EmployeeModel employee) async {
    try {
      await _client
          .from('employees')
          .update(employee.toMap())
          .eq('id', employee.id);
      return true;
    } catch (e) {
      print('خطأ في تحديث الموظف: $e');
      return false;
    }
  }

  // حذف موظف
  static Future<bool> deleteEmployee(String employeeId) async {
    try {
      await _client.from('employees').delete().eq('id', employeeId);
      return true;
    } catch (e) {
      print('خطأ في حذف الموظف: $e');
      return false;
    }
  }

  // ========== الإحصائيات ==========
  
  // الحصول على إحصائيات الطلبات
  static Future<Map<String, int>> getOrderStats() async {
    try {
      final response = await _client.from('orders').select();
      final orders = response.map((item) => OrderModel.fromMap(item, item['id'])).toList();

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
      final response = await _client.from('users').select();
      final users = response.map((item) => UserModel.fromMap(item, item['id'])).toList();

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
      final response = await _client.from('drivers').select();
      final drivers = response.map((item) => DriverModel.fromMap(item, item['id'])).toList();

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

  // الحصول على إحصائيات الموظفين
  static Future<Map<String, int>> getEmployeeStats() async {
    try {
      final response = await _client.from('employees').select();
      final employees = response.map((item) => EmployeeModel.fromMap(item, item['id'])).toList();

      return {
        'total': employees.length,
        'active': employees.where((e) => e.status == EmployeeStatus.active).length,
        'inactive': employees.where((e) => e.status == EmployeeStatus.inactive).length,
        'suspended': employees.where((e) => e.status == EmployeeStatus.suspended).length,
        'terminated': employees.where((e) => e.status == EmployeeStatus.terminated).length,
      };
    } catch (e) {
      print('خطأ في الحصول على إحصائيات الموظفين: $e');
      return {
        'total': 0,
        'active': 0,
        'inactive': 0,
        'suspended': 0,
        'terminated': 0,
      };
    }
  }

  // ========== التخزين (Storage) ==========
  
  // رفع صورة
  static Future<String?> uploadImage(String bucket, String path, Uint8List imageBytes) async {
    try {
      final response = await _client.storage
          .from(bucket)
          .uploadBinary(path, imageBytes);
      return response;
    } catch (e) {
      print('خطأ في رفع الصورة: $e');
      return null;
    }
  }

  // الحصول على رابط الصورة
  static String getImageUrl(String bucket, String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  // حذف صورة
  static Future<bool> deleteImage(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).remove([path]);
      return true;
    } catch (e) {
      print('خطأ في حذف الصورة: $e');
      return false;
    }
  }
}
