import 'package:gobus_app/features/tripSearchDetail/models/city.dart';

class TripInfo {
  final int scheduleId;
  final int tripId;
  final int providerId;
  final DateTime departure;
  final int pricePerPassenger;
  final int seatsAvailable;
  final String comfortType;
  final String transportType;
  final City from;
  final City to;

  TripInfo({
    required this.scheduleId,
    required this.tripId,
    required this.providerId,
    required this.departure,
    required this.pricePerPassenger,
    required this.seatsAvailable,
    required this.comfortType,
    required this.transportType,
    required this.from,
    required this.to,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) {
    return TripInfo(
      scheduleId: (json['schedule_id'] as num?)?.toInt() ?? 0,
      tripId: (json['trip_id'] as num?)?.toInt() ?? 0,
      providerId: (json['provider_id'] as num?)?.toInt() ?? 0,

      departure:
          json['departure_datetime'] != null
              ? DateTime.tryParse(json['departure_datetime']) ?? DateTime.now()
              : DateTime.now(),

      pricePerPassenger: (json['price_per_passenger'] as num?)?.toInt() ?? 0,
      seatsAvailable: (json['seats_available'] as num?)?.toInt() ?? 0,

      comfortType: json['comfort_type'] ?? '',
      transportType: json['transport_type'] ?? '',

      from: City.fromJson(json['from'] ?? {}),
      to: City.fromJson(json['to'] ?? {}),
    );
  }
}
