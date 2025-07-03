import 'package:absensi_alma/domain/entities/payslip_entity.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/injection_container.dart';
import 'package:absensi_alma/presentation/payments/bloc/payslip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PaymentsPage extends StatelessWidget {
  final UserEntity user;
  const PaymentsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PayslipBloc>()..add(FetchLatestPayslip()),
      child: _PaymentsView(user: user),
    );
  }
}

class _PaymentsView extends StatelessWidget {
  final UserEntity user;
  const _PaymentsView({required this.user});

  String _formatCurrency(double amount) {
    final format = NumberFormat.decimalPattern('id_ID');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Gaji'),
        backgroundColor: Colors.lightBlue[700],
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<PayslipBloc, PayslipState>(
        builder: (context, state) {
          if (state is PayslipLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PayslipFailure) {
            return Center(child: Text('Gagal memuat data: ${state.message}'));
          }
          if (state is PayslipLoaded) {
            final payslip = state.payslip;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(user, payslip),
                  const SizedBox(height: 24),
                  _buildSection("Penghasilan", payslip.earnings),
                  const SizedBox(height: 8),
                  _buildTotalRow("Total Pendapatan", payslip.totalEarnings),
                  const SizedBox(height: 24),
                  _buildSection("Potongan", payslip.deductions),
                  const SizedBox(height: 8),
                  _buildTotalRow("Total Potongan", payslip.totalDeductions),
                  const Divider(height: 32, thickness: 1.5),
                  _buildTotalRow("GAJI BERSIH", payslip.netSalary,
                      isGrandTotal: true),
                ],
              ),
            );
          }
          return const Center(child: Text('Memuat data gaji...'));
        },
      ),
      // PERUBAHAN DI SINI: Tombol SIMPAN (bottomNavigationBar) telah dihapus.
    );
  }

  Widget _buildHeader(UserEntity user, PayslipEntity payslip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('NIK      : ${user.userUID}'),
              Text('DEVISI : ${user.role.nameRole.toUpperCase()}'),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text('NAMA : ${user.fullName}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<PayslipItemEntity> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items
            .map((item) => _buildDetailRow(item.name, item.amount))
            .toList(),
      ],
    );
  }

  Widget _buildDetailRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(_formatCurrency(value)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value,
      {bool isGrandTotal = false}) {
    final style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: isGrandTotal ? 18 : 16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(_formatCurrency(value), style: style),
        ],
      ),
    );
  }
}
