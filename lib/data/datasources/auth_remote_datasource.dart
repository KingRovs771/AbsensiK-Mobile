import 'package:dio/dio.dart';
import '../../models/AkUsers_Model.dart';
import 'package:jwt_decode/jwt_decode.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<void> logout(String token);

  Future<AkUsersModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;
  final String baseUrl = "http://192.168.151.82:8080/v1";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> logout(String token) async {
    final String endpoint =
        "$baseUrl/auth/logout"; // Sesuaikan dengan endpoint logout Anda

    print("DATASOURCE: Mengirim permintaan POST ke $endpoint untuk logout.");

    try {
      // Lakukan pemanggilan API ke endpoint logout
      // Biasanya, token dikirim melalui Header Authorization
      await client.post(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token di header
          },
        ),
      );
      print("DATASOURCE: Logout di backend berhasil.");
    } on DioException catch (e) {
      print(
          "DATASOURCE: Gagal logout di backend (diabaikan): ${e.response?.data ?? e.message}");
      // Jangan lemparkan 'rethrow' agar proses logout di aplikasi tetap berjalan.
    }
  }

  @override
  Future<String> login(String username, String password) async {
    final String endpoint = "$baseUrl/auth/login";
    try {
      final response = await client.post(endpoint, data: {
        'username': username,
        'password': password,
      });

      return response.data['Token'];
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AkUsersModel> getProfile() async {
    // Sesuaikan dengan endpoint profile Anda, bisa GET atau POST
    final String endpoint = "$baseUrl/auth/getInfo";

    try {
      final response = await client.get(endpoint);

      return AkUsersModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}
