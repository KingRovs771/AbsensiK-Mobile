import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SickPage extends StatefulWidget {
  @override
  _SickPageState createState() => _SickPageState();
}

class _SickPageState extends State<SickPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  String? _doctorNotePhotoPath;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _SelectDate(BuildContext context, bool isStart) async {
    DateTime initialDate =
        isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = "${_startDate!.toLocal()}".split(' ')[0];
        } else {
          _endDate = picked;
          _endDateController.text = "${_endDate!.toLocal()}".split(' ')[0];
        }
      });
    }
  }

  void _submitForm() async {
    return null;
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
      body: Padding(
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
                decoration: InputDecoration(labelText: 'Alasan'),
                onSaved: (value) {
                  _reason = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alasan tidak boleh kosong';
                  }
                  return null;
                },
              ),
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        icon: Icon(
          Icons.send,
          color: AppColors.fontColor,
        ),
        label: Text(
          'Simpan',
          style: TextStyle(color: AppColors.fontColor),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
    );
  }
}
