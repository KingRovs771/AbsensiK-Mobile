part of 'approval_bloc.dart';

abstract class ApprovalEvent extends Equatable {
  const ApprovalEvent();
  @override
  List<Object> get props => [];
}

class FetchPermitHistoryRequested extends ApprovalEvent {}
