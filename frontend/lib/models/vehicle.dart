class Vehicle {
  final int id;
  final String vehicleNumber;
  final String brand;
  final String model;
  final int manufactureYear;
  final String vehicleType;
  final String? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.manufactureYear,
    required this.vehicleType,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      vehicleNumber: json['vehicleNumber'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      manufactureYear: json['manufactureYear'] as int,
      vehicleType: json['vehicleType'] as String,
      color: json['color'] as String?,
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
      'manufactureYear': manufactureYear,
      'vehicleType': vehicleType,
      if (color != null) 'color': color,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Request body for POST and PUT (excludes read-only fields id, createdAt, updatedAt)
  Map<String, dynamic> toRequestBody() {
    return {
      'vehicleNumber': vehicleNumber,
      'brand': brand,
      'model': model,
      'manufactureYear': manufactureYear,
      'vehicleType': vehicleType,
      if (color != null && color!.trim().isNotEmpty) 'color': color!.trim(),
    };
  }

  Vehicle copyWith({
    int? id,
    String? vehicleNumber,
    String? brand,
    String? model,
    int? manufactureYear,
    String? vehicleType,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      manufactureYear: manufactureYear ?? this.manufactureYear,
      vehicleType: vehicleType ?? this.vehicleType,
      color: color ?? this.color,
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
