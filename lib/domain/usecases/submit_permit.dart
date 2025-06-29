import 'dart:io';

import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/repositories/PermitRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SubmitPermit implements UseCase<void, PermitParams> {
  final PermitRepository repository;
  SubmitPermit(this.repository);

  @override
  Future<Either<Failure, void>> call(PermitParams params) async {
    return await repository.submitPermit(params);
  }
}

class PermitParams extends Equatable {
  final String userUID;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String permitType;
  final File? photo;

  const PermitParams(
      {required this.userUID,
      required this.startDate,
      required this.endDate,
      required this.reason,
      required this.photo,
      required this.permitType});
  @override
  List<Object?> get props =>
      [userUID, startDate, endDate, reason, permitType, photo];
}
