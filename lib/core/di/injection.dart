import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/repository/auth_repository_impl.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  s1.registerSingleton<Dio>(Dio());

  // Dependencies
  // DataSources
  s1.registerLazySingleton<AuthService>(() => AuthService(s1()));

  // Repositories
  s1.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(s1()));

  // Usecases
  s1.registerLazySingleton<LoginUsecase>(() => LoginUsecase(s1()));
  s1.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(s1()));
}
