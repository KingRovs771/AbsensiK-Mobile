import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/domain/entities/attendance_entity.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceDataEntity>> getAttendanceData();
  Future<Either<Failure, String>> clockIn(XFile photo);
  Future<Either<Failure, String>> clockOut();
}
