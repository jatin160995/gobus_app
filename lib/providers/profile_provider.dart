import 'package:flutter/foundation.dart';
import 'package:gobus_app/data/profile_api.dart';
import 'package:gobus_app/features/auth/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  UserModel? profile;
  String? error;

  Future<void> fetchProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await ProfileApi.getProfile();

    if (response.status) {
      profile = response.data;
    } else {
      error = response.message;
    }

    isLoading = false;
    notifyListeners();
  }
}
