import 'package:gobus_app/features/search/models/trip.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_response.dart';

Future<ApiResponse<List<Trip>>> searchTrips({
  required String from,
  required String to,
  required String date,
  required int passengers,
  int children = 0,
  String tripType = 'one_way',
  String? returnDate,
}) {
  return ApiClient.post(
    "trips/search",
    body: {
      "from": from,
      "to": to,
      "date": date,
      "passengers": passengers.toString(),
      "children": children.toString(),
      "trip_type": tripType,
      if (returnDate != null) "return_date": returnDate,
    },
    parser: (json) {
      final isRoundTrip = tripType == 'round_trip';
      return (json as List).map((e) {
        if (isRoundTrip) return Trip.fromRoundTripJson(e);
        return Trip.fromJson(e);
      }).toList();
    },
  );
}
