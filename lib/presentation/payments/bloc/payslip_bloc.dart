import 'package:absensi_alma/domain/entities/payslip_entity.dart';
import 'package:absensi_alma/domain/usecases/get_latest_payslip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'payslip_event.dart';
part 'payslip_state.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  final GetLatestPayslip getLatestPayslip;
  PayslipBloc({required this.getLatestPayslip}) : super(PayslipInitial()) {
    on<FetchLatestPayslip>((event, emit) async {
      emit(PayslipLoading());
      final result = await getLatestPayslip();
      result.fold(
        (failure) => emit(PayslipFailure(message: failure.message)),
        (payslip) => emit(PayslipLoaded(payslip: payslip)),
      );
    });
  }
}
