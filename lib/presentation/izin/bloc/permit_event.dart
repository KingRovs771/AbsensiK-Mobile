part of 'permit_bloc.dart';

abstract class PermitEvent extends Equatable {
  const PermitEvent();
  @override
  List<Object?> get props => [];
}

class SubmitPermitButtonPressed extends PermitEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String permitType;
  final File? photo;

  const SubmitPermitButtonPressed(
      {required this.photo,
      required this.startDate,
      required this.endDate,
      required this.reason,
      required this.permitType});
  @override
  List<Object?> get props => [startDate, endDate, reason, permitType, photo];
}
