import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../entities/Ak_Users.dart';
import 'AuthRepository.dart';
import '../../../data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final String _tokenKey = 'auth_token';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<AkUsers> login(String username, String password) async {
    try {
      final (userModel, token) =
          await remoteDataSource.login(username, password);
      // Simpan token ke secure storage
      await secureStorage.write(key: _tokenKey, value: token);
      return userModel; // UserModel kompatibel dengan User
    } catch (e) {
      // Teruskan error untuk ditangani oleh BLoC
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    String? token;
    try {
      // 1. Baca token dari penyimpanan lokal
      token = await secureStorage.read(key: _tokenKey);

      // 2. Jika token ada, panggil backend untuk invalidate token
      if (token != null) {
        await remoteDataSource.logout(token);
      }
    } catch (e) {
      // Jika terjadi error saat memanggil backend, kita tetap lanjutkan proses logout lokal.
      print(
          "REPOSITORY: Gagal memanggil API logout, tapi tetap melanjutkan: $e");
    } finally {
      // 3. Apapun yang terjadi (berhasil atau gagal), HAPUS token dari perangkat.
      // Ini memastikan pengguna akan selalu logout di aplikasinya.
      await secureStorage.delete(key: _tokenKey);
      print("REPOSITORY: Token lokal berhasil dihapus.");
    }
  }
}
