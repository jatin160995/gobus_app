class Seat {
  final String seatNumber;
  final String status;

  Seat({required this.seatNumber, required this.status});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatNumber:
          json['seat_number'] ??
          '', //int.tryParse(json['seat_number']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? '',
    );
  }
}
