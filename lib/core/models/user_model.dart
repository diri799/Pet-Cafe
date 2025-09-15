class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'] ?? '',
      role: UserRole.fromString(map['role']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum UserRole {
  petOwner,
  veterinarian,
  shelterAdmin;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'pet_owner':
        return UserRole.petOwner;
      case 'veterinarian':
        return UserRole.veterinarian;
      case 'shelter_admin':
        return UserRole.shelterAdmin;
      default:
        return UserRole.petOwner;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.petOwner:
        return 'Pet Owner';
      case UserRole.veterinarian:
        return 'Veterinarian';
      case UserRole.shelterAdmin:
        return 'Shelter Admin';
    }
  }

  String get route {
    switch (this) {
      case UserRole.petOwner:
        return '/pet-owner-dashboard';
      case UserRole.veterinarian:
        return '/vet-dashboard';
      case UserRole.shelterAdmin:
        return '/shelter-dashboard';
    }
  }
}
