import 'package:absensi_alma/domain/entities/permit_entity.dart';

class PermitModel extends PermitEntity {
  const PermitModel({
    required super.id,
    required super.userUID,
    required super.startDate,
    required super.endDate,
    required super.permitType,
    required super.reason,
    required super.status,
  });

  factory PermitModel.fromJson(Map<String, dynamic> json) {
    return PermitModel(
      id: json['izin_id'] ?? 0,
      userUID: json['user_uid'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      permitType: json['izin_type'] ?? '',
      reason: json['alasan'] ?? '',
      status: json['status'] ?? 'Unknown',
    );
  }
}
