import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/permit_entity.dart';
import '../../../domain/usecases/get_permit_history.dart';

part 'approval_event.dart';
part 'approval_state.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  final GetPermitHistory getPermitHistory;

  // PERBAIKAN: Tidak perlu lagi AuthBloc di sini
  ApprovalBloc({required this.getPermitHistory}) : super(ApprovalInitial()) {
    on<FetchPermitHistoryRequested>((event, emit) async {
      emit(ApprovalLoading());
      // Memanggil use case tanpa parameter
      final result = await getPermitHistory(NoParams());
      result.fold(
        (failure) => emit(ApprovalFailure(message: failure.message)),
        (permits) => emit(ApprovalLoaded(permits: permits)),
      );
    });
  }
}
