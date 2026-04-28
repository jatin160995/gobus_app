import 'package:flutter/material.dart';
import 'package:gobus_app/data/city_api.dart';
import 'package:gobus_app/features/search/models/city.dart';

class CitySearchProvider extends ChangeNotifier {
  List<City> results = [];
  bool isLoading = false;

  Future<void> search(String query) async {
    // if (query.length < 2) {
    //   results = [];
    //   notifyListeners();
    //   return;
    // }

    isLoading = true;
    notifyListeners();

    final response = await CityApi.searchCity(query);

    if (response.status) {
      results = response.data!;
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    results = [];
    notifyListeners();
  }
}
