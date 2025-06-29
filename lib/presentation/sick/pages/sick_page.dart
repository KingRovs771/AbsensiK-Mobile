import 'dart:io';

import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/presentation/izin/bloc/permit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SickPage extends StatefulWidget {
  @override
  _SickPageState createState() => _SickPageState();
}

class _SickPageState extends State<SickPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    _reasonController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    // Validasi semua field di form
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan: pastikan foto sudah diunggah
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Mohon unggah bukti foto atau surat sakit.'),
          backgroundColor: Colors.orange,
        ));
        return; // Hentikan proses jika foto kosong
      }

      // Jika semua valid, kirim event ke BLoC
      context.read<PermitBloc>().add(
            SubmitPermitButtonPressed(
              startDate: _startDate!,
              endDate: _endDate!,
              reason: _reasonController.text,
              permitType: 'Sakit', // Tipe sudah pasti 'Sakit'
              photo: _imageFile, // Kirim file gambar
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
          'Tambah Data Sakit ',
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
                  content: Text('Pengajuan sakit berhasil dikirim'),
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
                  onTap: () => _selectDate(context, true),
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
                  onTap: () => _selectDate(context, false),
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
                    decoration: const InputDecoration(
                        labelText: 'Keterangan Sakit',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder()),
                    maxLines: 2,
                    validator: (v) =>
                        v!.isEmpty ? 'Keterangan wajib diisi' : null),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Foto Surat Dokter',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4)),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(_imageFile!, fit: BoxFit.cover))
                      : const Center(
                          child: Text('Belum ada foto dipilih.',
                              style: TextStyle(color: Colors.grey))),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pilih dari Galeri'),
                  onPressed: _pickImage,
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<PermitBloc, PermitState>(
        builder: (context, state) {
          if (state is PermitLoading) {
            return const FloatingActionButton.extended(
              onPressed: null,
              label: Text('Mengirim...'),
              icon: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              backgroundColor: Colors.grey,
            );
          }
          return FloatingActionButton.extended(
            onPressed: _submitForm,
            icon: const Icon(Icons.send),
            label: const Text('Kirim Pengajuan'),
            backgroundColor: Colors.indigo,
          );
        },
      ),
    );
  }
}
