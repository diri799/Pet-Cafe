class Pet {
  final int id;
  final int userId;
  final String name;
  final String species;
  final String breed;
  final int age;
  final PetGender gender;
  final String photo;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pet({
    required this.id,
    required this.userId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.photo,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'] ?? '',
      age: map['age'] ?? 0,
      gender: PetGender.fromString(map['gender'] ?? 'other'),
      photo: map['photo'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'gender': gender.toString().split('.').last,
      'photo': photo,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Pet copyWith({
    int? id,
    int? userId,
    String? name,
    String? species,
    String? breed,
    int? age,
    PetGender? gender,
    String? photo,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum PetGender {
  male,
  female,
  other;

  static PetGender fromString(String gender) {
    switch (gender.toLowerCase()) {
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

// Health Record Model
class PetHealthRecord {
  final int id;
  final int petId;
  final int? veterinarianId;
  final DateTime visitDate;
  final String diagnosis;
  final String prescription;
  final String treatmentNotes;
  final DateTime? nextDueDate;
  final HealthRecordType recordType;
  final DateTime createdAt;

  PetHealthRecord({
    required this.id,
    required this.petId,
    this.veterinarianId,
    required this.visitDate,
    required this.diagnosis,
    required this.prescription,
    required this.treatmentNotes,
    this.nextDueDate,
    required this.recordType,
    required this.createdAt,
  });

  factory PetHealthRecord.fromMap(Map<String, dynamic> map) {
    return PetHealthRecord(
      id: map['id'],
      petId: map['pet_id'],
      veterinarianId: map['veterinarian_id'],
      visitDate: DateTime.parse(map['visit_date']),
      diagnosis: map['diagnosis'] ?? '',
      prescription: map['prescription'] ?? '',
      treatmentNotes: map['treatment_notes'] ?? '',
      nextDueDate: map['next_due_date'] != null
          ? DateTime.parse(map['next_due_date'])
          : null,
      recordType: HealthRecordType.fromString(map['record_type']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'veterinarian_id': veterinarianId,
      'visit_date': visitDate.toIso8601String(),
      'diagnosis': diagnosis,
      'prescription': prescription,
      'treatment_notes': treatmentNotes,
      'next_due_date': nextDueDate?.toIso8601String(),
      'record_type': recordType.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum HealthRecordType {
  vaccination,
  checkup,
  treatment,
  deworming;

  static HealthRecordType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'vaccination':
        return HealthRecordType.vaccination;
      case 'checkup':
        return HealthRecordType.checkup;
      case 'treatment':
        return HealthRecordType.treatment;
      case 'deworming':
        return HealthRecordType.deworming;
      default:
        return HealthRecordType.checkup;
    }
  }

  String get displayName {
    switch (this) {
      case HealthRecordType.vaccination:
        return 'Vaccination';
      case HealthRecordType.checkup:
        return 'Checkup';
      case HealthRecordType.treatment:
        return 'Treatment';
      case HealthRecordType.deworming:
        return 'Deworming';
    }
  }
}
