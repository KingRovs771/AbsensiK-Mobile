part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceReady extends AttendanceState {
  final AttendanceDataEntity data;
  final String serverTime;

  const AttendanceReady({required this.data, required this.serverTime});

  AttendanceReady copyWith({
    AttendanceDataEntity? data,
    String? serverTime,
  }) {
    return AttendanceReady(
      data: data ?? this.data,
      serverTime: serverTime ?? this.serverTime,
    );
  }

  @override
  List<Object> get props => [data, serverTime];
}

class AttendanceSubmitting extends AttendanceReady {
  const AttendanceSubmitting({required super.data, required super.serverTime});
}

class AttendanceSuccess extends AttendanceState {
  final String message;
  const AttendanceSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class AttendanceFailure extends AttendanceState {
  final String message;
  const AttendanceFailure({required this.message});
  @override
  List<Object> get props => [message];
}
