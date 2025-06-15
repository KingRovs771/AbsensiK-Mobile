import 'package:equatable/equatable.dart';

class AkUsers extends Equatable {
  final String userUID;
  final String email;
  final String username;
  final String fullName;
  final String roleId;
  final String departmentsId;

  const AkUsers({
    required this.userUID,
    required this.email,
    required this.username,
    required this.fullName,
    required this.roleId,
    required this.departmentsId,
  });

  @override
  List<Object?> get props =>
      [userUID, email, username, fullName, roleId, departmentsId];
}
