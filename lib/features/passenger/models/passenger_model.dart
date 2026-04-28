class PassengerModel {
  final int id;
  final int userId;
  final String name;
  final String? phone;
  final String gender;
  final String? idNumber;
  final bool isDefault;
  final DateTime createdAt;

  PassengerModel({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    required this.gender,
    this.idNumber,
    required this.isDefault,
    required this.createdAt,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      phone: json['phone'],
      gender: json['gender'] ?? 'male',
      idNumber: json['id_number'],
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'gender': gender,
    'id_number': idNumber,
    'is_default': isDefault,
  };

  PassengerModel copyWith({
    int? id,
    int? userId,
    String? name,
    String? phone,
    String? gender,
    String? idNumber,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return PassengerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      idNumber: idNumber ?? this.idNumber,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Display label for gender
  String get genderLabel {
    switch (gender) {
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Male';
    }
  }

  /// Short initials for avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
