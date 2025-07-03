import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/data/datasources/auth_local_datasource.dart';
import 'package:absensi_alma/data/datasources/payslip_remote_datasource.dart';
import 'package:absensi_alma/domain/entities/payslip_entity.dart';
import 'package:absensi_alma/domain/repositories/PayslipRepository.dart';
import 'package:dartz/dartz.dart';

class PayslipRepositoryImpl implements PayslipRepository {
  final PayslipRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  PayslipRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, PayslipEntity>> getLatestPayslip() async {
    try {
      final token = await localDataSource.getToken();
      final payslip = await remoteDataSource.getLatestPayslip(token);
      return Right(payslip);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return Left(CacheFailure(message: 'Sesi tidak valid'));
    }
  }
}
