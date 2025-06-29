part of 'approval_bloc.dart';

abstract class ApprovalState extends Equatable {
  const ApprovalState();
  @override
  List<Object> get props => [];
}

class ApprovalInitial extends ApprovalState {}

class ApprovalLoading extends ApprovalState {}

class ApprovalLoaded extends ApprovalState {
  final List<PermitEntity> permits;
  const ApprovalLoaded({required this.permits});
  @override
  List<Object> get props => [permits];
}

class ApprovalFailure extends ApprovalState {
  final String message;
  const ApprovalFailure({required this.message});
  @override
  List<Object> get props => [message];
}
