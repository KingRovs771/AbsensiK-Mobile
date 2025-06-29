import 'dart:io';

import 'package:absensi_alma/domain/usecases/submit_permit.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'permit_event.dart';
part 'permit_state.dart';

class PermitBloc extends Bloc<PermitEvent, PermitState> {
  final SubmitPermit submitPermit;
  final AuthBloc authBloc;

  PermitBloc({required this.submitPermit, required this.authBloc})
      : super(PermitInitial()) {
    on<SubmitPermitButtonPressed>((event, emit) async {
      emit(PermitLoading());

      final authState = authBloc.state;
      if (authState is AuthAuthenticated) {
        final result = await submitPermit(
          PermitParams(
            userUID: authState.user.userUID,
            startDate: event.startDate,
            endDate: event.endDate,
            reason: event.reason,
            permitType: event.permitType,
            photo: event.photo,
          ),
        );
        result.fold(
          (failure) => emit(PermitFailure(message: failure.message)),
          (_) => emit(PermitSuccess()),
        );
      } else {
        // Jika user tidak terautentikasi (seharusnya tidak mungkin terjadi), emit error
        emit(const PermitFailure(
            message: "Sesi tidak valid. Silakan login ulang."));
      }
    });
  }
}
