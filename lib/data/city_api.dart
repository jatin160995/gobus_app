import 'package:gobus_app/features/search/models/city.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_response.dart';

class CityApi {
  static Future<ApiResponse<List<City>>> searchCity(String query) {
    return ApiClient.get(
      query.length > 0 ? "cities/search?q=$query" : "cities/search",
      // "cities/search?q=$query",
      parser: (json) => (json as List).map((e) => City.fromJson(e)).toList(),
    );
  }
}
