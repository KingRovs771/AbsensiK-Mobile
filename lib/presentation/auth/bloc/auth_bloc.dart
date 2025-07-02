import 'dart:developer' as dev;

import 'package:absensi_alma/core/usecase/usecase.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/domain/usecases/get_current_user.dart';
import 'package:absensi_alma/domain/usecases/login_user.dart';
import 'package:absensi_alma/domain/usecases/logout_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      try {
        final failureOrUser = await getCurrentUser(NoParams());
        failureOrUser.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user: user)),
        );
      } catch (e) {
        emit(const AuthFailure(message: 'Gagal memeriksa sesi.'));
      }
    });
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final failureOrUser = await loginUser(
            LoginParams(username: event.username, password: event.password));
        failureOrUser.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
        );
      } catch (e, stacktrace) {
        dev.log("EXCEPTION di LoginButtonPressed",
            error: e, stackTrace: stacktrace, name: "AuthBloc");
        emit(AuthFailure(message: 'Terjadi kesalahan: ${e.toString()}'));
      }
    });

    on<LogoutButtonPressed>((event, emit) async {
      dev.log("AuthBloc: Event LogoutButtonPressed diterima.",
          name: "StateFlow");
      emit(AuthLoading());
      await logoutUser(NoParams());
      dev.log("AuthBloc: Logout -> Sukses. Emitting AuthUnauthenticated.",
          name: "StateFlow");
      emit(AuthUnauthenticated());
    });
  }
}
