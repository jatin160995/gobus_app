import 'package:gobus_app/features/rent_car/model/car_route.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';

class CarSearchService {
  static Future<ApiResponse<List<CarRoute>>> searchCars({
    required int fromCityId,
    required int toCityId,
    required String tripType,
    required String pickupDate,
    required String pickupTime,
    String? returnDate,
    required int passengers,
  }) {
    return ApiClient.post<List<CarRoute>>(
      "car/search",
      body: {
        "from_city_id": fromCityId,
        "to_city_id": toCityId,
        "trip_type": tripType,
        "pickup_date": pickupDate,
        "pickup_time": pickupTime,
        "return_date": returnDate,
        "passengers": passengers,
      },
      parser: (json) {
        return (json as List).map((e) => CarRoute.fromJson(e)).toList();
      },
    );
  }
}
