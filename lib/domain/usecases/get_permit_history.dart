import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/domain/repositories/PermitRepository.dart';
import 'package:dartz/dartz.dart';

class GetPermitHistory implements UseCase<List<PermitEntity>, NoParams> {
  final PermitRepository repository;
  GetPermitHistory(this.repository);

  @override
  Future<Either<Failure, List<PermitEntity>>> call(NoParams params) async {
    return await repository.getPermitHistory();
  }
}
