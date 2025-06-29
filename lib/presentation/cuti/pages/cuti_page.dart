import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/presentation/izin/bloc/permit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CutiPage extends StatefulWidget {
  @override
  _CutiPageState createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _SelectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        if (isStart) {
          _startDate = picked;
          _startDateController.text = formattedDate;
        } else {
          _endDate = picked;
          _endDateController.text = formattedDate;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      context.read<PermitBloc>().add(
            SubmitPermitButtonPressed(
              startDate: _startDate!,
              endDate: _endDate!,
              reason: _reasonController.text,
              permitType: 'Cuti',
              photo: null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.fontColor,
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          'Tambah Data Cuti ',
          style: TextStyle(color: AppColors.fontColor),
        ),
      ),
      body: BlocListener<PermitBloc, PermitState>(
        listener: (context, state) {
          if (state is PermitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red),
            );
          } else if (state is PermitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Pengajuan Izin berhasil dikirim'),
                  backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(); // Kembali ke halaman home
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tanggal Dimulai',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () => _SelectDate(context, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Mulai',
                        hintText: _startDate == null
                            ? 'Pilih Tanggal Mulai'
                            : _startDate.toString().split(' ')[0],
                      ),
                      validator: (value) {
                        if (_startDate == null) {
                          return 'Tanggal Mulai tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Tanggal Berakhir',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () => _SelectDate(context, false),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Akhir',
                        hintText: 'Pilih',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (_endDate == null) {
                          return 'Tanggal Akhir tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Alasan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                      labelText: 'Keperluan', alignLabelWithHint: true),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alasan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          BlocBuilder<PermitBloc, PermitState>(builder: (context, state) {
        if (state is PermitLoading) {
          return const CircularProgressIndicator();
        }
        return FloatingActionButton.extended(
          onPressed: _submitForm,
          icon: Icon(
            Icons.send,
            color: AppColors.fontColor,
          ),
          label: Text(
            'Kirim Pengajuan',
            style: TextStyle(color: AppColors.fontColor),
          ),
          backgroundColor: AppColors.secondaryColor,
        );
      }),
    );
  }
}
