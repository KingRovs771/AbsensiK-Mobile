import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/data/datasources/auth_local_datasource.dart';
import 'package:absensi_alma/data/datasources/permit_remote_datasource.dart';
import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/domain/repositories/PermitRepository.dart';
import 'package:absensi_alma/domain/usecases/submit_permit.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

class PermitRepositoryImpl implements PermitRepository {
  final PermitRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  PermitRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, void>> submitPermit(PermitParams params) async {
    try {
      final formattedStartDate =
          DateFormat('yyyy-MM-dd').format(params.startDate);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(params.endDate);

      await remoteDataSource.submitPermit(
        userUID: params.userUID, // <-- GUNAKAN LANGSUNG DARI PARAMS
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        reason: params.reason,
        permitType: params.permitType,
        photo: params.photo,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PermitEntity>>> getPermitHistory() async {
    try {
      // Ambil token dari penyimpanan lokal
      final token = await localDataSource.getToken();
      final result = await remoteDataSource.getPermitHistory(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return Left(
          CacheFailure(message: "Sesi tidak valid, silakan login ulang"));
    }
  }
}
