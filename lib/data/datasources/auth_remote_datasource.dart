import 'dart:convert';

import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/data/models/AkUsers_Model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
  Future<AkUsersModel> getUserProfile(String token);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://absensik-backend-production.up.railway.app";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<String> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['Status'] == 'Success' &&
          responseData['Token'] != null) {
        return responseData['Token'];
      } else {
        throw ServerException(
            message: responseData['Message'] ?? 'Login Gagal');
      }
    } else {
      throw ServerException(message: 'Username atau Password Salah');
    }
  }

  @override
  Future<AkUsersModel> getUserProfile(String token) async {
    // PENTING: Ganti '/api/user/profile' dengan endpoint Anda yang sebenarnya
    final response = await client.get(
      Uri.parse('$_baseUrl/v1/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Asumsikan backend mengembalikan data user di dalam key 'data'
      return AkUsersModel.fromJson(responseData['data']);
    } else {
      throw ServerException(message: 'Gagal mengambil data profil');
    }
  }

  @override
  Future<void> logout(String token) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/v1/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      // Kita bisa mengabaikan error di sini, karena yang penting adalah
      // token di client terhapus. Atau bisa juga log error-nya.
      print("Error saat logout di server: ${response.body}");
    }
  }
}
