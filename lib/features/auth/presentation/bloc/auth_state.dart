import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  final UserEntity? user;
  final DioException? error;

  const AuthState({this.user, this.error});

  @override
  List<Object?> get props => [user, error];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  const AuthLoaded(UserEntity user) : super(user: user);
}

class AuthError extends AuthState {
  const AuthError(DioException error) : super(error: error);
}
