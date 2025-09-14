import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<DataState<UserModel>> login(AuthRequest request) async {
    try {
      final response = await authService.login(request);
      return DataStateSuccess(response.user);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<UserModel>> register(RegisterRequest request) async {
    try {
      final response = await authService.register(request);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<UserModel>> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await authService.verifyOtp(request);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<String>> resendOtp(String email) async {
    try {
      final Map<String, dynamic> response = await authService.resendOtp({
        "email": email,
      });
      return DataStateSuccess(response['message']);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
