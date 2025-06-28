import 'package:absensi_alma/data/models/AkRoles_Model.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';

class AkUsersModel extends UserEntity {
  const AkUsersModel({
    required String userUID,
    required String username,
    required String email,
    required String fullName,
    required String phone,
    required AkRolesModel role,
  }) : super(
          userUID: userUID,
          username: username,
          email: email,
          fullName: fullName,
          phone: phone,
          role: role,
        );

  factory AkUsersModel.fromJson(Map<String, dynamic> json) {
    return AkUsersModel(
      userUID: json['user_uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? 0,
      role: AkRolesModel.fromJson(json['role'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_uid': userUID,
      'username': username,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': (role as AkRolesModel).toJson(),
    };
  }
}
