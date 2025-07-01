import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/domain/usecases/submit_permit.dart';
import 'package:dartz/dartz.dart';

abstract class PermitRepository {
  Future<Either<Failure, void>> submitPermit(PermitParams params);
  Future<Either<Failure, List<PermitEntity>>> getPermitHistory();
}
