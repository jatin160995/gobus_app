class City {
  final int id;
  final String name;
  final String code;

  City({required this.id, required this.name, required this.code});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: (json['city_id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      code: json['city_code'] ?? '',
    );
  }
}
