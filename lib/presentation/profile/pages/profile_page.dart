import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity user;
  const ProfilePage({super.key, required this.user});
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
              user.fullName.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text(
              user.role.nameRole,
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
                itemProfile(
                    'Name', user.fullName.toString(), CupertinoIcons.person),
                SizedBox(
                  height: 8,
                ),
                itemProfile('Divisi', user.role.nameRole,
                    CupertinoIcons.building_2_fill),
                SizedBox(
                  height: 8,
                ),
                itemProfile(
                    'Telpon', user.fullName.toString(), CupertinoIcons.phone),
                SizedBox(
                  height: 8,
                ),
                itemProfile(
                    'Alamat', user.fullName.toString(), CupertinoIcons.map),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container itemProfile(String title, String subtitle, IconData iconData) {
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
