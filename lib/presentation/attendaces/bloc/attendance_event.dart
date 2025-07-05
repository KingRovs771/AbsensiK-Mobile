part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object> get props => [];
}

class FetchAttendanceData extends AttendanceEvent {}

class UpdateServerTime extends AttendanceEvent {}

class ClockInButtonPressed extends AttendanceEvent {
  final XFile photo;
  const ClockInButtonPressed({required this.photo});
  @override
  List<Object> get props => [photo];
}

class ClockOutButtonPressed extends AttendanceEvent {}
