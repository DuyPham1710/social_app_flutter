import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:social_app_fe/core/network/dio_client.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/repository/auth_repository_impl.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  s1.registerSingleton<Dio>(DioClient.instance);

  // Dependencies
  // DataSources
  s1.registerLazySingleton<AuthService>(() => AuthService(s1()));

  // Repositories
  s1.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(s1()));

  // Usecases
  s1.registerLazySingleton<LoginUsecase>(() => LoginUsecase(s1()));
  s1.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(s1()));

  // Blocs
  s1.registerFactory<AuthBloc>(
    () => AuthBloc(loginUsecase: s1(), registerUsecase: s1()),
  );
}
