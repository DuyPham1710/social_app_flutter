import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
import 'package:social_app_fe/features/auth/domain/usecases/submit_face_registration_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/update_personal_info_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/delete_incomplete_registration_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/google_auth_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final UpdatePersonalInfoUsecase updatePersonalInfoUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final SubmitFaceRegistrationUsecase submitFaceRegistrationUsecase;
  final DeleteIncompleteRegistrationUsecase deleteIncompleteRegistrationUsecase;
  final GoogleAuthUsecase googleAuthUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.updatePersonalInfoUsecase,
    required this.resetPasswordUsecase,
    required this.submitFaceRegistrationUsecase,
    required this.deleteIncompleteRegistrationUsecase,
    required this.googleAuthUsecase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<UpdatePersonalInfoEvent>(_updatePersonalInfo);
    on<ResetPasswordEvent>(_resetPassword);
    on<SubmitFaceRegistrationEvent>(_submitFaceRegistration);
    on<DeleteIncompleteRegistrationEvent>(_deleteIncompleteRegistration);
    on<GoogleSignInEvent>(_googleSignIn);
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
      emit(
        AuthError(
          dataState.error!,
          errorMessage: errorMessage,
          flowType: 'reset_password',
        ),
      );
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
      emit(
        AuthError(
          dataState.error!,
          errorMessage: errorMessage,
          flowType: 'update_personal_info',
        ),
      );
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
      emit(
        AuthError(
          dataState.error!,
          errorMessage: errorMessage,
          flowType: 'resend_otp',
        ),
      );
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
      emit(
        AuthError(
          dataState.error!,
          errorMessage: errorMessage,
          flowType: 'verify_otp',
        ),
      );
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
      emit(
        AuthError(
          dataState.error!,
          errorMessage: errorMessage,
          flowType: 'login',
        ),
      );
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
      emit(
        AuthError(
          dataState.error!,
          errorMessage: errorMessage,
          flowType: 'register',
        ),
      );
      return;
    }
  }

  void _submitFaceRegistration(
    SubmitFaceRegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(FaceRegistrationLoading());

    try {
      debugPrint(
        '[AuthBloc] Submitting face registration for user ${event.userId} (${event.base64Images.length} images)',
      );

      final dataState = await submitFaceRegistrationUsecase(
        params: SubmitFaceRegistrationParams(
          userId: event.userId,
          base64Images: event.base64Images,
        ),
      );

      if (dataState is DataStateSuccess && dataState.data != null) {
        final data = dataState.data!;
        if (data['success'] == true) {
          debugPrint(
            '[AuthBloc] Face registration success: ${data['message']}',
          );
          emit(
            FaceRegistrationSuccess(
              message: data['message'] ?? 'Đăng ký khuôn mặt thành công',
              embeddingsSaved: data['embeddings_saved'] ?? 0,
            ),
          );
        } else {
          debugPrint('[AuthBloc] Face registration failed: ${data['message']}');
          emit(
            FaceRegistrationError(
              message: data['message'] ?? 'Đăng ký khuôn mặt thất bại',
              failedPose: data['failed_pose'],
            ),
          );
        }
      } else {
        final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
        debugPrint('[AuthBloc] Face registration error: $errorMessage');
        emit(
          FaceRegistrationError(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Lỗi kết nối. Vui lòng thử lại.',
          ),
        );
      }
    } catch (e) {
      debugPrint('[AuthBloc] Face registration error: $e');
      emit(FaceRegistrationError(message: 'Đã xảy ra lỗi. Vui lòng thử lại.'));
    }
  }

  void _deleteIncompleteRegistration(
    DeleteIncompleteRegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    await deleteIncompleteRegistrationUsecase(params: event.userId);
  }

  void _googleSignIn(GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Sign in with Google
      final googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled
        emit(AuthInitial());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(
          AuthError(
            DioException(
              requestOptions: RequestOptions(path: ''),
              error: 'Không lấy được token từ Google',
            ),
            errorMessage: 'Không lấy được token từ Google',
            flowType: 'google_sign_in',
          ),
        );
        return;
      }

      // Send idToken to backend
      final dataState = await googleAuthUsecase(params: idToken);

      if (dataState is DataStateSuccess && dataState.data != null) {
        final user = dataState.data!['user'];
        final isNewUser = dataState.data!['isNewUser'] as bool? ?? false;

        if (isNewUser) {
          emit(AuthLoaded(user, flowType: 'google_new_user'));
        } else {
          emit(AuthLoaded(user, flowType: 'login'));
        }
      } else {
        final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
        emit(
          AuthError(
            dataState.error!,
            errorMessage: errorMessage,
            flowType: 'google_sign_in',
          ),
        );
      }
    } catch (e) {
      debugPrint('[AuthBloc] Google sign-in error: $e');
      emit(
        AuthError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: e.toString(),
          ),
          errorMessage: 'Đăng nhập Google thất bại: $e',
          flowType: 'google_sign_in',
        ),
      );
    }
  }
}
