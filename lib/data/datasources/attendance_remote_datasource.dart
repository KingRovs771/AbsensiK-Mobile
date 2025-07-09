import 'dart:convert';

import 'package:absensi_alma/core/error/exceptions.dart';
import 'package:absensi_alma/data/models/AkAttendances_Model.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

abstract class AttendanceRemoteDataSource {
  Future<AttendanceDataModel> getAttendanceData(String token);
  Future<String> clockIn(String token, XFile photo, Position position);
  Future<String> clockOut(String token, Position position);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://absensik-backend-production.up.railway.app";

  AttendanceRemoteDataSourceImpl({required this.client});

  @override
  Future<AttendanceDataModel> getAttendanceData(String token) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/v1/attendances/getDataAttendances'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return AttendanceDataModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException(message: 'Gagal memuat data absensi');
    }
  }

  @override
  Future<String> clockIn(String token, XFile photo, Position position) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$_baseUrl/v1/attendances/clockIn'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['latitude'] = position.latitude.toString();
    request.fields['longitude'] = position.longitude.toString();
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ??
              'Gagal melakukan absen masuk');
    }
  }

  @override
  Future<String> clockOut(String token, Position position) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/v1/attendances/clockOut'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(
          {'latitude': position.latitude, 'longitude': position.longitude}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ??
              'Gagal melakukan absen pulang');
    }
  }
}
