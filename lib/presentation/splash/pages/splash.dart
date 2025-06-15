import 'package:absensi_alma/common/helper/bottomNavigation/bottom_bar.dart';
import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/presentation/auth/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          print("STATE BARU DARI SPLASH CUBIT: $state");
          if (state is UnAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SignInPage()),
            );
          }

          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const BottomBar()),
            );
          }
        },
        child: LayoutBuilder(builder: (context, constraints) {
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
      ),
    );
  }
}
