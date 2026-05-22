import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  final UserEntity? user;
  final DioException? error;
  final String? errorMessage;
  final String? flowType; // 'register', 'login', 'verify_otp', 'reset_password'

  const AuthState({this.user, this.error, this.errorMessage, this.flowType});

  @override
  List<Object?> get props => [user, error, errorMessage, flowType];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  const AuthLoaded(UserEntity user, {super.flowType}) : super(user: user);
}

class AuthError extends AuthState {
  const AuthError(DioException error, {super.errorMessage, super.flowType})
    : super(error: error);
}

// OTP Resend States
class OtpResendLoading extends AuthState {}

class OtpResendSuccess extends AuthState {
  final String message;
  const OtpResendSuccess(this.message, {super.flowType});

  @override
  List<Object?> get props => [message, flowType];
}

class OtpResendError extends AuthState {
  final String message;
  const OtpResendError(this.message);
}

// Face Registration States
class FaceRegistrationLoading extends AuthState {}

class FaceRegistrationSuccess extends AuthState {
  final String message;
  final int embeddingsSaved;

  const FaceRegistrationSuccess({
    required this.message,
    required this.embeddingsSaved,
  });

  @override
  List<Object?> get props => [message, embeddingsSaved];
}

class FaceRegistrationError extends AuthState {
  final String message;
  final String? failedPose;

  const FaceRegistrationError({required this.message, this.failedPose});

  @override
  List<Object?> get props => [message, failedPose];
}
