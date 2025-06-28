import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String username, String password);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> logout();
}
