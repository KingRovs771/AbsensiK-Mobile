import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final String _tokenKey = 'auth_token';

  AuthInterceptor({required this.secureStorage});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Baca token dari storage
    final token = await secureStorage.read(key: _tokenKey);

    // Jika token ada, tambahkan ke header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Lanjutkan permintaan
    super.onRequest(options, handler);
  }
}
