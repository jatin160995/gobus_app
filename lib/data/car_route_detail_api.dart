import 'package:gobus_app/core/api/api_response.dart';
import 'package:gobus_app/features/rent_car/model/car_route_detail.dart';
import '../../core/api/api_client.dart';

class CarRouteDetailService {
  static Future<ApiResponse<CarRouteDetail>> getRouteDetails({
    required int routeId,
    required String vehicleCategory,
    required String tripType,
    required String pickupDate,
    required String pickupTime,
    String? returnDate,
  }) {
    return ApiClient.post<CarRouteDetail>(
      "car/route-details",
      body: {
        "route_id": routeId,
        "vehicle_category": vehicleCategory,
        "trip_type": tripType,
        "pickup_date": pickupDate,
        "pickup_time": pickupTime,
        "return_date": returnDate,
      },
      parser: (json) {
        return CarRouteDetail.fromJson(json);
      },
    );
  }
}
