import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/attendance_entity.dart';
import 'package:absensi_alma/domain/repositories/AttendanceRepository.dart';
import 'package:dartz/dartz.dart';

class GetAttendanceData implements UseCase<AttendanceDataEntity, NoParams> {
  final AttendanceRepository repository;
  GetAttendanceData(this.repository);

  @override
  Future<Either<Failure, AttendanceDataEntity>> call([NoParams? params]) async {
    return await repository.getAttendanceData();
  }
}
