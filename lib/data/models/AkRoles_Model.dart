import 'package:absensi_alma/domain/entities/role_entity.dart';

class AkRolesModel extends RoleEntity {
  const AkRolesModel({
    required String roleId,
    required String nameRole,
  }) : super(roleId: roleId, nameRole: nameRole);

  factory AkRolesModel.fromJson(Map<String, dynamic> json) {
    return AkRolesModel(
      roleId: json['role_id'] ?? '',
      nameRole: json['name_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RoleId': roleId,
      'NameRole': nameRole,
    };
  }
}
