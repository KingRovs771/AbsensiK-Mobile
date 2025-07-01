import 'dart:developer' as dev;

import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/injection_container.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:absensi_alma/presentation/auth/pages/signin.dart';
import 'package:absensi_alma/presentation/home/pages/home_page.dart';
import 'package:absensi_alma/presentation/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBar extends StatelessWidget {
  final UserEntity user;
  const BottomBar({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        // Listener untuk menangani navigasi saat logout
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignInPage()),
              (route) => false,
            );
          }
        },
        child: _BottomBarView(user: user),
      ),
    );
  }
}

class _BottomBarView extends StatefulWidget {
  final UserEntity user;
  const _BottomBarView({required this.user});
  @override
  State<_BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<_BottomBarView> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      HomePage(user: widget.user),
      const Center(child: Text('Halaman Absensi (Placeholder)')),
      ProfilePage(
        user: widget.user,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    dev.log("Widget BottomBar sedang di-build.", name: "WidgetBuildCheck");
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
