class Trip {
  final int scheduleId;
  final DateTime departure;
  final int price;
  final int seats;
  final String comfort;
  final String departure_datetime;
  final int durationMinutes;
  final String totalStops;
  final String providerName;
  final String providerLogo;

  // Round trip fields
  final Trip? outbound;
  final Trip? returnLeg;
  final double? roundTripPricePerPassenger;
  final double? roundTripTotalPrice;

  final double? childPricePerPassenger;
  final double? roundTripChildPrice;

  Trip({
    required this.scheduleId,
    required this.departure,
    required this.price,
    required this.seats,
    required this.comfort,
    required this.departure_datetime,
    required this.durationMinutes,
    required this.totalStops,
    required this.providerName,
    required this.providerLogo,
    this.childPricePerPassenger,
    this.roundTripChildPrice,
    this.outbound,
    this.returnLeg,
    this.roundTripPricePerPassenger,
    this.roundTripTotalPrice,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      scheduleId: json['schedule_id'],
      departure: DateTime.parse(json['departure_datetime']),
      price: json['total_price'],
      seats: json['seats_available'],
      comfort: json['comfort_type'],
      departure_datetime: json['departure_datetime'],
      durationMinutes: json['route']['duration_minutes'],
      totalStops: json['stops']['label'],
      providerName: json['provider']['name'],
      providerLogo: json['provider']['logo'],
      childPricePerPassenger:
          (json['child_price_per_passenger'] as num?)?.toDouble(),
      roundTripChildPrice:
          (json['round_trip_child_price_per_passenger'] as num?)?.toDouble(),
    );
  }

  /// Used for parsing a round trip result item
  factory Trip.fromRoundTripJson(Map<String, dynamic> json) {
    return Trip(
      // Top level fields not used directly for round trip card
      scheduleId: 0,
      departure: DateTime.now(),
      price: 0,
      seats: 0,
      comfort: '',
      departure_datetime: '',
      durationMinutes: 0,
      totalStops: '',
      providerName: '',
      providerLogo: '',

      outbound: Trip._fromLegJson(json['outbound']),
      returnLeg: Trip._fromLegJson(json['return']),
      roundTripPricePerPassenger:
          (json['round_trip_price_per_passenger'] as num?)?.toDouble(),
      roundTripTotalPrice: (json['round_trip_total_price'] as num?)?.toDouble(),
      roundTripChildPrice:
          (json['round_trip_child_price_per_passenger'] as num?)?.toDouble(),
    );
  }

  /// Parse a single leg (outbound or return) from round trip response
  factory Trip._fromLegJson(Map<String, dynamic> json) {
    return Trip(
      scheduleId: json['schedule_id'],
      departure: DateTime.parse(json['departure_datetime']),
      price: (json['total_price'] as num?)?.toInt() ?? 0,
      seats: json['seats_available'],
      comfort: json['comfort_type'],
      departure_datetime: json['departure_datetime'],
      durationMinutes: json['route']['duration_minutes'],
      totalStops: json['stops']['label'],
      providerName: json['provider']?['name'] ?? '',
      providerLogo: json['provider']?['logo'] ?? '',
      roundTripChildPrice:
          (json['round_trip_child_price_per_passenger'] as num?)?.toDouble(),
      childPricePerPassenger:
          (json['child_price_per_passenger'] as num?)?.toDouble(),
    );
  }
}
