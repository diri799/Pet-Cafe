class Appointment {
  final int id;
  final int petId;
  final int? veterinarianId;
  final int? shelterId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AppointmentStatus status;
  final String reason;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.petId,
    this.veterinarianId,
    this.shelterId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.reason,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      petId: map['pet_id'],
      veterinarianId: map['veterinarian_id'],
      shelterId: map['shelter_id'],
      appointmentDate: DateTime.parse(map['appointment_date']),
      appointmentTime: map['appointment_time'],
      status: AppointmentStatus.fromString(map['status']),
      reason: map['reason'] ?? '',
      notes: map['notes'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'veterinarian_id': veterinarianId,
      'shelter_id': shelterId,
      'appointment_date': appointmentDate.toIso8601String(),
      'appointment_time': appointmentTime,
      'status': status.toString().split('.').last,
      'reason': reason,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Appointment copyWith({
    int? id,
    int? petId,
    int? veterinarianId,
    int? shelterId,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentStatus? status,
    String? reason,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      shelterId: shelterId ?? this.shelterId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DateTime get fullDateTime {
    final dateTimeStr =
        '${appointmentDate.toIso8601String().split('T')[0]} $appointmentTime';
    return DateTime.parse(dateTimeStr);
  }
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  rescheduled;

  static AppointmentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'rescheduled':
        return AppointmentStatus.rescheduled;
      default:
        return AppointmentStatus.scheduled;
    }
  }

  String get displayName {
    switch (this) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }
}
