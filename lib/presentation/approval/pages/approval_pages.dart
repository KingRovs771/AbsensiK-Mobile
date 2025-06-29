import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/injection_container.dart';
import 'package:absensi_alma/presentation/approval/bloc/approval_bloc.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ApprovalPages extends StatelessWidget {
  const ApprovalPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApprovalBloc(
        getPermitHistory: sl(),
        authBloc: context.read<AuthBloc>(), // <-- Inject AuthBloc yang ada
      )..add(FetchPermitHistoryRequested()),
      child: const _ApprovalView(),
    );
  }
}

class _ApprovalView extends StatefulWidget {
  const _ApprovalView();

  @override
  State<_ApprovalView> createState() => _ApprovalViewState();
}

class _ApprovalViewState extends State<_ApprovalView> {
  String _selectedMonth = 'All';
  String _selectedStatus = 'All';

  final List<String> _months = [
    'All',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  final List<String> _statuses = ['All', 'Pending', 'Approved', 'Rejected'];

  List<PermitEntity> _filterPermits(List<PermitEntity> allPermits) {
    return allPermits.where((permit) {
      final permitDate = DateTime.parse(permit.startDate);
      final permitMonth = DateFormat('MMMM', 'id_ID').format(permitDate);

      final monthMatch =
          _selectedMonth == 'All' || permitMonth == _selectedMonth;
      final statusMatch =
          _selectedStatus == 'All' || permit.status == _selectedStatus;

      return monthMatch && statusMatch;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pengajuan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: _buildDropdown(_months, _selectedMonth,
                        (val) => setState(() => _selectedMonth = val!))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(_statuses, _selectedStatus,
                        (val) => setState(() => _selectedStatus = val!))),
              ],
            ),
          ),
          // List Section
          Expanded(
            child: BlocBuilder<ApprovalBloc, ApprovalState>(
              builder: (context, state) {
                if (state is ApprovalLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ApprovalFailure) {
                  return Center(
                      child: Text('Gagal memuat data: ${state.message}'));
                }
                if (state is ApprovalLoaded) {
                  final filteredList = _filterPermits(state.permits);
                  if (filteredList.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada data yang cocok.'));
                  }
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final permit = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading:
                              CircleAvatar(child: Text(permit.permitType[0])),
                          title: Text(permit.permitType,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Tanggal: ${permit.startDate} s/d ${permit.endDate}\nAlasan: ${permit.reason}'),
                          trailing: Text(permit.status,
                              style: TextStyle(
                                  color: _getStatusColor(permit.status),
                                  fontWeight: FontWeight.bold)),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Silakan pilih filter.'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String val) {
          return DropdownMenuItem<String>(value: val, child: Text(val));
        }).toList(),
      ),
    );
  }
}
