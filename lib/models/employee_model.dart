
enum EmployeeRole {
  manager('manager', 'مدير'),
  supervisor('supervisor', 'مشرف'),
  operator('operator', 'موظف عمليات'),
  support('support', 'موظف دعم'),
  accountant('accountant', 'محاسب'),
  hr('hr', 'موارد بشرية'),
  marketing('marketing', 'تسويق'),
  technician('technician', 'فني');

  const EmployeeRole(this.value, this.displayName);
  final String value;
  final String displayName;

  static EmployeeRole fromString(String role) {
    return EmployeeRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => EmployeeRole.operator,
    );
  }
}

enum EmployeeStatus {
  active('active', 'نشط'),
  inactive('inactive', 'غير نشط'),
  suspended('suspended', 'معلق'),
  terminated('terminated', 'منتهي الخدمة');

  const EmployeeStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static EmployeeStatus fromString(String status) {
    return EmployeeStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => EmployeeStatus.active,
    );
  }
}

enum Department {
  operations('operations', 'العمليات'),
  support('support', 'الدعم الفني'),
  finance('finance', 'المالية'),
  hr('hr', 'الموارد البشرية'),
  marketing('marketing', 'التسويق'),
  technical('technical', 'التقنية'),
  management('management', 'الإدارة');

  const Department(this.value, this.displayName);
  final String value;
  final String displayName;

  static Department fromString(String department) {
    return Department.values.firstWhere(
      (e) => e.value == department,
      orElse: () => Department.operations,
    );
  }
}

class EmployeeModel {
  final String id;
  final String employeeId; // رقم الموظف
  final String name;
  final String email;
  final String phone;
  final EmployeeRole role;
  final Department department;
  final EmployeeStatus status;
  final String? nationalId; // رقم الهوية الوطنية
  final String? passportNumber; // رقم جواز السفر
  final DateTime hireDate; // تاريخ التعيين
  final DateTime? terminationDate; // تاريخ إنهاء الخدمة
  final double? salary; // الراتب
  final String? emergencyContact; // جهة الاتصال في الطوارئ
  final String? emergencyPhone; // رقم الطوارئ
  final String? address; // العنوان
  final String? notes; // ملاحظات
  final Map<String, dynamic>? additionalInfo; // معلومات إضافية
  final DateTime createdAt;
  final DateTime? lastLogin;
  final String? profileImageUrl; // صورة الموظف

  EmployeeModel({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    this.status = EmployeeStatus.active,
    this.nationalId,
    this.passportNumber,
    required this.hireDate,
    this.terminationDate,
    this.salary,
    this.emergencyContact,
    this.emergencyPhone,
    this.address,
    this.notes,
    this.additionalInfo,
    required this.createdAt,
    this.lastLogin,
    this.profileImageUrl,
  });

  // تحويل من Map إلى EmployeeModel
  factory EmployeeModel.fromMap(Map<String, dynamic> map, String id) {
    return EmployeeModel(
      id: id,
      employeeId: map['employee_id'] ?? map['employeeId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: EmployeeRole.fromString(map['role'] ?? 'operator'),
      department: Department.fromString(map['department'] ?? 'operations'),
      status: EmployeeStatus.fromString(map['status'] ?? 'active'),
      nationalId: map['national_id'] ?? map['nationalId'],
      passportNumber: map['passport_number'] ?? map['passportNumber'],
      hireDate: DateTime.parse(map['hire_date']),
      terminationDate: map['termination_date'] != null 
          ? DateTime.parse(map['termination_date']) 
          : null,
      salary: map['salary']?.toDouble(),
      emergencyContact: map['emergency_contact'] ?? map['emergencyContact'],
      emergencyPhone: map['emergency_phone'] ?? map['emergencyPhone'],
      address: map['address'],
      notes: map['notes'],
      additionalInfo: null, // تم إزالة هذا الحقل من قاعدة البيانات
      createdAt: DateTime.parse(map['created_at']),
      lastLogin: map['last_login'] != null 
          ? DateTime.parse(map['last_login']) 
          : null,
      profileImageUrl: map['profile_image_url'] ?? map['profileImageUrl'],
    );
  }

  // تحويل من EmployeeModel إلى Map
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'employee_id': employeeId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.value,
      'position': role.value, // استخدام role كـ position للتوافق مع قاعدة البيانات
      'department': department.value,
      'status': status.value,
      'hire_date': hireDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
    
    // إضافة الحقول الاختيارية فقط إذا كانت غير فارغة
    if (nationalId != null && nationalId!.isNotEmpty) {
      data['national_id'] = nationalId;
    }
    if (terminationDate != null) {
      data['termination_date'] = terminationDate!.toIso8601String();
    }
    if (salary != null) {
      data['salary'] = salary;
    }
    if (emergencyContact != null && emergencyContact!.isNotEmpty) {
      data['emergency_contact'] = emergencyContact;
    }
    if (emergencyPhone != null && emergencyPhone!.isNotEmpty) {
      data['emergency_phone'] = emergencyPhone;
    }
    if (address != null && address!.isNotEmpty) {
      data['address'] = address;
    }
    if (notes != null && notes!.isNotEmpty) {
      data['notes'] = notes;
    }
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      data['profile_image_url'] = profileImageUrl;
    }
    
    return data;
  }

  // نسخ مع تعديل
  EmployeeModel copyWith({
    String? id,
    String? employeeId,
    String? name,
    String? email,
    String? phone,
    EmployeeRole? role,
    Department? department,
    EmployeeStatus? status,
    String? nationalId,
    String? passportNumber,
    DateTime? hireDate,
    DateTime? terminationDate,
    double? salary,
    String? emergencyContact,
    String? emergencyPhone,
    String? address,
    String? notes,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? profileImageUrl,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      status: status ?? this.status,
      nationalId: nationalId ?? this.nationalId,
      passportNumber: passportNumber ?? this.passportNumber,
      hireDate: hireDate ?? this.hireDate,
      terminationDate: terminationDate ?? this.terminationDate,
      salary: salary ?? this.salary,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // حساب سنوات الخدمة
  int get yearsOfService {
    final now = DateTime.now();
    return now.year - hireDate.year;
  }

  // التحقق من أن الموظف نشط
  bool get isActive => status == EmployeeStatus.active;

  // التحقق من أن الموظف مدير
  bool get isManager => role == EmployeeRole.manager;

  // الحصول على لون الحالة
  String get statusColor {
    switch (status) {
      case EmployeeStatus.active:
        return 'green';
      case EmployeeStatus.inactive:
        return 'orange';
      case EmployeeStatus.suspended:
        return 'red';
      case EmployeeStatus.terminated:
        return 'grey';
    }
  }
}
