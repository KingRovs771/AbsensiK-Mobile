import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/payslip_entity.dart';
import 'package:absensi_alma/domain/repositories/PayslipRepository.dart';
import 'package:dartz/dartz.dart';

class GetLatestPayslip implements UseCase<PayslipEntity, NoParams> {
  final PayslipRepository repository;
  GetLatestPayslip(this.repository);

  @override
  Future<Either<Failure, PayslipEntity>> call([NoParams? params]) async {
    return await repository.getLatestPayslip();
  }
}
