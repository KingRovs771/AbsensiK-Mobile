import 'package:absensi_alma/domain/entities/attendance_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceDataModel extends AttendanceDataEntity {
  const AttendanceDataModel({
    required super.officeLocation,
    required super.officeRadius,
    required super.workSchedule,
    super.clockInTime,
    super.clockOutTime,
    required super.lateDuration,
    required super.earlyLeaveDuration,
    required super.canClockIn,
    required super.canClockOut,
    required super.isInRadius,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    final schedule = json['schedule'] ?? {};
    final attendance = json['attendance'] ?? {};
    final office = json['office_location'] ?? {};

    return AttendanceDataModel(
      officeLocation: LatLng(
        (office['latitude'] as num?)?.toDouble() ?? 0.0,
        (office['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
      officeRadius: (office['radius'] as num?)?.toDouble() ?? 100.0,
      workSchedule:
          "${schedule['start_time'] ?? '--:--'} - ${schedule['end_time'] ?? '--:--'}",
      clockInTime: attendance['time_in'],
      clockOutTime: attendance['time_out'],
      lateDuration: json['late_duration'] ?? '0 menit',
      earlyLeaveDuration: json['early_leave_duration'] ?? '0 menit',
      canClockIn: json['can_clock_in'] ?? false,
      canClockOut: json['can_clock_out'] ?? false,
      isInRadius: false, // Nilai awal, akan di-update oleh repository
    );
  }
}
