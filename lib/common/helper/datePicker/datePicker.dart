import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  _DatePickerState createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.fontColor,
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          'Halaman Pengajuan Sakit',
          style: TextStyle(color: AppColors.fontColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai',
                filled: true,
                prefixIcon: Icon(Icons.calendar_view_day),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              readOnly: true,
              onTap: () {
                _selectDate();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}
