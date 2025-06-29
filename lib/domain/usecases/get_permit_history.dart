import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/domain/repositories/PermitRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetPermitHistory
    implements UseCase<List<PermitEntity>, GetPermitHistoryParams> {
  final PermitRepository repository;
  GetPermitHistory(this.repository);

  @override
  Future<Either<Failure, List<PermitEntity>>> call(
      GetPermitHistoryParams params) async {
    return await repository.getPermitHistory(params);
  }
}

// Tambahkan class untuk parameter
class GetPermitHistoryParams extends Equatable {
  final String userUid;
  const GetPermitHistoryParams({required this.userUid});
  @override
  List<Object?> get props => [userUid];
}
