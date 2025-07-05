import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/data/datasources/attendance_remote_datasource.dart';
import 'package:absensi_alma/data/datasources/auth_local_datasource.dart';
import 'package:absensi_alma/domain/entities/attendance_entity.dart';
import 'package:absensi_alma/domain/repositories/AttendanceRepository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AttendanceRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  Future<Position> _determinePosition() async {
    // ... (Logika untuk mendapatkan lokasi GPS)
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<Either<Failure, AttendanceDataEntity>> getAttendanceData() async {
    try {
      final token = await localDataSource.getToken();
      final attendanceData = await remoteDataSource.getAttendanceData(token);
      final userPosition = await _determinePosition();

      final distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          attendanceData.officeLocation.latitude,
          attendanceData.officeLocation.longitude);

      return Right(AttendanceDataEntity(
        officeLocation: attendanceData.officeLocation,
        officeRadius: attendanceData.officeRadius,
        workSchedule: attendanceData.workSchedule,
        clockInTime: attendanceData.clockInTime,
        clockOutTime: attendanceData.clockOutTime,
        lateDuration: attendanceData.lateDuration,
        earlyLeaveDuration: attendanceData.earlyLeaveDuration,
        canClockIn: attendanceData.canClockIn,
        canClockOut: attendanceData.canClockOut,
        userLocation: LatLng(userPosition.latitude, userPosition.longitude),
        gpsAccuracy: userPosition.accuracy,
        isInRadius: distance <= attendanceData.officeRadius,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> clockIn(XFile photo) async {
    try {
      final token = await localDataSource.getToken();
      final position = await _determinePosition();
      final message = await remoteDataSource.clockIn(token, photo, position);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> clockOut() async {
    // ... (mirip dengan clockIn)
    return const Right("Absen Pulang berhasil");
  }
}
