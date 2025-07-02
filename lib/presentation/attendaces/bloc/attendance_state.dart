import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceReady extends AttendanceState {
  // Semua data yang dibutuhkan UI ada di sini
  final LatLng officeLocation;
  final double officeRadius;
  final LatLng userLocation;
  final double gpsAccuracy;
  final bool isInRadius;
  final String todayDate;
  final String serverTime;
  final String workSchedule;
  final String? clockInTime;
  final String? clockOutTime;
  final String lateDuration;
  final String earlyLeaveDuration;
  final bool canClockIn;
  final bool canClockOut;

  AttendanceReady({
    required this.officeRadius,
    required this.userLocation,
    required this.gpsAccuracy,
    required this.isInRadius,
    required this.todayDate,
    required this.serverTime,
    required this.workSchedule,
    required this.clockInTime,
    required this.clockOutTime,
    required this.lateDuration,
    required this.earlyLeaveDuration,
    required this.canClockIn,
    required this.canClockOut,
    required this.officeLocation,
  });
}

class AttendanceSubmitting extends AttendanceReady {
  // Mewarisi semua properti dari AttendanceReady agar UI tidak error
  AttendanceSubmitting({
    required super.officeLocation,
    required super.officeRadius,
    required super.userLocation,
    required super.gpsAccuracy,
    required super.isInRadius,
    required super.todayDate,
    required super.serverTime,
    required super.workSchedule,
    required super.clockInTime,
    required super.clockOutTime,
    required super.lateDuration,
    required super.earlyLeaveDuration,
    required super.canClockIn,
    required super.canClockOut,
  });
}

class AttendanceSuccess extends AttendanceState {
  final String message;
  AttendanceSuccess({required this.message});
}

class AttendanceFailure extends AttendanceState {
  final String message;
  AttendanceFailure({required this.message});
}
