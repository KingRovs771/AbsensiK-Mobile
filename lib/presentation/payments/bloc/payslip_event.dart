part of 'payslip_bloc.dart';

abstract class PayslipEvent extends Equatable {
  const PayslipEvent();
  @override
  List<Object> get props => [];
}

class FetchLatestPayslip extends PayslipEvent {
  final String userUid;
  const FetchLatestPayslip({required this.userUid});
  @override
  List<Object> get props => [userUid];
}
