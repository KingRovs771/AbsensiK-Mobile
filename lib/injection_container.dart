import 'package:absensi_alma/data/datasources/auth_local_datasource.dart';
import 'package:absensi_alma/data/datasources/auth_remote_datasource.dart';
import 'package:absensi_alma/data/datasources/permit_remote_datasource.dart';
import 'package:absensi_alma/data/repositories/auth_repository_impl.dart';
import 'package:absensi_alma/data/repositories/permit_repository_impl.dart';
import 'package:absensi_alma/domain/repositories/AuthRepository.dart';
import 'package:absensi_alma/domain/repositories/PermitRepository.dart';
import 'package:absensi_alma/domain/usecases/get_current_user.dart';
import 'package:absensi_alma/domain/usecases/get_permit_history.dart';
import 'package:absensi_alma/domain/usecases/login_user.dart';
import 'package:absensi_alma/domain/usecases/logout_user.dart';
import 'package:absensi_alma/domain/usecases/submit_permit.dart';
import 'package:absensi_alma/presentation/approval/bloc/approval_bloc.dart';
import 'package:absensi_alma/presentation/auth/bloc/auth_bloc.dart';
import 'package:absensi_alma/presentation/izin/bloc/permit_bloc.dart';
import 'package:absensi_alma/presentation/splash/bloc/splash_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //BLoC
  sl.registerFactory(
      () => AuthBloc(loginUser: sl(), logoutUser: sl(), getCurrentUser: sl()));

  sl.registerFactory(() => PermitBloc(submitPermit: sl(), authBloc: sl()));

  sl.registerFactory(
      () => ApprovalBloc(getPermitHistory: sl(), authBloc: sl()));

  //use Cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => SubmitPermit(sl()));
  sl.registerLazySingleton(() => GetPermitHistory(sl()));

  //repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PermitRepository>(() => PermitRepositoryImpl(
        remoteDataSource: sl(),
      ));

  sl.registerFactory(() => SplashCubit(getCurrentUser: sl()));

  //Data Source
  sl.registerLazySingleton<PermitRemoteDataSource>(
      () => PermitRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //external
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
