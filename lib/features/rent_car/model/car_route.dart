class CarRoute {
  final int routeId;
  final String vehicleCategory;
  final double? distanceKm;
  final int? estimatedDurationMinutes;
  final double price;
  final String currency;
  final int days;

  final int providerId;
  final String providerName;
  final String? providerLogo;

  CarRoute({
    required this.routeId,
    required this.vehicleCategory,
    required this.distanceKm,
    required this.estimatedDurationMinutes,
    required this.price,
    required this.currency,
    required this.days,
    required this.providerId,
    required this.providerName,
    this.providerLogo,
  });

  factory CarRoute.fromJson(Map<String, dynamic> json) {
    return CarRoute(
      routeId: json['route_id'] ?? 0,
      vehicleCategory: json['vehicle_category'] ?? "",

      distanceKm:
          json['distance_km'] != null
              ? double.tryParse(json['distance_km'].toString())
              : null,

      estimatedDurationMinutes:
          json['estimated_duration_minutes'] != null
              ? int.tryParse(json['estimated_duration_minutes'].toString())
              : null,

      price: double.tryParse(json['price'].toString()) ?? 0,

      currency: json['currency'] ?? "",

      days: json['days'] ?? 1,

      providerId: json['provider']?['id'] ?? 0,
      providerName: json['provider']?['name'] ?? "",
      providerLogo: json['provider']?['logo'],
    );
  }
}
