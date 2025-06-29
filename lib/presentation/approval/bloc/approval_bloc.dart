import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/domain/usecases/get_permit_history.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'approval_event.dart';
part 'approval_state.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  final GetPermitHistory getPermitHistory;
  final AuthBloc authBloc;

  ApprovalBloc({
    required this.getPermitHistory,
    required this.authBloc,
  }) : super(ApprovalInitial()) {
    on<FetchPermitHistoryRequested>((event, emit) async {
      emit(ApprovalLoading());

      final authState = authBloc.state;
      if (authState is AuthAuthenticated) {
        final result = await getPermitHistory(
          GetPermitHistoryParams(userUid: authState.user.userUID),
        );
        result.fold(
          (failure) => emit(ApprovalFailure(message: failure.message)),
          (permits) => emit(ApprovalLoaded(permits: permits)),
        );
      } else {
        emit(const ApprovalFailure(
            message: "Sesi tidak valid, tidak bisa memuat riwayat."));
      }
    });
  }
}
