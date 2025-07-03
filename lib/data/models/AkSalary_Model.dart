import 'package:absensi_alma/domain/entities/payslip_entity.dart';

class PayslipItemModel extends PayslipItemEntity {
  const PayslipItemModel({required super.name, required super.amount});

  factory PayslipItemModel.fromJson(Map<String, dynamic> json) {
    return PayslipItemModel(
      name: json['name'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PayslipModel extends PayslipEntity {
  const PayslipModel({
    required super.period,
    required super.earnings,
    required super.deductions,
    required super.totalEarnings,
    required super.totalDeductions,
    required super.netSalary,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      period: json['period'] ?? '',
      earnings: (json['earnings'] as List<dynamic>?)
              ?.map((item) => PayslipItemModel.fromJson(item))
              .toList() ??
          [],
      deductions: (json['deductions'] as List<dynamic>?)
              ?.map((item) => PayslipItemModel.fromJson(item))
              .toList() ??
          [],
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      totalDeductions: (json['total_deductions'] as num?)?.toDouble() ?? 0.0,
      netSalary: (json['net_salary'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
