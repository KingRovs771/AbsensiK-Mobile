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

  // Fungsi untuk mendapatkan lokasi GPS pengguna
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Layanan lokasi dimatikan.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Izin lokasi ditolak.');
    }

    if (permission == LocationPermission.deniedForever)
      return Future.error('Izin lokasi ditolak permanen.');

    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<Either<Failure, AttendanceDataEntity>> getAttendanceData() async {
    try {
      final token = await localDataSource.getToken();
      // Panggil API untuk mendapatkan data dari server
      final attendanceDataModel =
          await remoteDataSource.getAttendanceData(token);
      // Dapatkan lokasi GPS pengguna saat ini
      final userPosition = await _determinePosition();

      // Hitung jarak antara pengguna dan kantor
      final distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          attendanceDataModel.officeLocation.latitude,
          attendanceDataModel.officeLocation.longitude);
      return Right(AttendanceDataEntity(
        officeLocation: attendanceDataModel.officeLocation,
        officeRadius: attendanceDataModel.officeRadius,
        workSchedule: attendanceDataModel.workSchedule,
        clockInTime: attendanceDataModel.clockInTime,
        clockOutTime: attendanceDataModel.clockOutTime,
        lateDuration: attendanceDataModel.lateDuration,
        earlyLeaveDuration: attendanceDataModel.earlyLeaveDuration,
        canClockIn: attendanceDataModel.canClockIn,
        canClockOut: attendanceDataModel.canClockOut,
        userLocation: LatLng(userPosition.latitude, userPosition.longitude),
        gpsAccuracy: userPosition.accuracy,
        isInRadius: distance <= attendanceDataModel.officeRadius,
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
    try {
      final token = await localDataSource.getToken();
      final position = await _determinePosition();
      final message = await remoteDataSource.clockOut(token, position);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
