import 'package:absensi_alma/auth_interceptor.dart';
import 'package:absensi_alma/core/config/theme/app_theme.dart';
import 'package:absensi_alma/data/datasources/auth_remote_datasource.dart';
import 'package:absensi_alma/domain/Auth/repositories/AuthRepository.dart';
import 'package:absensi_alma/domain/Auth/repositories/auth_repository_impl.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:absensi_alma/presentation/splash/pages/splash.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FlutterSecureStorage>(
          create: (context) => const FlutterSecureStorage(),
        ),
        RepositoryProvider<Dio>(
          create: (context) {
            final dio = Dio();
            // Tambahkan interceptor ke Dio
            dio.interceptors.add(AuthInterceptor(
                secureStorage: context.read<FlutterSecureStorage>()));
            return dio;
          },
        ),
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(
            client: context.read<Dio>(),
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            secureStorage: context.read<FlutterSecureStorage>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SplashCubit(
              secureStorage: context.read<FlutterSecureStorage>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Absensi Karyawan PT Alma',
          theme: AppTheme.appTheme,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
