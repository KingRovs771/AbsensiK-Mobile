import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../entities/Ak_Users.dart';
import 'AuthRepository.dart';
import '../../../data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final String _tokenKey = 'secretyaa';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<AkUsers> login(String username, String password) async {
    try {
      // 1. Panggil API login untuk dapat token
      final token = await remoteDataSource.login(username, password);

      // 2. Simpan token ke penyimpanan lokal
      await secureStorage.write(key: _tokenKey, value: token);

      print("REPOSITORY: Mencoba menulis token ke storage.");
      final tokenYangBaruDisimpan = await secureStorage.read(key: _tokenKey);
      print(
          "REPOSITORY: Verifikasi setelah tulis, token yang terbaca: $tokenYangBaruDisimpan");
      final user = await remoteDataSource.getProfile();
      print("REPOSITORY: Objek User berhasil dibuat: ${user.toString()}");
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
  }
}
