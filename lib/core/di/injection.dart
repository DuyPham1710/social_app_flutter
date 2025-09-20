import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:social_app_fe/core/network/dio_client.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/repository/auth_repository_impl.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/update_personal_info_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/verify_otp_usecase.dart';
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
  s1.registerLazySingleton<VerifyOtpUsecase>(() => VerifyOtpUsecase(s1()));
  s1.registerLazySingleton<ResendOtpUsecase>(() => ResendOtpUsecase(s1()));
  s1.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(s1()),
  );
  s1.registerLazySingleton<UpdatePersonalInfoUsecase>(
    () => UpdatePersonalInfoUsecase(s1()),
  );

  // Blocs
  s1.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: s1(),
      registerUsecase: s1(),
      verifyOtpUsecase: s1(),
      resendOtpUsecase: s1(),
      resetPasswordUsecase: s1(),
      updatePersonalInfoUsecase: s1(),
    ),
  );
}
