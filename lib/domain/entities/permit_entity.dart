import 'package:equatable/equatable.dart';

class PermitEntity extends Equatable {
  final int id;
  final String userUID;
  final String startDate;
  final String endDate;
  final String permitType;
  final String reason;
  final String status;

  const PermitEntity({
    required this.id,
    required this.userUID,
    required this.startDate,
    required this.endDate,
    required this.permitType,
    required this.reason,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [id, userUID, startDate, endDate, permitType, reason, status];
}
