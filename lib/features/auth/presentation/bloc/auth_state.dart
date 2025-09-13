import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  final UserEntity? user;
  final DioException? error;
  final String? errorMessage;

  const AuthState({this.user, this.error, this.errorMessage});

  @override
  List<Object?> get props => [user, error, errorMessage];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  const AuthLoaded(UserEntity user) : super(user: user);
}

class AuthError extends AuthState {
  const AuthError(DioException error, {String? errorMessage}) 
      : super(error: error, errorMessage: errorMessage);
}
