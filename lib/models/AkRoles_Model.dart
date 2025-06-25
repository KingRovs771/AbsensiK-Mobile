import 'package:absensi_alma/domain/Auth/entities/Ak_Roles.dart';

class AkRolesModel extends AkRoles {
  AkRolesModel({required super.nameRole});

  factory AkRolesModel.fromJson(Map<String, dynamic> json) {
    return AkRolesModel(
      nameRole: json['name_role'],
    );
  }
}
