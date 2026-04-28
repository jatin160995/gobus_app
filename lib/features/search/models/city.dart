class City {
  final int id;
  final String name;
  final String code;
  final String country;
  final String label;

  City({
    required this.id,
    required this.name,
    required this.code,
    required this.country,
    required this.label,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      code: json['city_code'],
      country: json['country'],
      label: json['label'],
    );
  }
}
