import 'package:flutter/material.dart';
import 'package:gobus_app/data/trip_detail_api.dart';
import 'package:gobus_app/features/tripSearchDetail/models/trip_details_model.dart';

class TripDetailsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  TripDetails? details;

  Future<void> load(int scheduleId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await TripDetailsApi.getTripDetails(scheduleId);

    if (response.status && response.data != null) {
      details = response.data;
    } else {
      error = response.message ?? "Failed to load trip details";
    }

    isLoading = false;
    notifyListeners();
  }
}
