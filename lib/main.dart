import 'package:absensi_alma/common/helper/bottomNavigation/bottom_bar.dart';
import 'package:absensi_alma/core/config/theme/app_theme.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:absensi_alma/presentation/auth/pages/signin.dart';
import 'package:absensi_alma/presentation/splash/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>()..add(AppStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Absensi Karyawan PT Alma',
        theme: AppTheme.appTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return BottomBar(user: state.user);
            }
            if (state is AuthUnauthenticated || state is AuthFailure) {
              return SignInPage();
            }
            return const SplashPage();
          },
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Gagal memulai aplikasi:\n\n$error",
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
