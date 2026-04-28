import 'package:gobus_app/core/api/api_client.dart';
import 'package:gobus_app/core/api/api_response.dart';
import 'package:gobus_app/features/auth/models/user_model.dart';
import 'package:gobus_app/providers/profile_provider.dart';

class ProfileApi {
  static Future<ApiResponse<UserModel>> getProfile() {
    return ApiClient.get(
      "auth/profile",
      parser: (json) => UserModel.fromJson(json),
    );
  }
}
