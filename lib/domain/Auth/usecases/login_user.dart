import '../repositories/AuthRepository.dart';
import '../entities/Ak_Users.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<AkUsers> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
