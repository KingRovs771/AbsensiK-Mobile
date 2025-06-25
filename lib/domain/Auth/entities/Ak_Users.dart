import 'package:absensi_alma/domain/Auth/entities/Ak_Roles.dart';
import 'package:equatable/equatable.dart';

class AkUsers extends Equatable {
  final String userUID;
  final String email;
  final String username;
  final String fullName;
  final AkRoles role;
  final String departmentsId;

  const AkUsers({
    required this.userUID,
    required this.email,
    required this.username,
    required this.fullName,
    required this.role,
    required this.departmentsId,
  });

  @override
  List<Object?> get props =>
      [userUID, email, username, fullName, role, departmentsId];
}
