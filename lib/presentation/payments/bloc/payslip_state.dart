part of 'payslip_bloc.dart';

abstract class PayslipState extends Equatable {
  const PayslipState();
  @override
  List<Object> get props => [];
}

class PayslipInitial extends PayslipState {}

class PayslipLoading extends PayslipState {}

class PayslipLoaded extends PayslipState {
  final PayslipEntity payslip;
  const PayslipLoaded({required this.payslip});
  @override
  List<Object> get props => [payslip];
}

class PayslipFailure extends PayslipState {
  final String message;
  const PayslipFailure({required this.message});
  @override
  List<Object> get props => [message];
}
