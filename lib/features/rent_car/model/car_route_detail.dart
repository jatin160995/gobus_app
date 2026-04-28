class RouteInfo {
  final int? id;
  final String? fromCity;
  final String? toCity;
  final double? distanceKm;
  final int? durationMinutes;

  RouteInfo({
    this.id,
    this.fromCity,
    this.toCity,
    this.distanceKm,
    this.durationMinutes,
  });

  factory RouteInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RouteInfo();

    return RouteInfo(
      id: json['id'],
      fromCity: json['from_city'],
      toCity: json['to_city'],
      distanceKm:
          json['distance_km'] != null
              ? double.tryParse(json['distance_km'].toString())
              : null,
      durationMinutes: json['duration_minutes'],
    );
  }
}

class ProviderInfo {
  final int? id;
  final String? name;
  final String? logo;
  final String? phone;

  ProviderInfo({this.id, this.name, this.logo, this.phone});

  factory ProviderInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProviderInfo();

    return ProviderInfo(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      phone: json['phone'],
    );
  }
}

class PricingInfo {
  final String? tripType;
  final int? days;

  final double? basePrice;
  final double? commission;
  final double? insurance;
  final double? platform_commission;
  final double? vatPercent;
  final double? vatAmount;
  final double? grandTotal;

  final String? currency;

  PricingInfo({
    this.tripType,
    this.days,
    this.basePrice,
    this.commission,
    this.insurance,
    this.platform_commission,
    this.vatPercent,
    this.vatAmount,
    this.grandTotal,
    this.currency,
  });

  factory PricingInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PricingInfo();

    return PricingInfo(
      tripType: json['trip_type'],
      days: json['days'],

      basePrice:
          json['base_price'] != null
              ? double.parse(json['base_price'].toString())
              : 0,
      commission:
          json['commission'] != null
              ? double.parse(json['commission'].toString())
              : 0,
      insurance:
          json['insurance'] != null
              ? double.parse(json['insurance'].toString())
              : 0,
      platform_commission:
          json['platform_commission'] != null
              ? double.parse(json['platform_commission'].toString())
              : 0,

      vatPercent:
          json['vat_percent'] != null
              ? double.parse(json['vat_percent'].toString())
              : 0,

      vatAmount:
          json['vat_amount'] != null
              ? double.parse(json['vat_amount'].toString())
              : 0,

      grandTotal:
          json['grand_total'] != null
              ? double.parse(json['grand_total'].toString())
              : 0,

      currency: json['currency'],
    );
  }
}

class VehicleImage {
  final String? type;
  final String? image;

  VehicleImage({this.type, this.image});

  factory VehicleImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VehicleImage();

    return VehicleImage(type: json['type'], image: json['image']);
  }
}

class Vehicle {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final int? seats;
  final String? plateNumber;
  final String? color;
  final String? fuelType;
  final String? transmission;
  final List<VehicleImage> images;

  Vehicle({
    this.id,
    this.brand,
    this.model,
    this.year,
    this.seats,
    this.plateNumber,
    this.color,
    this.fuelType,
    this.transmission,
    this.images = const [],
  });

  factory Vehicle.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Vehicle();

    return Vehicle(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year']?.toString(),
      seats: json['seats'],
      plateNumber: json['plate_number'],
      color: json['color'],
      fuelType: json['fuel_type'],
      transmission: json['transmission'],
      images:
          (json['images'] as List?)
              ?.map((e) => VehicleImage.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CarRouteDetail {
  final RouteInfo? route;
  final ProviderInfo? provider;
  final String? vehicleCategory;
  final PricingInfo? pricing;
  final List<Vehicle> vehicles;

  CarRouteDetail({
    this.route,
    this.provider,
    this.vehicleCategory,
    this.pricing,
    this.vehicles = const [],
  });

  factory CarRouteDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CarRouteDetail();

    return CarRouteDetail(
      route: RouteInfo.fromJson(json['route']),
      provider: ProviderInfo.fromJson(json['provider']),
      vehicleCategory: json['vehicle_category'],
      pricing: PricingInfo.fromJson(json['pricing']),
      vehicles:
          (json['vehicles'] as List?)
              ?.map((e) => Vehicle.fromJson(e))
              .toList() ??
          [],
    );
  }
}
