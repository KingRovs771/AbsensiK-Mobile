import 'package:absensi_alma/domain/entities/role_entity.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userUID;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final RoleEntity role;

  const UserEntity({
    required this.userUID,
    required this.username,
    required this.email,
    required this.fullName,
    required this.role,
    required this.phone,
  });

  @override
  List<Object?> get props => [userUID, username, email, fullName, phone, role];
}
