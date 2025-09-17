import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/update_personal_info_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final UpdatePersonalInfoUsecase updatePersonalInfoUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.updatePersonalInfoUsecase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<UpdatePersonalInfoEvent>(_updatePersonalInfo);
    on<AuthReset>((event, emit) {
      emit(AuthInitial());
    });
  }

  void _updatePersonalInfo(
    UpdatePersonalInfoEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final dataState = await updatePersonalInfoUsecase(params: event.user);

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }

  void _resendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpResendLoading());

    final dataState = await resendOtpUsecase(params: event.email);

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(OtpResendSuccess(dataState.data!));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }

  void _verifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await verifyOtpUsecase(
      params: VerifyOtpRequest(email: event.email, otp: event.otp),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await loginUsecase(
      params: AuthRequest(email: event.email, password: event.password),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }

  void _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await registerUsecase(
      params: RegisterRequest(
        email: event.email,
        username: event.username,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }
}
