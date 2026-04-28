class Vehicle {
  final int id;
  final String model;
  final String plateNumber;
  final int capacity;
  final String comfortType;
  final String layout;
  final List<String> images;

  Vehicle({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.capacity,
    required this.comfortType,
    required this.images,
    required this.layout,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      model: json['model'] ?? '',
      plateNumber: json['plate_number'] ?? '',
      capacity: json['capacity'] ?? 0,
      comfortType: json['comfort_type'] ?? '',
      layout: json['layout'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}
