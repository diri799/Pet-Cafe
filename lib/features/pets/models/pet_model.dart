class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String species; // Dog, Cat, Bird, etc.
  final String breed;
  final int age; // in months
  final String gender; // Male, Female
  final String? photo;
  final double? weight;
  final String? color;
  final DateTime? birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    this.photo,
    this.weight,
    this.color,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'gender': gender,
      'photo': photo,
      'weight': weight,
      'color': color,
      'birth_date': birthDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      ownerId: map['owner_id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'],
      age: map['age'],
      gender: map['gender'],
      photo: map['photo'],
      weight: map['weight']?.toDouble(),
      color: map['color'],
      birthDate: map['birth_date'] != null ? DateTime.parse(map['birth_date']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Pet copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    String? photo,
    double? weight,
    String? color,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pet(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
