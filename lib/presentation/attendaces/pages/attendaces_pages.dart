import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AttendacesPages extends StatefulWidget {
  @override
  _attendacesPagesState createState() => _attendacesPagesState();
}

class _attendacesPagesState extends State<AttendacesPages> {
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

  @override
  Widget build(BuildContext context) {
    double WidthSize = MediaQuery.sizeOf(context).width;
    double HeightSize = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.fontColor,
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          'Halaman Notifikasi ',
          style: TextStyle(color: AppColors.fontColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: request.length,
              itemBuilder: (context, index) {
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
