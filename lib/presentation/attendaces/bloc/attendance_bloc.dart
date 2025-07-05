import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/attendance_entity.dart';
import 'package:absensi_alma/domain/usecases/clock_in.dart';
import 'package:absensi_alma/domain/usecases/clock_out.dart';
import 'package:absensi_alma/domain/usecases/get_attendance.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceData getAttendanceData;
  final ClockIn clockIn;
  final ClockOut clockOut;

  AttendanceBloc({
    required this.getAttendanceData,
    required this.clockIn,
    required this.clockOut,
  }) : super(AttendanceInitial()) {
    on<FetchAttendanceData>((event, emit) async {
      emit(AttendanceLoading());
      final result = await getAttendanceData(NoParams());
      result.fold(
        (failure) => emit(AttendanceFailure(message: failure.message)),
        (data) => emit(AttendanceReady(
          data: data,
          serverTime: DateFormat('HH:mm:ss').format(DateTime.now()),
        )),
      );
    });

    on<UpdateServerTime>((event, emit) {
      if (state is AttendanceReady) {
        final currentState = state as AttendanceReady;
        emit(currentState.copyWith(
          serverTime: DateFormat('HH:mm:ss').format(DateTime.now()),
        ));
      }
    });

    on<ClockInButtonPressed>((event, emit) async {
      final currentState = state;
      if (currentState is AttendanceReady) {
        emit(AttendanceSubmitting(
            data: currentState.data, serverTime: currentState.serverTime));
        final result = await clockIn(ClockInParams(photo: event.photo));
        result.fold(
          (failure) => emit(AttendanceFailure(message: failure.message)),
          (message) => emit(AttendanceSuccess(message: message)),
        );
      }
    });

    on<ClockOutButtonPressed>((event, emit) async {
      final currentState = state;
      if (currentState is AttendanceReady) {
        emit(AttendanceSubmitting(
            data: currentState.data, serverTime: currentState.serverTime));
        final result = await clockOut(NoParams());
        result.fold(
          (failure) => emit(AttendanceFailure(message: failure.message)),
          (message) => emit(AttendanceSuccess(message: message)),
        );
      }
    });
  }
}
