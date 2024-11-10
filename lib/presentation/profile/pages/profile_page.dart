import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.fontColor,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          ),
          Center(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage(AppImages.profileKaryawan),
            ),
          ),
          Center(
            child: Text(
              'Nama Lengkap',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text(
              'Marketing',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                itemProfile('Name', 'Ahad hasmi', CupertinoIcons.person),
                SizedBox(
                  height: 8,
                ),
                itemProfile(
                    'Divisi', 'Marketing', CupertinoIcons.building_2_fill),
                SizedBox(
                  height: 8,
                ),
                itemProfile(
                    'Telpon', '+62 821 67489 020', CupertinoIcons.phone),
                SizedBox(
                  height: 8,
                ),
                itemProfile(
                    'Alamat', 'Gading Serpong Blok M', CupertinoIcons.map),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 5),
            color: AppColors.primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10),
      ],
    ),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      leading: Icon(
        iconData,
        color: AppColors.primaryColor,
      ),
      tileColor: Colors.white,
    ),
  );
}
