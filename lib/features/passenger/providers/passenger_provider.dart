import 'package:flutter/foundation.dart';
import 'package:gobus_app/features/passenger/models/passenger_model.dart';
import 'package:gobus_app/features/passenger/services/passenger_api.dart';

class PassengerProvider extends ChangeNotifier {
  List<PassengerModel> _passengers = [];
  bool isLoading = false;
  bool isSaving = false;
  bool isDeleting = false;
  String? error;

  List<PassengerModel> get passengers => _passengers;

  List<PassengerModel> get sorted {
    final list = List<PassengerModel>.from(_passengers);
    list.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  // ─── Fetch ────────────────────────────────────────────────────────────────

  Future<void> fetchAll() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await PassengerApi.list();

    if (response.status && response.data != null) {
      _passengers = response.data!;
    } else {
      error = response.message;
    }

    isLoading = false;
    notifyListeners();
  }

  // ─── Create ───────────────────────────────────────────────────────────────

  Future<String?> create({
    required String name,
    String? phone,
    String gender = 'male',
    String? idNumber,
    bool isDefault = false,
  }) async {
    isSaving = true;
    notifyListeners();

    final response = await PassengerApi.create(
      name: name,
      phone: phone,
      gender: gender,
      idNumber: idNumber,
      isDefault: isDefault,
    );

    isSaving = false;

    if (response.status && response.data != null) {
      // If this is set as default, clear all others
      if (isDefault) {
        _passengers =
            _passengers.map((p) => p.copyWith(isDefault: false)).toList();
      }
      _passengers.add(response.data!);
      notifyListeners();
      return null; // success
    }

    notifyListeners();
    return response.message ?? 'Failed to create passenger';
  }

  // ─── Update ───────────────────────────────────────────────────────────────

  Future<String?> update({
    required int id,
    required String name,
    String? phone,
    String gender = 'male',
    String? idNumber,
    bool isDefault = false,
  }) async {
    isSaving = true;
    notifyListeners();

    final response = await PassengerApi.update(
      id: id,
      name: name,
      phone: phone,
      gender: gender,
      idNumber: idNumber,
      isDefault: isDefault,
    );

    isSaving = false;

    if (response.status && response.data != null) {
      // Clear other defaults if this is set as default
      if (isDefault) {
        _passengers =
            _passengers
                .map((p) => p.id == id ? p : p.copyWith(isDefault: false))
                .toList();
      }
      // Replace in list
      final idx = _passengers.indexWhere((p) => p.id == id);
      if (idx != -1) {
        _passengers[idx] = response.data!;
      }
      notifyListeners();
      return null; // success
    }

    notifyListeners();
    return response.message ?? 'Failed to update passenger';
  }

  // ─── Delete ───────────────────────────────────────────────────────────────

  Future<String?> delete(int id) async {
    isDeleting = true;
    notifyListeners();

    final response = await PassengerApi.delete(id);

    isDeleting = false;

    if (response.status) {
      _passengers.removeWhere((p) => p.id == id);
      notifyListeners();
      return null; // success
    }

    notifyListeners();
    return response.message ?? 'Failed to delete passenger';
  }
}
