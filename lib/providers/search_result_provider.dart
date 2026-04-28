import 'package:flutter/material.dart';
import 'package:gobus_app/data/trip_api.dart';
import 'package:gobus_app/data/trip_api.dart' as TripApi;
import 'package:gobus_app/features/search/models/trip.dart';

class SearchResultProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Trip> trips = [];

  Future<void> load({
    required String from,
    required String to,
    required String date,
    required int passengers,
    int children = 0,
    String tripType = 'one_way',
    String? returnDate,
  }) async {
    isLoading = true;
    notifyListeners();

    final response = await TripApi.searchTrips(
      from: from,
      to: to,
      date: date,
      passengers: passengers,
      children: children,
      tripType: tripType,
      returnDate: returnDate,
    );

    if (response.status) trips = response.data!;
    isLoading = false;
    notifyListeners();
  }
}
