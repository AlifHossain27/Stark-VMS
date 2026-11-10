class Vehicle {
  static const List<String> vehicleTypes = [
    'CAR',
    'VAN',
    'TRUCK',
    'BUS',
    'MOTORCYCLE',
    'OTHER',
  ];

  static const List<String> statusValues = [
    'ACTIVE',
    'INACTIVE',
    'MAINTENANCE',
  ];

  final int id;
  final String vehicleNumber;
  final String brand;
  final String model;
  final String company;
  final String vehicleType;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.company,
    required this.vehicleType,
    this.status = 'ACTIVE',
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      vehicleNumber: json['vehicleNumber'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      company: json['company'] as String? ?? '',
      vehicleType: json['vehicleType'] as String? ?? 'OTHER',
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'brand': brand,
      'model': model,
      'company': company,
      'vehicleType': vehicleType,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Request body for POST and PUT (excludes read-only fields id, createdAt, updatedAt)
  Map<String, dynamic> toRequestBody() {
    return {
      'vehicleNumber': vehicleNumber.trim().toUpperCase(),
      'brand': brand.trim(),
      'model': model.trim(),
      'company': company.trim(),
      'vehicleType': vehicleType,
      'status': status,
    };
  }

  Vehicle copyWith({
    int? id,
    String? vehicleNumber,
    String? brand,
    String? model,
    String? company,
    String? vehicleType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      company: company ?? this.company,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          vehicleNumber == other.vehicleNumber;

  @override
  int get hashCode => id.hashCode ^ vehicleNumber.hashCode;
}
