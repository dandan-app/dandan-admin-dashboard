import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/driver_model.dart';
import '../models/employee_model.dart';
import '../services/supabase_database_service.dart';

class SampleData {
  // إضافة بيانات تجريبية للمستخدمين
  static Future<void> addSampleUsers() async {
    final users = [
      UserModel(
        id: 'user_001',
        name: 'أحمد محمد العلي',
        email: 'ahmed@example.com',
        phone: '+966501234567',
        role: UserRole.admin,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
        address: {
          'city': 'الرياض',
          'district': 'النخيل',
          'street': 'شارع الملك فهد',
        },
      ),
      UserModel(
        id: 'user_002',
        name: 'فاطمة السالم',
        email: 'fatima@example.com',
        phone: '+966502345678',
        role: UserRole.operations,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
        address: {
          'city': 'جدة',
          'district': 'الزهراء',
          'street': 'شارع التحلية',
        },
      ),
      UserModel(
        id: 'user_003',
        name: 'محمد عبدالله',
        email: 'mohammed@example.com',
        phone: '+966503456789',
        role: UserRole.support,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
        address: {
          'city': 'الدمام',
          'district': 'المنطقة الشرقية',
          'street': 'شارع الملك عبدالعزيز',
        },
      ),
      UserModel(
        id: 'user_004',
        name: 'نورا أحمد',
        email: 'nora@example.com',
        phone: '+966504567890',
        role: UserRole.financial,
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastLogin: DateTime.now().subtract(const Duration(days: 3)),
        address: {
          'city': 'الرياض',
          'district': 'الملز',
          'street': 'شارع العليا',
        },
      ),
    ];

    for (final user in users) {
      await SupabaseDatabaseService.addUser(user);
    }
  }

  // إضافة بيانات تجريبية للسائقين
  static Future<void> addSampleDrivers() async {
    final drivers = [
      DriverModel(
        id: 'driver_001',
        name: 'سعد العتيبي',
        email: 'saad@example.com',
        phone: '+966505678901',
        licenseNumber: '1234567890',
        vehicleType: 'سيارة صغيرة',
        vehicleNumber: 'أ ب ج 1234',
        status: DriverStatus.available,
        rating: 4.8,
        totalTrips: 156,
        currentLat: 24.7136,
        currentLng: 46.6753,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        lastActiveAt: DateTime.now().subtract(const Duration(minutes: 5)),
        vehicleInfo: {
          'year': 2020,
          'color': 'أبيض',
          'model': 'تويوتا كامري',
        },
      ),
      DriverModel(
        id: 'driver_002',
        name: 'خالد المطيري',
        email: 'khalid@example.com',
        phone: '+966506789012',
        licenseNumber: '0987654321',
        vehicleType: 'فان',
        vehicleNumber: 'د هـ و 5678',
        status: DriverStatus.busy,
        rating: 4.6,
        totalTrips: 89,
        currentLat: 24.7136,
        currentLng: 46.6753,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        lastActiveAt: DateTime.now().subtract(const Duration(minutes: 15)),
        vehicleInfo: {
          'year': 2019,
          'color': 'أزرق',
          'model': 'هيونداي إلانترا',
        },
      ),
      DriverModel(
        id: 'driver_003',
        name: 'عبدالرحمن القحطاني',
        email: 'abdulrahman@example.com',
        phone: '+966507890123',
        licenseNumber: '1122334455',
        vehicleType: 'شاحنة صغيرة',
        vehicleNumber: 'ز ح ط 9012',
        status: DriverStatus.offline,
        rating: 4.9,
        totalTrips: 203,
        currentLat: 24.7136,
        currentLng: 46.6753,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
        vehicleInfo: {
          'year': 2021,
          'color': 'أسود',
          'model': 'فورد ترانزيت',
        },
      ),
    ];

    for (final driver in drivers) {
      await SupabaseDatabaseService.addDriver(driver);
    }
  }

