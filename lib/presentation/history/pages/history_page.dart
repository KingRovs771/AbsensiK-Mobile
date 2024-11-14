import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedMonth = 'All';
  String _selectedStatus = 'All';
  List<Map<String, String>> request = [
    {
      'type': 'Attendance Correction',
      'date': '27 Januari',
      'status': 'Awaiting',
      'Time': '26 Jul 2022'
    },
    {
      'type': 'Attendance Correction',
      'date': '27 Februari',
      'status': 'Awaiting',
      'Time': '26 Jul 2022'
    },
    {
      'type': 'Attendance Correction',
      'date': '27 Maret',
      'status': 'Awaiting',
      'Time': '26 Jul 2022'
    },
    {
      'type': 'Wedding Leave',
      'date': '27 April',
      'status': 'Awaiting',
      'Time': ' 2022'
    },
    {
      'type': 'Business Trip <7 Days',
      'date': '27 Mei',
      'status': 'Awaiting',
      'Time': '29 - 31 Aug 2022'
    },
    {
      'type': 'Attendance Correction',
      'date': '21 Juni',
      'status': 'Approved',
      'Time': '20 Jul 2022'
    },
    {
      'type': 'Annual Leave',
      'date': '19 Juli',
      'status': 'Rejected',
      'Time': '20 Jul 2022'
    },
    {
      'type': 'Annual Leave',
      'date': '23 Agustus',
      'status': 'Awaiting',
      'Time': '22 Jul 2022'
    }
  ];

  List<String> months = [
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
  List<String> statuses = ['All', 'Awaiting', 'Approved', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    double WidthSize = MediaQuery.sizeOf(context).width;
    double HeightSize = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.fontColor,
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          'History Absensi ',
          style: TextStyle(color: AppColors.fontColor),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                padding: EdgeInsets.only(left: 9),
                height: HeightSize * 0.05,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: _selectedMonth,
                  dropdownColor: AppColors.fontColor,
                  iconEnabledColor: AppColors.fontColorV,
                  elevation: 8,
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedMonth = value!;
                    });
                  },
                  items: months.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: AppColors.fontColorV),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 9),
                height: HeightSize * 0.05,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  dropdownColor: AppColors.fontColor,
                  iconEnabledColor: AppColors.fontColorV,
                  elevation: 8,
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  items: statuses.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(color: AppColors.fontColorV)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: request.length,
              itemBuilder: (context, index) {
                if ((_selectedMonth == 'All' ||
                        request[index]['date']!.contains(_selectedMonth)) &&
                    (_selectedStatus == 'All' ||
                        request[index]['status'] == _selectedStatus)) {
                  return Card(
                    elevation: 4.0,
                    color: AppColors.fontColor,
                    child: ListTile(
                      title: Text(
                        request[index]['type']!,
                        style: TextStyle(color: AppColors.fontColorBlack),
                      ),
                      subtitle: Text('For: ${request[index]['date']}'),
                      trailing: Text(
                        request[index]['status']!,
                        style: TextStyle(
                            color: request[index]['status'] == 'Approved'
                                ? Colors.green
                                : request[index]['status'] == 'Rejected'
                                    ? Colors.red
                                    : Colors.orange),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
