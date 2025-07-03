import 'dart:convert';

import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/data/models/AkSalary_Model.dart';
import 'package:http/http.dart' as http;

abstract class PayslipRemoteDataSource {
  Future<PayslipModel> getLatestPayslip(String token);
}

class PayslipRemoteDataSourceImpl implements PayslipRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://absensik-backend-production.up.railway.app";

  PayslipRemoteDataSourceImpl({required this.client});

  @override
  Future<PayslipModel> getLatestPayslip(String token) async {
    // Endpoint ini sekarang dianggap "publik", tetapi memerlukan token di header
    final response = await client.get(
      Uri.parse('$_baseUrl/v1/salary/getLatestSalary'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return PayslipModel.fromJson(json.decode(response.body)['data']);
    } else {
      final responseMap = json.decode(response.body);
      throw ServerException(
          message: responseMap['message'] ?? 'Gagal memuat data gaji');
    }
  }
}
