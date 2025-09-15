enum AppointmentStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

enum AppointmentType {
  checkup,
  vaccination,
  grooming,
  surgery,
  consultation,
  emergency,
}

class Appointment {
  final String id;
  final String petId;
  final String petOwnerId;
  final String? veterinarianId;
  final String? shelterId;
  final AppointmentType type;
  final DateTime scheduledDate;
  final String reason;
  final String? notes;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.petId,
    required this.petOwnerId,
    this.veterinarianId,
    this.shelterId,
    required this.type,
    required this.scheduledDate,
    required this.reason,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'pet_owner_id': petOwnerId,
      'veterinarian_id': veterinarianId,
      'shelter_id': shelterId,
      'type': type.name,
      'scheduled_date': scheduledDate.toIso8601String(),
      'reason': reason,
      'notes': notes,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      petId: map['pet_id'],
      petOwnerId: map['pet_owner_id'],
      veterinarianId: map['veterinarian_id'],
      shelterId: map['shelter_id'],
      type: AppointmentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AppointmentType.checkup,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      scheduledDate: DateTime.parse(map['scheduled_date']),
      reason: map['reason'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Appointment copyWith({
    String? id,
    String? petId,
    String? petOwnerId,
    String? veterinarianId,
    String? shelterId,
    AppointmentType? type,
    DateTime? scheduledDate,
    String? reason,
    String? notes,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      petOwnerId: petOwnerId ?? this.petOwnerId,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      shelterId: shelterId ?? this.shelterId,
      type: type ?? this.type,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isUpcoming => scheduledDate.isAfter(DateTime.now()) && status == AppointmentStatus.confirmed;
  bool get isToday => scheduledDate.day == DateTime.now().day && 
                     scheduledDate.month == DateTime.now().month && 
                     scheduledDate.year == DateTime.now().year;
  bool get isOverdue => scheduledDate.isBefore(DateTime.now()) && status == AppointmentStatus.confirmed;
}
