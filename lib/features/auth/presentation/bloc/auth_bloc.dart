import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/data/models/reset_password_request.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/reset_password_usecase.dart';
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
  final ResetPasswordUsecase resetPasswordUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.updatePersonalInfoUsecase,
    required this.resetPasswordUsecase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<UpdatePersonalInfoEvent>(_updatePersonalInfo);
    on<ResetPasswordEvent>(_resetPassword);
    on<AuthReset>((event, emit) {
      emit(AuthInitial());
    });
  }

  void _resetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await resetPasswordUsecase(
      params: ResetPasswordRequest(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
        confirmNewPassword: event.confirmNewPassword,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!, flowType: 'reset_password'));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage, flowType: 'reset_password'));
      return;
    }
  }

  void _updatePersonalInfo(
    UpdatePersonalInfoEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final dataState = await updatePersonalInfoUsecase(params: event.user);

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!, flowType: 'update_personal_info'));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage, flowType: 'update_personal_info'));
      return;
    }
  }

  void _resendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpResendLoading());

    final dataState = await resendOtpUsecase(params: event.email);

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(OtpResendSuccess(dataState.data!, flowType: 'resend_otp'));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage, flowType: 'resend_otp'));
      return;
    }
  }

  void _verifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await verifyOtpUsecase(
      params: VerifyOtpRequest(email: event.email, otp: event.otp),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!, flowType: 'verify_otp'));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage, flowType: 'verify_otp'));
      return;
    }
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await loginUsecase(
      params: AuthRequest(email: event.email, password: event.password),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!, flowType: 'login'));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage, flowType: 'login'));
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
      emit(AuthLoaded(dataState.data!, flowType: 'register'));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(AuthError(dataState.error!, errorMessage: errorMessage, flowType: 'register'));
      return;
    }
  }
}
