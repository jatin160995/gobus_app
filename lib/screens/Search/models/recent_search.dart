class RecentSearch {
  final int fromId;
  final int toId;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final DateTime date;
  final String transport;

  final bool? isRoundTrip;
  final DateTime? returnDate;
  final int? pickupHour;
  final int? pickupMinute;
  final int? passengers;

  RecentSearch({
    required this.fromId,
    required this.toId,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.date,
    required this.transport,

    this.isRoundTrip,
    this.returnDate,
    this.pickupHour,
    this.pickupMinute,
    this.passengers,
  });

  /// ---------- JSON SERIALIZATION ----------

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch(
      fromId: json['from_id'],
      toId: json['to_id'],
      fromCode: json['from_code'],
      fromName: json['from_name'],
      toCode: json['to_code'],
      toName: json['to_name'],
      date: DateTime.parse(json['date']),
      transport: json['transport'],

      isRoundTrip: json["isRoundTrip"] ?? false,
      returnDate:
          json["returnDate"] != null
              ? DateTime.parse(json["returnDate"])
              : null,
      pickupHour: json["pickupHour"],
      pickupMinute: json["pickupMinute"],
      passengers: json["passengers"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_id': fromId,
      'to_id': toId,
      'from_code': fromCode,
      'from_name': fromName,
      'to_code': toCode,
      'to_name': toName,
      'date': date.toIso8601String(),
      'transport': transport,

      "isRoundTrip": isRoundTrip,
      "returnDate": returnDate?.toIso8601String(),
      "pickupHour": pickupHour,
      "pickupMinute": pickupMinute,
      "passengers": passengers,
    };
  }
}