  // إضافة بيانات تجريبية للطلبات
  static Future<void> addSampleOrders() async {
    final orders = [
      OrderModel(
        id: 'order_001',
        customerId: 'customer_001',
        customerName: 'عبدالله السعد',
        customerPhone: '+966508901234',
        driverId: 'driver_001',
        driverName: 'سعد العتيبي',
        status: OrderStatus.completed,
        pickupAddress: 'الرياض - حي النخيل - شارع الملك فهد',
        deliveryAddress: 'الرياض - حي الملز - شارع العليا',
        pickupLat: 24.7136,
        pickupLng: 46.6753,
        deliveryLat: 24.7136,
        deliveryLng: 46.6753,
        distance: 15.5,
        price: 45.0,
        notes: 'توصيل سريع',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        completedAt: DateTime.now().subtract(const Duration(hours: 1)),
        metadata: {
          'paymentMethod': 'نقدي',
          'deliveryTime': '30 دقيقة',
        },
      ),
      OrderModel(
        id: 'order_002',
        customerId: 'customer_002',
        customerName: 'مريم الأحمد',
        customerPhone: '+966509012345',
        driverId: 'driver_002',
        driverName: 'خالد المطيري',
        status: OrderStatus.inProgress,
        pickupAddress: 'جدة - حي الزهراء - شارع التحلية',
        deliveryAddress: 'جدة - حي الروضة - شارع الأمير محمد',
        pickupLat: 21.4858,
        pickupLng: 39.1925,
        deliveryLat: 21.4858,
        deliveryLng: 39.1925,
        distance: 8.2,
        price: 25.0,
        notes: 'حساس للصدمات',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        metadata: {
          'paymentMethod': 'بطاقة ائتمان',
          'estimatedTime': '20 دقيقة',
        },
      ),
      OrderModel(
        id: 'order_003',
        customerId: 'customer_003',
        customerName: 'يوسف النجار',
        customerPhone: '+966500123456',
        driverId: 'driver_003',
        driverName: 'عبدالرحمن القحطاني',
        status: OrderStatus.pending,
        pickupAddress: 'الدمام - المنطقة الشرقية - شارع الملك عبدالعزيز',
        deliveryAddress: 'الدمام - حي الفيصلية - شارع الأمير سلطان',
        pickupLat: 26.4207,
        pickupLng: 50.0888,
        deliveryLat: 26.4207,
        deliveryLng: 50.0888,
        distance: 12.8,
        price: 35.0,
        notes: 'طلب عاجل',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        metadata: {
          'paymentMethod': 'نقدي',
          'priority': 'عاجل',
        },
      ),
      OrderModel(
        id: 'order_004',
        customerId: 'customer_004',
        customerName: 'هند المطيري',
        customerPhone: '+966501234567',
        driverId: 'driver_001',
        driverName: 'سعد العتيبي',
        status: OrderStatus.confirmed,
        pickupAddress: 'الرياض - حي العليا - شارع العليا',
        deliveryAddress: 'الرياض - حي النرجس - شارع النرجس',
        pickupLat: 24.7136,
        pickupLng: 46.6753,
        deliveryLat: 24.7136,
        deliveryLng: 46.6753,
        distance: 6.5,
        price: 20.0,
        notes: 'توصيل في المساء',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        metadata: {
          'paymentMethod': 'نقدي',
          'deliveryTime': 'المساء',
        },
      ),
      OrderModel(
        id: 'order_005',
        customerId: 'customer_005',
        customerName: 'فهد الشمري',
        customerPhone: '+966502345678',
        driverId: 'driver_002',
        driverName: 'خالد المطيري',
        status: OrderStatus.cancelled,
        pickupAddress: 'الرياض - حي الورود - شارع الورود',
        deliveryAddress: 'الرياض - حي الياسمين - شارع الياسمين',
        pickupLat: 24.7136,
        pickupLng: 46.6753,
        deliveryLat: 24.7136,
        deliveryLng: 46.6753,
        distance: 4.2,
        price: 15.0,
        notes: 'تم الإلغاء من قبل العميل',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        metadata: {
          'paymentMethod': 'نقدي',
          'cancellationReason': 'من قبل العميل',
        },
      ),
    ];

    for (final order in orders) {
      await SupabaseDatabaseService.addOrder(order);
    }
  }

