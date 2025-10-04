
enum DriverStatus {
  available,   // متاح
  busy,        // مشغول
  offline,     // غير متصل
  suspended,   // معلق
}

class DriverModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String licenseNumber;
  final String vehicleType;
  final String vehicleNumber;
  final DriverStatus status;
  final double rating;
  final int totalTrips;
  final double currentLat;
  final double currentLng;
  final String? profileImage;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final Map<String, dynamic>? vehicleInfo;

  DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.status,
    this.rating = 0.0,
    this.totalTrips = 0,
    required this.currentLat,
    required this.currentLng,
    this.profileImage,
    this.isVerified = false,
    required this.createdAt,
    this.lastActiveAt,
    this.vehicleInfo,
  });

  // تحويل من Map إلى DriverModel
  factory DriverModel.fromMap(Map<String, dynamic> map, String id) {
    return DriverModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      status: DriverStatus.values.firstWhere(
        (e) => e.toString() == 'DriverStatus.${map['status']}',
        orElse: () => DriverStatus.offline,
      ),
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalTrips: map['totalTrips'] ?? 0,
      currentLat: (map['currentLat'] ?? 0.0).toDouble(),
      currentLng: (map['currentLng'] ?? 0.0).toDouble(),
      profileImage: map['profileImage'],
      isVerified: map['isVerified'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      lastActiveAt: map['last_active_at'] != null 
          ? DateTime.parse(map['last_active_at']) 
          : null,
      vehicleInfo: map['vehicleInfo'],
    );
  }

  // تحويل من DriverModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'status': status.toString().split('.').last,
      'rating': rating,
      'totalTrips': totalTrips,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'profileImage': profileImage,
      'isVerified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'vehicleInfo': vehicleInfo,
    };
  }

  // الحصول على نص الحالة بالعربية
  String get statusText {
    switch (status) {
      case DriverStatus.available:
        return 'متاح';
      case DriverStatus.busy:
        return 'مشغول';
      case DriverStatus.offline:
        return 'غير متصل';
      case DriverStatus.suspended:
        return 'معلق';
    }
  }

  // نسخ مع تعديل
  DriverModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? licenseNumber,
    String? vehicleType,
    String? vehicleNumber,
    DriverStatus? status,
    double? rating,
    int? totalTrips,
    double? currentLat,
    double? currentLng,
    String? profileImage,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    Map<String, dynamic>? vehicleInfo,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }
}
