import 'package:absensi_alma/domain/entities/permit_entity.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/injection_container.dart';
import 'package:absensi_alma/presentation/approval/bloc/approval_bloc.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ApprovalPages extends StatelessWidget {
  final UserEntity user;
  const ApprovalPages({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID', null);

    return BlocProvider(
      create: (context) => sl<ApprovalBloc>(
        param1: context.read<AuthBloc>(),
      )..add(FetchPermitHistoryRequested()),
      child: _ApprovalView(user: user),
    );
  }
}

class _ApprovalView extends StatefulWidget {
  final UserEntity user;
  const _ApprovalView({required this.user});

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

  String _getStatusString(String status) {
    switch (status) {
      case '1':
        return 'Approved';
      case '2':
        return 'Rejected';
      case '0':
      default:
        return 'Pending';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.red;
      case '0':
      default:
        return Colors.orange;
    }
  }

  // === PERBAIKAN UTAMA ADA DI FUNGSI INI ===
  List<PermitEntity> _filterPermits(List<PermitEntity> allPermits) {
    return allPermits.where((permit) {
      // 1. Cek dulu apakah startDate valid dan tidak kosong.
      if (permit.startDate.isEmpty) {
        return false; // Langsung filter item dengan tanggal tidak valid.
      }

      try {
        // 2. Sekarang parsing dijamin aman.
        final permitDate = DateTime.parse(permit.startDate);
        final permitMonth = DateFormat('MMMM', 'id_ID').format(permitDate);
        final statusString = _getStatusString(permit.status);

        final monthMatch =
            _selectedMonth == 'All' || permitMonth == _selectedMonth;
        final statusMatch =
            _selectedStatus == 'All' || statusString == _selectedStatus;

        return monthMatch && statusMatch;
      } catch (e) {
        // Jaring pengaman terakhir jika format tanggal tetap tidak terduga.
        return false;
      }
    }).toList();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Menampilkan riwayat untuk: ${widget.user.fullName}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Expanded(
            child: BlocBuilder<ApprovalBloc, ApprovalState>(
              builder: (context, state) {
                if (state is ApprovalLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ApprovalFailure) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text('Gagal memuat data: ${state.message}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: () => context
                                .read<ApprovalBloc>()
                                .add(FetchPermitHistoryRequested()),
                            child: const Text('Coba Lagi'))
                      ]));
                }
                if (state is ApprovalLoaded) {
                  final filteredList = _filterPermits(state.permits);
                  if (filteredList.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada data yang cocok.'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<ApprovalBloc>()
                          .add(FetchPermitHistoryRequested());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final permit = filteredList[index];
                        final statusText = _getStatusString(permit.status);
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(permit.status)
                                  .withOpacity(0.1),
                              child: Text(
                                  permit.permitType.isNotEmpty
                                      ? permit.permitType[0]
                                      : '?',
                                  style: TextStyle(
                                      color: _getStatusColor(permit.status),
                                      fontWeight: FontWeight.bold)),
                            ),
                            title: Text(permit.permitType,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Tanggal: ${permit.startDate} s/d ${permit.endDate}\nAlasan: ${permit.reason}'),
                            trailing: Text(statusText,
                                style: TextStyle(
                                    color: _getStatusColor(permit.status),
                                    fontWeight: FontWeight.bold)),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(child: Text('Memuat riwayat...'));
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
