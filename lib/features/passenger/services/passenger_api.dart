import 'package:gobus_app/core/api/api_client.dart';
import 'package:gobus_app/core/api/api_response.dart';
import 'package:gobus_app/features/passenger/models/passenger_model.dart';

class PassengerApi {
  static const String _base = 'passengers';

  /// GET /api/passengers
  static Future<ApiResponse<List<PassengerModel>>> list() {
    return ApiClient.get(
      _base,
      parser:
          (json) =>
              (json as List).map((e) => PassengerModel.fromJson(e)).toList(),
    );
  }

  /// POST /api/passengers
  static Future<ApiResponse<PassengerModel>> create({
    required String name,
    String? phone,
    String gender = 'male',
    String? idNumber,
    bool isDefault = false,
  }) {
    return ApiClient.post(
      _base,
      body: {
        'name': name,
        'phone': phone,
        'gender': gender,
        'id_number': idNumber,
        'is_default': isDefault,
      },
      parser: (json) => PassengerModel.fromJson(json),
    );
  }

  /// PUT /api/passengers/{id}
  static Future<ApiResponse<PassengerModel>> update({
    required int id,
    required String name,
    String? phone,
    String gender = 'male',
    String? idNumber,
    bool isDefault = false,
  }) {
    return ApiClient.put(
      '$_base/$id',
      body: {
        'name': name,
        'phone': phone,
        'gender': gender,
        'id_number': idNumber,
        'is_default': isDefault,
      },
      parser: (json) => PassengerModel.fromJson(json),
    );
  }

  /// DELETE /api/passengers/{id}
  static Future<ApiResponse<void>> delete(int id) {
    return ApiClient.delete('$_base/$id');
  }
}
