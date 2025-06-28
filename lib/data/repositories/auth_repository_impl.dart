import 'dart:convert';

import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/core/error/failures.dart';
import 'package:absensi_alma/data/datasources/auth_local_datasource.dart';
import 'package:absensi_alma/data/datasources/auth_remote_datasource.dart';
import 'package:absensi_alma/domain/entities/role_entity.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/domain/repositories/AuthRepository.dart';
import 'package:dartz/dartz.dart';

Map<String, dynamic> _parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw const FormatException('Invalid token');
  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final resp = utf8.decode(base64Url.decode(normalized));
  return json.decode(resp) as Map<String, dynamic>;
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
      String username, String password) async {
    try {
      final token = await remoteDataSource.login(username, password);
      await localDataSource.saveToken(token);

      final user = await remoteDataSource.getUserProfile(token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override // BARU: Implementasi method untuk get current user
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final token = await localDataSource.getToken();
      final user = await remoteDataSource.getUserProfile(token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return Left(CacheFailure(message: "Sesi tidak ditemukan"));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getToken();
      await remoteDataSource.logout(token);
      await localDataSource.clearToken();
      return const Right(null);
    } on ServerException {
      // Jika token tidak ada, anggap saja sudah logout
      return const Right(null);
    } on CacheException {
      // Jika server error, tetap hapus token lokal
      await localDataSource.clearToken();
      return const Right(null);
    }
  }
}
