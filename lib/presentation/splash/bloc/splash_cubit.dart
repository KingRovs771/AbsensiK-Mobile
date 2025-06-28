import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/domain/usecases/get_current_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetCurrentUser getCurrentUser;

  SplashCubit({required this.getCurrentUser}) : super(SplashInitial());

  Future<void> checkAuthentication() async {
    // Beri sedikit jeda agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    final failureOrUser = await getCurrentUser(NoParams());

    failureOrUser.fold(
      (failure) => emit(SplashUnauthenticated()),
      (user) => emit(SplashAuthenticated(user: user)),
    );
  }
}
