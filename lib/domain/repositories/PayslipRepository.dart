import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/domain/entities/payslip_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PayslipRepository {
  Future<Either<Failure, PayslipEntity>> getLatestPayslip();
}
