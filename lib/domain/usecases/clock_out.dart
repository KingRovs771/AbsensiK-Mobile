import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/repositories/AttendanceRepository.dart';
import 'package:dartz/dartz.dart';

class ClockOut implements UseCase<String, NoParams> {
  final AttendanceRepository repository;
  ClockOut(this.repository);

  @override
  Future<Either<Failure, String>> call([NoParams? params]) async {
    return await repository.clockOut();
  }
}
