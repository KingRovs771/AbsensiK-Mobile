import '../domain/Auth/entities/Ak_Users.dart';

class AkusersModel extends AkUsers {
  const AkusersModel(
      {required super.userUID,
      required super.email,
      required super.username,
      required super.fullName,
      required super.roleId,
      required super.departmentsId});

  factory AkusersModel.fromJson(Map<String, dynamic> json) {
    return AkusersModel(
      userUID: json['user_uid'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      roleId: json['role_id'],
      departmentsId: json['departments_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_uid': userUID,
      'email': email,
      'username': username,
      'full_name': fullName,
      'role_id': roleId,
      'departments_id': departmentsId
    };
  }
}
