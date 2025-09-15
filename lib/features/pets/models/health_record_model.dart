enum HealthRecordType {
  vaccination,
  deworming,
  checkup,
  surgery,
  medication,
  allergy,
}

class HealthRecord {
  final String id;
  final String petId;
  final String? veterinarianId;
  final HealthRecordType type;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime? nextDueDate;
  final String? prescription;
  final String? notes;
  final List<String>? attachments; // File paths or URLs
  final DateTime createdAt;
  final DateTime updatedAt;

  HealthRecord({
    required this.id,
    required this.petId,
    this.veterinarianId,
    required this.type,
    required this.title,
    this.description,
    required this.date,
    this.nextDueDate,
    this.prescription,
    this.notes,
    this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'veterinarian_id': veterinarianId,
      'type': type.name,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'next_due_date': nextDueDate?.toIso8601String(),
      'prescription': prescription,
      'notes': notes,
      'attachments': attachments?.join(','),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'],
      petId: map['pet_id'],
      veterinarianId: map['veterinarian_id'],
      type: HealthRecordType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => HealthRecordType.checkup,
      ),
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      nextDueDate: map['next_due_date'] != null ? DateTime.parse(map['next_due_date']) : null,
      prescription: map['prescription'],
      notes: map['notes'],
      attachments: map['attachments']?.split(',').where((s) => s.isNotEmpty).toList(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  HealthRecord copyWith({
    String? id,
    String? petId,
    String? veterinarianId,
    HealthRecordType? type,
    String? title,
    String? description,
    DateTime? date,
    DateTime? nextDueDate,
    String? prescription,
    String? notes,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isDue {
    if (nextDueDate == null) return false;
    return DateTime.now().isAfter(nextDueDate!);
  }

  bool get isUpcoming {
    if (nextDueDate == null) return false;
    final daysUntilDue = nextDueDate!.difference(DateTime.now()).inDays;
    return daysUntilDue <= 30 && daysUntilDue > 0;
  }
}
