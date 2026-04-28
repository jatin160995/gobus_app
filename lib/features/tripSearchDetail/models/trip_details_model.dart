import 'package:gobus_app/features/tripSearchDetail/models/seat.dart';
import 'package:gobus_app/features/tripSearchDetail/models/stop.dart';
import 'package:gobus_app/features/tripSearchDetail/models/trip_info.dart';
import 'package:gobus_app/features/tripSearchDetail/models/vehicle.dart';

class TripDetails {
  final String tripType;
  final TripInfo trip;
  final List<Stop> stops;
  final Vehicle vehicle;
  final List<Seat> seatMap;
  final List<dynamic> legalValues;

  // Round trip fields
  final TripInfo? returnTrip;
  final List<Stop> returnStops;
  final List<Seat> returnSeatMap;
  final TripPricing? pricing;

  TripDetails({
    required this.tripType,
    required this.trip,
    required this.stops,
    required this.vehicle,
    required this.seatMap,
    this.returnTrip,
    this.returnStops = const [],
    this.returnSeatMap = const [],
    this.pricing,
    this.legalValues = const [],
  });

  bool get isRoundTrip => tripType == 'round_trip';

  factory TripDetails.fromJson(Map<String, dynamic> json) {
    return TripDetails(
      tripType: json['trip_type'] ?? 'one_way',
      trip: TripInfo.fromJson(json['trip'] ?? {}),
      stops:
          (json['stops'] as List? ?? []).map((e) => Stop.fromJson(e)).toList(),
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      seatMap:
          (json['seat_map'] as List? ?? [])
              .map((e) => Seat.fromJson(e))
              .toList(),
      returnTrip:
          json['return_trip'] != null
              ? TripInfo.fromJson(json['return_trip'])
              : null,
      returnStops:
          (json['return_stops'] as List? ?? [])
              .map((e) => Stop.fromJson(e))
              .toList(),
      returnSeatMap:
          (json['return_seat_map'] as List? ?? [])
              .map((e) => Seat.fromJson(e))
              .toList(),
      pricing:
          json['pricing'] != null
              ? TripPricing.fromJson(json['pricing'])
              : null,
      legalValues: json['legal_values'] as List? ?? [],
    );
  }
}

class TripPricing {
  final double oneWayPricePerPassenger;
  final double oneWayChildPricePerPassenger;
  final double? roundTripPricePerPassenger;
  final double? roundTripChildPricePerPassenger;

  //
  final double? basePrice;
  final double? commission;
  final double? insurance;
  final double? platform_commission;
  final double? vatPercent;
  final double? vatAmount;
  final double? grandTotal;
  final String? currency;

  TripPricing({
    required this.oneWayPricePerPassenger,
    required this.oneWayChildPricePerPassenger,
    this.roundTripPricePerPassenger,
    this.roundTripChildPricePerPassenger,

    this.basePrice,
    this.commission,
    this.insurance,
    this.platform_commission,
    this.vatPercent,
    this.vatAmount,
    this.grandTotal,
    this.currency,
  });

  factory TripPricing.fromJson(Map<String, dynamic> json) {
    return TripPricing(
      oneWayPricePerPassenger:
          (json['one_way_price_per_passenger'] as num?)?.toDouble() ?? 0.0,

      // ✅ FIX HERE (correct key from API)
      oneWayChildPricePerPassenger:
          (json['child_price_per_passenger'] as num?)?.toDouble() ?? 0.0,

      roundTripPricePerPassenger:
          (json['round_trip_price_per_passenger'] as num?)?.toDouble(),

      roundTripChildPricePerPassenger:
          (json['round_trip_child_price_per_passenger'] as num?)?.toDouble(),

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

  // Calculate total based on trip type and passenger counts
  double calculateTotal({
    required int adults,
    required int children,
    required bool isRoundTrip,
  }) {
    if (isRoundTrip && roundTripPricePerPassenger != null) {
      final adultTotal = roundTripPricePerPassenger! * adults;
      final childTotal =
          (roundTripChildPricePerPassenger ?? roundTripPricePerPassenger!) *
          2 *
          children;
      return adultTotal + childTotal;
    }
    final adultTotal = oneWayPricePerPassenger * adults;
    final childTotal = oneWayChildPricePerPassenger * children;
    return adultTotal + childTotal;
  }
}
