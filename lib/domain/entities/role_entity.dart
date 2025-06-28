import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  final String roleId;
  final String nameRole;

  const RoleEntity({required this.roleId, required this.nameRole});

  @override
  List<Object?> get props => [roleId, nameRole];
}