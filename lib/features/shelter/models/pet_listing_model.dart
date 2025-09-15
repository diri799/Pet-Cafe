enum AdoptionStatus {
  available,
  pending,
  adopted,
  unavailable,
}

class PetListing {
  final String id;
  final String shelterId;
  final String name;
  final String species;
  final String breed;
  final int age; // in months
  final String gender;
  final String description;
  final List<String> photos;
  final AdoptionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PetListing({
    required this.id,
    required this.shelterId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.description,
    required this.photos,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shelter_id': shelterId,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'gender': gender,
      'description': description,
      'photos': photos.join(','),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PetListing.fromMap(Map<String, dynamic> map) {
    return PetListing(
      id: map['id'],
      shelterId: map['shelter_id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'],
      age: map['age'],
      gender: map['gender'],
      description: map['description'],
      photos: map['photos']?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      status: AdoptionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AdoptionStatus.available,
      ),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  PetListing copyWith({
    String? id,
    String? shelterId,
    String? name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    String? description,
    List<String>? photos,
    AdoptionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PetListing(
      id: id ?? this.id,
      shelterId: shelterId ?? this.shelterId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdoptionRequest {
  final String id;
  final String petListingId;
  final String adopterId;
  final String adopterName;
  final String adopterEmail;
  final String adopterPhone;
  final String message;
  final DateTime requestDate;
  final String status; // pending, approved, rejected

  AdoptionRequest({
    required this.id,
    required this.petListingId,
    required this.adopterId,
    required this.adopterName,
    required this.adopterEmail,
    required this.adopterPhone,
    required this.message,
    required this.requestDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_listing_id': petListingId,
      'adopter_id': adopterId,
      'adopter_name': adopterName,
      'adopter_email': adopterEmail,
      'adopter_phone': adopterPhone,
      'message': message,
      'request_date': requestDate.toIso8601String(),
      'status': status,
    };
  }

  factory AdoptionRequest.fromMap(Map<String, dynamic> map) {
    return AdoptionRequest(
      id: map['id'],
      petListingId: map['pet_listing_id'],
      adopterId: map['adopter_id'],
      adopterName: map['adopter_name'],
      adopterEmail: map['adopter_email'],
      adopterPhone: map['adopter_phone'],
      message: map['message'],
      requestDate: DateTime.parse(map['request_date']),
      status: map['status'],
    );
  }
}
