import 'package:absensi_alma/core/config/theme/app_theme.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:absensi_alma/presentation/splash/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Absensi Karyawan PT Alma',
        theme: AppTheme.appTheme,
        home: const SplashPage(),
      ),
    );
  }
}
