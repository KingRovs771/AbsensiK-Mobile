import '../entities/Ak_Users.dart';

abstract class AuthRepository {
  Future<AkUsers> login(String username, String password);
  Future<void> logout();
}
