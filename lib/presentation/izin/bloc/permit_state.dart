part of 'permit_bloc.dart';

abstract class PermitState extends Equatable {
  const PermitState();
  @override
  List<Object> get props => [];
}

class PermitInitial extends PermitState {}

class PermitLoading extends PermitState {}

class PermitSuccess extends PermitState {}

class PermitFailure extends PermitState {
  final String message;
  const PermitFailure({required this.message});
  @override
  List<Object> get props => [message];
}