  // إضافة بيانات تجريبية للموظفين
  static Future<void> addSampleEmployees() async {
    final employees = [
      EmployeeModel(
        id: 'emp_001',
        employeeId: 'EMP001',
        name: 'سارة أحمد المطيري',
        email: 'sarah@dandn.com',
        phone: '+966501111111',
        role: EmployeeRole.manager,
        department: Department.management,
        status: EmployeeStatus.active,
        nationalId: '1234567890',
        hireDate: DateTime(2023, 1, 15),
        salary: 15000.0,
        emergencyContact: 'أحمد المطيري',
        emergencyPhone: '+966502222222',
        address: 'الرياض - حي النخيل - شارع الملك فهد',
        notes: 'مديرة العمليات الرئيسية',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      EmployeeModel(
        id: 'emp_002',
        employeeId: 'EMP002',
        name: 'محمد عبدالله السعد',
        email: 'mohammed@dandn.com',
        phone: '+966503333333',
        role: EmployeeRole.supervisor,
        department: Department.operations,
        status: EmployeeStatus.active,
        nationalId: '2345678901',
        hireDate: DateTime(2023, 3, 10),
        salary: 12000.0,
        emergencyContact: 'فاطمة السعد',
        emergencyPhone: '+966504444444',
        address: 'جدة - حي الزهراء - شارع التحلية',
        notes: 'مشرف فريق العمليات',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      EmployeeModel(
        id: 'emp_003',
        employeeId: 'EMP003',
        name: 'فاطمة علي القحطاني',
        email: 'fatima@dandn.com',
        phone: '+966505555555',
        role: EmployeeRole.operator,
        department: Department.operations,
        status: EmployeeStatus.active,
        nationalId: '3456789012',
        hireDate: DateTime(2023, 5, 20),
        salary: 8000.0,
        emergencyContact: 'علي القحطاني',
        emergencyPhone: '+966506666666',
        address: 'الدمام - المنطقة الشرقية - شارع الملك عبدالعزيز',
        notes: 'موظفة عمليات متخصصة في خدمة العملاء',
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
        lastLogin: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      EmployeeModel(
        id: 'emp_004',
        employeeId: 'EMP004',
        name: 'عبدالرحمن خالد العتيبي',
        email: 'abdulrahman@dandn.com',
        phone: '+966507777777',
        role: EmployeeRole.support,
        department: Department.support,
        status: EmployeeStatus.active,
        nationalId: '4567890123',
        hireDate: DateTime(2023, 7, 5),
        salary: 9000.0,
        emergencyContact: 'خالد العتيبي',
        emergencyPhone: '+966508888888',
        address: 'الرياض - حي الملز - شارع العليا',
        notes: 'متخصص في الدعم الفني',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      EmployeeModel(
        id: 'emp_005',
        employeeId: 'EMP005',
        name: 'نورا سعد الشمري',
        email: 'nora@dandn.com',
        phone: '+966509999999',
        role: EmployeeRole.accountant,
        department: Department.finance,
        status: EmployeeStatus.active,
        nationalId: '5678901234',
        hireDate: DateTime(2023, 9, 12),
        salary: 11000.0,
        emergencyContact: 'سعد الشمري',
        emergencyPhone: '+966500000000',
        address: 'الرياض - حي الورود - شارع الورود',
        notes: 'محاسبة متخصصة في المعاملات المالية',
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      EmployeeModel(
        id: 'emp_006',
        employeeId: 'EMP006',
        name: 'يوسف أحمد النجار',
        email: 'youssef@dandn.com',
        phone: '+966511111111',
        role: EmployeeRole.hr,
        department: Department.hr,
        status: EmployeeStatus.active,
        nationalId: '6789012345',
        hireDate: DateTime(2023, 11, 1),
        salary: 10000.0,
        emergencyContact: 'أحمد النجار',
        emergencyPhone: '+966512222222',
        address: 'جدة - حي الروضة - شارع الأمير محمد',
        notes: 'متخصص في الموارد البشرية',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        lastLogin: DateTime.now().subtract(const Duration(days: 1)),
      ),
      EmployeeModel(
        id: 'emp_007',
        employeeId: 'EMP007',
        name: 'هند محمد الأحمد',
        email: 'hind@dandn.com',
        phone: '+966513333333',
        role: EmployeeRole.marketing,
        department: Department.marketing,
        status: EmployeeStatus.inactive,
        nationalId: '7890123456',
        hireDate: DateTime(2023, 12, 15),
        salary: 9500.0,
        emergencyContact: 'محمد الأحمد',
        emergencyPhone: '+966514444444',
        address: 'الدمام - حي الفيصلية - شارع الأمير سلطان',
        notes: 'متخصصة في التسويق الرقمي',
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        lastLogin: DateTime.now().subtract(const Duration(days: 7)),
      ),
      EmployeeModel(
        id: 'emp_008',
        employeeId: 'EMP008',
        name: 'خالد عبدالعزيز المطيري',
        email: 'khalid@dandn.com',
        phone: '+966515555555',
        role: EmployeeRole.technician,
        department: Department.technical,
        status: EmployeeStatus.suspended,
        nationalId: '8901234567',
        hireDate: DateTime(2024, 1, 20),
        salary: 8500.0,
        emergencyContact: 'عبدالعزيز المطيري',
        emergencyPhone: '+966516666666',
        address: 'الرياض - حي النرجس - شارع النرجس',
        notes: 'فني متخصص في صيانة الأنظمة',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    for (final employee in employees) {
      await SupabaseDatabaseService.addEmployee(employee);
    }
  }

  // إضافة جميع البيانات التجريبية
  static Future<void> addAllSampleData() async {
    print('بدء إضافة البيانات التجريبية...');
    
    await addSampleUsers();
    print('تم إضافة المستخدمين التجريبيين');
    
    await addSampleDrivers();
    print('تم إضافة السائقين التجريبيين');
    
    await addSampleOrders();
    print('تم إضافة الطلبات التجريبية');
    
    await addSampleEmployees();
    print('تم إضافة الموظفين التجريبيين');
    
    print('تم إضافة جميع البيانات التجريبية بنجاح!');
  }
}
