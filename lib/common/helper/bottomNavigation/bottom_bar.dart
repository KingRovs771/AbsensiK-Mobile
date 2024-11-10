import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/presentation/home/pages/home_page.dart';
import 'package:absensi_alma/presentation/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text('asdasdads'),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.secondaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera),
              activeIcon: Icon(Icons.photo_camera),
              label: 'Attendaces'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              activeIcon: Icon(Icons.people),
              label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.fontColor,
        onTap: _onItemTapped,
        iconSize: 24,
      ),
    );
  }
}
