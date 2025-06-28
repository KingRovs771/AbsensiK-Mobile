import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String> getToken();
  Future<void> clearToken();
}

const CACHED_AUTH_TOKEN = 'secretya';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(CACHED_AUTH_TOKEN);
  }

  @override
  Future<String> getToken() {
    final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    if (token != null) {
      return Future.value(token);
    } else {
      throw ServerException(message: "Token tidak ditemukan");
    }
  }

  @override
  Future<void> saveToken(String token) {
    return sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
  }
}
