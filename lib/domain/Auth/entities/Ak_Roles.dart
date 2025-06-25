import 'package:equatable/equatable.dart';

class AkRoles extends Equatable {
  final String nameRole;

  const AkRoles({required this.nameRole});

  @override
  // TODO: implement props
  List<Object?> get props => [nameRole];
}
