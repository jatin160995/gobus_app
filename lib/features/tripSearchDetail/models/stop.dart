class Stop {
  final int cityId;
  final String cityName;
  final String cityCode;
  final String arrivalTime;
  final String departureTime;
  final int sequence;

  Stop({
    required this.cityId,
    required this.cityName,
    required this.cityCode,
    required this.arrivalTime,
    required this.departureTime,
    required this.sequence,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      cityId: json['city_id'] ?? 0,
      cityName: json['city_name'] ?? '',
      cityCode: json['city_code'] ?? '',
      arrivalTime: json['arrival_time'] ?? '',
      departureTime: json['departure_time'] ?? '',
      sequence: json['sequence'] ?? 0,
    );
  }
}
