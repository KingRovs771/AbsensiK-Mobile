import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/presentation/attendaces/pages/attendaces_pages.dart';
import 'package:absensi_alma/presentation/home/pages/home_page.dart';
import 'package:absensi_alma/presentation/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final UserEntity user;
  const BottomBar({super.key, required this.user});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Logika ini sudah benar, kita hanya meneruskan data user ke setiap halaman.
    _widgetOptions = <Widget>[
      HomePage(user: widget.user),
      AttendancePage(user: widget.user),
      ProfilePage(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN 2: Hapus BlocProvider dan BlocListener.
    // Widget ini sekarang menjadi "dumb widget" yang hanya menampilkan UI.
    // Logika logout sudah ditangani oleh BlocBuilder di main.dart.
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // Ganti dengan warna Anda jika perlu
        backgroundColor: AppColors.navbarColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              activeIcon: Icon(Icons.camera_alt),
              label: 'Attendances'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
        iconSize: 24,
      ),
    );
  }
}
