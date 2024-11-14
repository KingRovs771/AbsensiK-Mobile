import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ApprovalPages extends StatefulWidget {
  @override
  _ApprovalPagesState createState() => _ApprovalPagesState();
}

class _ApprovalPagesState extends State<ApprovalPages> {
  String _selectedMonth = 'All';
  String _selectedStatus = 'All';
  List<Map<String, String>> request = [
    {
      'type': 'Attendance Correction',
      'date': '27 Jul',
      'status': 'Awaiting',
      'for': '26 Jul 2022'
    },
    {
      'type': 'Attendance Correction',
      'date': '27 Jul',
      'status': 'Awaiting',
      'for': '26 Jul 2022'
    },
    {
      'type': 'Attendance Correction',
      'date': '27 Jul',
      'status': 'Awaiting',
      'for': '26 Jul 2022'
    },
    {
      'type': 'Wedding Leave',
      'date': '27 Jul',
      'status': 'Awaiting',
      'for': '29 - 31 Aug 2022'
    },
    {
      'type': 'Business Trip <7 Days',
      'date': '27 Jul',
      'status': 'Awaiting',
      'for': '29 - 31 Aug 2022'
    },
    {
      'type': 'Attendance Correction',
      'date': '21 Jul',
      'status': 'Approved',
      'for': '20 Jul 2022'
    },
    {
      'type': 'Annual Leave',
      'date': '19 Jul',
      'status': 'Rejected',
      'for': '20 Jul 2022'
    },
    {
      'type': 'Annual Leave',
      'date': '23 Jul',
      'status': 'Awaiting',
      'for': '22 Jul 2022'
    }
  ];

  List<String> months = ['All', 'Jul', 'Aug'];
  List<String> statuses = ['All', 'Awaiting', 'Approved', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.fontColor,
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          'Halaman Approval ',
          style: TextStyle(color: AppColors.fontColor),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Card(
                  color: AppColors.primaryColor,
                  elevation: 4.0,
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    iconSize: 20,
                    iconEnabledColor: AppColors.fontColor,
                    value: _selectedMonth,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                    items:
                        statuses.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
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
                      subtitle: Text('For: ${request[index]['for']}'),
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
