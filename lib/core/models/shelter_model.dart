enum PetGender {
  male,
  female,
  other;

  static PetGender fromString(String value) {
    switch (value.toLowerCase()) {
      case 'male':
        return PetGender.male;
      case 'female':
        return PetGender.female;
      default:
        return PetGender.other;
    }
  }

  String get displayName {
    switch (this) {
      case PetGender.male:
        return 'Male';
      case PetGender.female:
        return 'Female';
      case PetGender.other:
        return 'Other';
    }
  }
}

class ShelterPet {
  final int id;
  final int shelterId;
  final String name;
  final String species;
  final String breed;
  final int age;
  final PetGender gender;
  final String photo;
  final String description;
  final String healthStatus;
  final AdoptionStatus adoptionStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShelterPet({
    required this.id,
    required this.shelterId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.photo,
    required this.description,
    required this.healthStatus,
    required this.adoptionStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShelterPet.fromMap(Map<String, dynamic> map) {
    return ShelterPet(
      id: map['id'],
      shelterId: map['shelter_id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'] ?? '',
      age: map['age'] ?? 0,
      gender: PetGender.fromString(map['gender'] ?? 'other'),
      photo: map['photo'] ?? '',
      description: map['description'] ?? '',
      healthStatus: map['health_status'] ?? 'Unknown',
      adoptionStatus: AdoptionStatus.fromString(map['adoption_status']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shelter_id': shelterId,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'gender': gender.toString().split('.').last,
      'photo': photo,
      'description': description,
      'health_status': healthStatus,
      'adoption_status': adoptionStatus.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ShelterPet copyWith({
    int? id,
    int? shelterId,
    String? name,
    String? species,
    String? breed,
    int? age,
    PetGender? gender,
    String? photo,
    String? description,
    String? healthStatus,
    AdoptionStatus? adoptionStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShelterPet(
      id: id ?? this.id,
      shelterId: shelterId ?? this.shelterId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      healthStatus: healthStatus ?? this.healthStatus,
      adoptionStatus: adoptionStatus ?? this.adoptionStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum AdoptionStatus {
  available,
  pending,
  adopted;

  static AdoptionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AdoptionStatus.available;
      case 'pending':
        return AdoptionStatus.pending;
      case 'adopted':
        return AdoptionStatus.adopted;
      default:
        return AdoptionStatus.available;
    }
  }

  String get displayName {
    switch (this) {
      case AdoptionStatus.available:
        return 'Available';
      case AdoptionStatus.pending:
        return 'Pending';
      case AdoptionStatus.adopted:
        return 'Adopted';
    }
  }
}

class AdoptionRequest {
  final int id;
  final int shelterPetId;
  final int requesterId;
  final DateTime requestDate;
  final RequestStatus status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdoptionRequest({
    required this.id,
    required this.shelterPetId,
    required this.requesterId,
    required this.requestDate,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdoptionRequest.fromMap(Map<String, dynamic> map) {
    return AdoptionRequest(
      id: map['id'],
      shelterPetId: map['shelter_pet_id'],
      requesterId: map['requester_id'],
      requestDate: DateTime.parse(map['request_date']),
      status: RequestStatus.fromString(map['status']),
      notes: map['notes'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shelter_pet_id': shelterPetId,
      'requester_id': requesterId,
      'request_date': requestDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AdoptionRequest copyWith({
    int? id,
    int? shelterPetId,
    int? requesterId,
    DateTime? requestDate,
    RequestStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdoptionRequest(
      id: id ?? this.id,
      shelterPetId: shelterPetId ?? this.shelterPetId,
      requesterId: requesterId ?? this.requesterId,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum RequestStatus {
  pending,
  approved,
  rejected;

  static RequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'approved':
        return RequestStatus.approved;
      case 'rejected':
        return RequestStatus.rejected;
      default:
        return RequestStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }
}

