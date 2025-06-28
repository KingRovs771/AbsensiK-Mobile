import 'package:absensi_alma/common/helper/bottomNavigation/bottom_bar.dart';
import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/injection_container.dart' as di;
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:absensi_alma/presentation/auth/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bgSplash),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image(image: AssetImage(AppImages.logoApp)),
                      Text('PT Alma Global Health'),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
