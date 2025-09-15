import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/features/appointments/models/appointment_model.dart';
import 'package:pawfect_care/core/services/user_service.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  final UserService _userService = UserService();
  
  AppointmentNotifier() : super([]) {
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final appointmentsData = await _userService.getAppointments();
      final appointments = appointmentsData.map((data) => Appointment.fromMap(data)).toList();
      
      if (mounted) {
        state = appointments;
      }
    } catch (e) {
      print('Failed to load appointments: $e');
      if (mounted) {
        state = [];
      }
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _userService.addAppointment(appointment.toMap());
      
      // Update local state
      state = [...state, appointment];
    } catch (e) {
      print('Failed to add appointment: $e');
      rethrow;
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _userService.updateAppointment(appointment.id, appointment.toMap());
      
      // Update local state
      final index = state.indexWhere((apt) => apt.id == appointment.id);
      if (index != -1) {
        state = [
          ...state.sublist(0, index),
          appointment,
          ...state.sublist(index + 1),
        ];
      }
    } catch (e) {
      print('Failed to update appointment: $e');
      rethrow;
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _userService.cancelAppointment(appointmentId);
      
      // Update local state
      final index = state.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        final updatedAppointment = state[index].copyWith(
          status: AppointmentStatus.cancelled,
          updatedAt: DateTime.now(),
        );
        state = [
          ...state.sublist(0, index),
          updatedAppointment,
          ...state.sublist(index + 1),
        ];
      }
    } catch (e) {
      print('Failed to cancel appointment: $e');
      rethrow;
    }
  }

  void refresh() {
    _loadAppointments();
  }
}

final appointmentsProvider = StateNotifierProvider<AppointmentNotifier, List<Appointment>>(
  (ref) => AppointmentNotifier(),
);

// Individual appointment provider
final appointmentProvider = Provider.family<Appointment?, String>((ref, appointmentId) {
  final appointments = ref.watch(appointmentsProvider);
  try {
    return appointments.firstWhere((apt) => apt.id == appointmentId);
  } catch (e) {
    return null;
  }
});
