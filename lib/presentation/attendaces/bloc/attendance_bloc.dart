import 'package:absensi_alma/presentation/attendaces/bloc/attendance_event.dart';
import 'package:absensi_alma/presentation/attendaces/bloc/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  // ... dependencies ke use cases
  AttendanceBloc(/*...*/) : super(AttendanceInitial()) {
    on<FetchAttendanceData>((event, emit) async {
      // Panggil use case, dapatkan semua data, emit AttendanceReady atau AttendanceFailure
    });
    on<ClockInButtonPressed>((event, emit) async {
      // Dapatkan state saat ini
      final currentState = state;
      if (currentState is AttendanceReady) {
        // Emit state submitting dengan membawa data lama agar UI tidak berkedip
        emit(AttendanceSubmitting(
          officeLocation: currentState.officeLocation,
          officeRadius: currentState.officeRadius,
          userLocation: currentState.userLocation,
          gpsAccuracy: currentState.gpsAccuracy,
          isInRadius: currentState.isInRadius,
          todayDate: currentState.todayDate,
          serverTime: currentState.serverTime,
          workSchedule: currentState.workSchedule,
          clockInTime: currentState.clockInTime,
          clockOutTime: currentState.clockOutTime,
          lateDuration: currentState.lateDuration,
          earlyLeaveDuration: currentState.earlyLeaveDuration,
          canClockIn: currentState.canClockIn,
          canClockOut: currentState.canClockOut,
        ));
        // Panggil use case clock in, lalu emit success/failure
      }
    });
    on<ClockOutButtonPressed>((event, emit) async {
      // Mirip dengan ClockInButtonPressed
    });
  }
}
