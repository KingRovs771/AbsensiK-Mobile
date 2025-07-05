import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/repositories/AttendanceRepository.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';

class ClockIn implements UseCase<String, ClockInParams> {
  final AttendanceRepository repository;
  ClockIn(this.repository);

  @override
  Future<Either<Failure, String>> call(ClockInParams params) async {
    return await repository.clockIn(params.photo);
  }
}

class ClockInParams {
  final XFile photo;
  ClockInParams({required this.photo});
}
