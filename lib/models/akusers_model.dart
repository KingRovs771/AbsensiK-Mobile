import 'package:absensi_alma/models/AkRoles_Model.dart';

import '../domain/Auth/entities/Ak_Users.dart';

class AkUsersModel extends AkUsers {
  const AkUsersModel(
      {required super.userUID,
      required super.email,
      required super.username,
      required super.fullName,
      required super.role,
      required super.departmentsId});

  factory AkUsersModel.fromJson(Map<String, dynamic> json) {
    return AkUsersModel(
      userUID: json['user_uid'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      role: AkRolesModel.fromJson(json['role']),
      departmentsId: json['departments_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_uid': userUID,
      'email': email,
      'username': username,
      'full_name': fullName,
      'role_id': role,
      'departments_id': departmentsId
    };
  }
}
