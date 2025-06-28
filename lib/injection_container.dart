import 'package:absensi_alma/data/datasources/auth_local_datasource.dart';
import 'package:absensi_alma/data/datasources/auth_remote_datasource.dart';
import 'package:absensi_alma/data/repositories/auth_repository_impl.dart';
import 'package:absensi_alma/domain/repositories/AuthRepository.dart';
import 'package:absensi_alma/domain/usecases/get_current_user.dart';
import 'package:absensi_alma/domain/usecases/login_user.dart';
import 'package:absensi_alma/domain/usecases/logout_user.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
      () => AuthBloc(loginUser: sl(), logoutUser: sl(), getCurrentUser: sl()));
  sl.registerFactory(() => SplashCubit(getCurrentUser: sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(), // DIPERBARUI: Tambahkan localDataSource
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    // BARU: Daftarkan AuthLocalDataSource
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
