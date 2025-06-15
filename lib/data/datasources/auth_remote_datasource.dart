import 'package:dio/dio.dart';
import '../../models/akusers_model.dart';

abstract class AuthRemoteDataSource {
  Future<(AkusersModel, String)> login(String email, String password);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;
  final String baseUrl = "http://localhost:8080/v1";

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
  Future<(AkusersModel, String)> login(String username, String password) async {
    final String endpoint = "$baseUrl/auth/login";

    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };

    print(
        "DATASOURCE: Mengirim permintaan POST ke $endpoint dengan body: $body");
    try {
      final response = await client.post(endpoint, data: body);
      if (response.statusCode == 200) {
        final responseData = response.data;

        print("DATASOURCE: Menerima respons sukses: $responseData");

        final token = responseData['token'] as String;
        final userMap = {
          "user_id": 0,
          "full_name": responseData['full_name'] ?? 'Nama Tidak Ada',
          "username": username,
          "role_id": "N/A",
          "departments_id": "N/A",
          "dailyrate": 0,
        };

        final user = AkusersModel.fromJson(userMap);
        return (user, token);
      } else {
        throw DioException(
            requestOptions: RequestOptions(path: endpoint),
            message: 'Server Mengembalikan Status ${response.statusCode}',
            response: response);
      }
    } catch (e) {
      print("DATASOURCE: Terjadi error tak terduga saat login: $e");
      rethrow;
    }
  }
}
