import 'package:equatable/equatable.dart';

class PayslipItemEntity extends Equatable {
  final String name;
  final double amount;
  const PayslipItemEntity({required this.name, required this.amount});
  @override
  List<Object?> get props => [name, amount];
}

class PayslipEntity extends Equatable {
  final String period;
  final List<PayslipItemEntity> earnings;
  final List<PayslipItemEntity> deductions;
  final double totalEarnings;
  final double totalDeductions;
  final double netSalary;

  const PayslipEntity({
    required this.period,
    required this.earnings,
    required this.deductions,
    required this.totalEarnings,
    required this.totalDeductions,
    required this.netSalary,
  });
  @override
  List<Object?> get props =>
      [period, earnings, deductions, totalEarnings, totalDeductions, netSalary];
}
