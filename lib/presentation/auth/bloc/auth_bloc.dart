import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/Auth/entities/Ak_Users.dart';
import '../../../domain/Auth/repositories/AuthRepository.dart'; // Impor repository

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(event.username, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      // Di dunia nyata, Anda akan mem-parse error dari DioException
      emit(const AuthFailure(
          message: "Login Gagal. Periksa kembali email dan password."));
    }
  }

  void _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Meskipun logout gagal, paksa ke state unauthenticated
      // agar pengguna bisa mencoba login lagi.
      emit(AuthUnauthenticated());
    }
  }
}
