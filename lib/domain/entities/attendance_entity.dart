import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceDataEntity extends Equatable {
  final LatLng officeLocation;
  final double officeRadius;
  final String workSchedule;
  final String? clockInTime;
  final String? clockOutTime;
  final String lateDuration;
  final String earlyLeaveDuration;
  final bool canClockIn;
  final bool canClockOut;
  // Properti yang bisa berubah
  final LatLng? userLocation;
  final double? gpsAccuracy;
  final bool isInRadius;

  const AttendanceDataEntity({
    required this.officeLocation,
    required this.officeRadius,
    required this.workSchedule,
    this.clockInTime,
    this.clockOutTime,
    required this.lateDuration,
    required this.earlyLeaveDuration,
    required this.canClockIn,
    required this.canClockOut,
    this.userLocation,
    this.gpsAccuracy,
    required this.isInRadius,
  });

  @override
  List<Object?> get props => [
        officeLocation,
        officeRadius,
        workSchedule,
        clockInTime,
        clockOutTime,
        lateDuration,
        earlyLeaveDuration,
        canClockIn,
        canClockOut,
        userLocation,
        gpsAccuracy,
        isInRadius
      ];
}
