import 'dart:convert';
import 'dart:io';

import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/data/models/AkIzins_Model.dart';
import 'package:http/http.dart' as http;

abstract class PermitRemoteDataSource {
  Future<void> submitPermit({
    required String userUID,
    required String startDate,
    required String endDate,
    required String reason,
    required String permitType,
    required File? photo,
  });
  Future<List<PermitModel>> getPermitHistory(String token);
}

class PermitRemoteDataSourceImpl implements PermitRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://absensik-backend-production.up.railway.app";

  PermitRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitPermit({
    required String userUID,
    required String startDate,
    required String endDate,
    required String reason,
    required String permitType,
    required File? photo,
  }) async {
    final url = Uri.parse('$_baseUrl/v1/izin/insertIzin');
    var request = http.MultipartRequest('POST', url);

    // Tambahkan semua data teks sebagai fields
    request.fields['user_uid'] = userUID;
    request.fields['start_date'] = startDate;
    request.fields['end_date'] = endDate;
    request.fields['alasan'] = reason;
    request.fields['izin_type'] = permitType;
    request.fields['status'] = '0';

    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'foto',
        imageBytes,
        // Beri nama file, ini bisa diperlukan oleh beberapa framework backend
        filename: 'sakit_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(multipartFile);
    }
    final streamedResponse = await request.send();

    if (streamedResponse.statusCode != 200 &&
        streamedResponse.statusCode != 201) {
      final responseBody = await streamedResponse.stream.bytesToString();
      final responseMap = json.decode(responseBody);
      throw ServerException(
          message: responseMap['Message'] ?? 'Gagal mengirim pengajuan');
    }
  }

  @override
  Future<List<PermitModel>> getPermitHistory(String token) async {
    // PERBAIKAN: Endpoint ini sekarang menggunakan token di header, bukan query param
    final url = Uri.parse('$_baseUrl/v1/izin/getIzinByuserUID');
    final response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => PermitModel.fromJson(json)).toList();
    } else {
      final responseMap = json.decode(response.body);
      throw ServerException(
          message: responseMap['message'] ?? 'Gagal memuat riwayat pengajuan');
    }
  }
}
