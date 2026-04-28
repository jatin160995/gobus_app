import 'package:gobus_app/core/api/api_client.dart';
import 'package:gobus_app/core/api/api_response.dart';
import 'package:gobus_app/features/tripSearchDetail/models/trip_details_model.dart';

class TripDetailsApi {
  static Future<ApiResponse<TripDetails>> getTripDetails(
    int scheduleId, {
    String tripType = 'one_way',
    int? returnScheduleId,
  }) {
    final queryParams = {
      'trip_type': tripType,
      if (returnScheduleId != null)
        'return_schedule_id': returnScheduleId.toString(),
    };

    final query = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    return ApiClient.get(
      'trips/$scheduleId/details?$query',
      parser: (json) => TripDetails.fromJson(json),
    );
  }
}
