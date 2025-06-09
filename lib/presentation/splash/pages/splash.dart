import 'package:absensi_alma/common/helper/bottomNavigation/bottom_bar.dart';
import 'package:absensi_alma/common/helper/navigation/app_navigation.dart';
import 'package:absensi_alma/core/config/assets/app_images.dart';
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
        child: LayoutBuilder(builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
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
                        Text('asdasd'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
