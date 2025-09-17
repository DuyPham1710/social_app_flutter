import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  const RegisterEvent({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, username, password, confirmPassword];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String email;

  const ResendOtpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdatePersonalInfoEvent extends AuthEvent {
  final UserEntity? user;

  const UpdatePersonalInfoEvent({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthReset extends AuthEvent {}
