import 'package:flutter/foundation.dart';

// Simple placeholder models; later move to lib/models
class Passenger {
  final String name;
  final String phone;
  Passenger({required this.name, required this.phone});
}

class BookingDraft extends ChangeNotifier {
  int? tripId;
  List<Passenger> passengers = [];
  List<String> seats = [];

  void setTrip(int id) {
    tripId = id;
    notifyListeners();
  }

  void addPassenger(Passenger p) {
    passengers.add(p);
    notifyListeners();
  }

  void removePassengerAt(int index) {
    passengers.removeAt(index);
    notifyListeners();
  }

  void toggleSeat(String seat) {
    if (seats.contains(seat))
      seats.remove(seat);
    else
      seats.add(seat);
    notifyListeners();
  }

  void clear() {
    tripId = null;
    passengers.clear();
    seats.clear();
    notifyListeners();
  }
}
