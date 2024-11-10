import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/presentation/notifications/pages/notif_page.dart';
import 'package:absensi_alma/presentation/payments/pages/payments_page.dart';
import 'package:flutter/material.dart';

import '../../cuti/pages/cuti_page.dart';
import '../../history/pages/history_page.dart';
import '../../izin/pages/izin_page.dart';
import '../../sick/pages/sick_page.dart';
import '../../approval/pages/approval_pages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: screenSize.height * 0.35,
            width: screenSize.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: screenSize.height * 0.32 - 27,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                      Image(
                        width: screenSize.height * 0.09,
                        height: screenSize.height * 0.09,
                        image: AssetImage(
                          AppImages.logoApp,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                            'PT. Alamanda Global Health',
                          ),
                          Text(
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            'Jika Kamu Merasa Gagal Hari Ini,',
                          ),
                          Text(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                            'Besok Coba Lagi Siapa tahu lebih gagal',
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: AppColors.primaryColor.withOpacity(0.33),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text(
                          'Jadwal Hari ini',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: AppColors.fontColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '17:00 WIB',
                              style: TextStyle(
                                color: AppColors.fontColor,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: AppColors.fontColor,
                              size: 24,
                              semanticLabel: 'Arrow In',
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '17:00 WIB',
                              style: TextStyle(
                                color: AppColors.fontColor,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(12),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.profileKaryawan),
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.repeat,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Divisi Profile',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 16),
                ),
                Icon(
                  Icons.event_available,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Presensi Keluar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Icon(
                  Icons.fiber_manual_record,
                  size: 8,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Sen, 12 Sep 2023 17:08',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(15),
              crossAxisCount: 4,
              children: [
                _buildActionButton(
                    'Izin', Icons.assignment, screenSize, IzinPage(), context),
                _buildActionButton('Sakit', Icons.local_hospital, screenSize,
                    SickPage(), context),
                _buildActionButton('Cuti', Icons.beach_access, screenSize,
                    CutiPage(), context),
                _buildActionButton('Approval', Icons.check_circle, screenSize,
                    ApprovalPages(), context),
                _buildActionButton('Gaji', Icons.attach_money, screenSize,
                    PaymentsPage(), context),
                _buildActionButton('Riwayat', Icons.note_alt, screenSize,
                    HistoryPage(), context),
                _buildActionButton('Notifikasi', Icons.notifications,
                    screenSize, NotifPage(), context),
                _buildActionButton('Logout', Icons.door_back_door, screenSize,
                    NotifPage(), context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Size screenSize,
      Widget link, BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        child: Card.outlined(
          color: Colors.white,
          shadowColor: Colors.black,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => link),
              );
            },
            splashColor: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 38, color: Colors.lightBlue),
                  Text(title,
                      style: TextStyle(
                          fontSize: screenSize.width * 0.040,
                          color: Colors.black)),
                ],
              ),
            ),
          ),
        ));
  }
}
