import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/repositories/AuthRepository.dart';
import 'package:dartz/dartz.dart';

class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;
  LogoutUser(this.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
