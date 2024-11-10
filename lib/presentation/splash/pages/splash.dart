import 'package:absensi_alma/common/helper/bottomNavigation/bottom_bar.dart';
import 'package:absensi_alma/common/helper/navigation/app_navigation.dart';
import 'package:absensi_alma/core/config/theme/app_colors.dart';
import 'package:absensi_alma/presentation/auth/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, SigninPage());
          }

          if (state is Authenticated) {
            AppNavigator.pushReplacement(context, BottomBar());
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.primaryColor),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                    const Color(0xff1A1B20).withOpacity(0),
                    const Color(0xff1A1B20)
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
