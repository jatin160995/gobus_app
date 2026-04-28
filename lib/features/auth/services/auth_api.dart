import 'package:gobus_app/core/api/api_client.dart';
import 'package:gobus_app/core/api/api_constants.dart';
import 'package:gobus_app/core/api/api_response.dart';
import 'package:gobus_app/core/storage/local_storage.dart';
import '../models/user_model.dart';

class AuthApi {
  static Future<ApiResponse<UserModel>> login({
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.loginUrl,
      body: {
        "username": username,
        "password": password,
        "device_name": "Mobile",
        "device_os": "iOS",
        "device_model": "17",
        "fcm_token": "dummy_fcm_token",
        "app_version": "1.0",
      },
      parser: (data) {
        final token = data['token'];
        LocalStorage.saveToken(token);
        return UserModel.fromJson(data['user']);
      },
    );

    return response;
  }

  static Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return ApiClient.post(
      ApiConstants.registerUrl,
      body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "fcm_token": "registertoken",
        "device_name": "apple",
        "device_os": "iOS",
        "device_model": "17",
        "app_version": "1.0",
      },
      parser: (data) => data, // return full data
    );
  }

  static Future<ApiResponse<void>> verifyOtp({
    required int userId,
    required String otp,
    required String token,
  }) async {
    return ApiClient.post(
      ApiConstants.verifyOtpUrl,
      headers: {"Authorization": "Bearer $token"},
      body: {"user_id": userId.toString(), "otp": otp},
      parser: (_) => null,
    );
  }

  static Future<bool> logout() async {
    final response = await ApiClient.post(
      ApiConstants.logoutUrl,
      body: {}, // No body required
    );

    if (response.status) {
      await LocalStorage.clear();
      return true;
    }
    return false;
  }
}
