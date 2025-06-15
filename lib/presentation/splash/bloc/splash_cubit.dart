import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  // Tambahkan secure storage untuk mengecek token
  final FlutterSecureStorage secureStorage;

  SplashCubit({required this.secureStorage}) : super(DisplaySplash());

  void checkAuthStatus() async {
    // Beri jeda agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    try {
      final token = await secureStorage.read(key: 'auth_token');

      if (token != null && token.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
