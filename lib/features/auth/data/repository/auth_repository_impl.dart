import 'package:dio/dio.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/data/models/reset_password_request.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<DataState<UserModel>> login(AuthRequest request) async {
    try {
      final response = await authService.login(request);

      // Save token and user data to local storage
      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userData: {
          'id': response.user.userId,
          'fullName': response.user.fullName,
          'email': response.user.email,
          'username': response.user.username,
          'avatarUrl': response.user.avatarUrl,
        },
      );

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

  @override
  Future<DataState<UserModel>> updatePersonalInfo(UserEntity user) async {
    try {
      final response = await authService.updatePersonalInfo(user as UserModel);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<UserEntity>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await authService.resetPassword(request);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<UserEntity>> getCurrentUser() async {
    try {
      final userData = await TokenStorage.getUserData();
      if (userData == null) {
        return DataStateError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: "No user data found",
          ),
        );
      }

      final user = UserModel(
        userId: userData['id'],
        fullName: userData['fullName'],
        email: userData['email'],
        username: userData['username'],
        avatarUrl: userData['avatarUrl'],
      );

      return DataStateSuccess(user);
    } catch (e) {
      return DataStateError(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: "Failed to load user",
        ),
      );
    }
  }

  @override
  Future<DataState<UserEntity>> refreshToken() async {
    try {
      final response = await authService.refreshToken();

      // Save new tokens to local storage
      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userData: {
          'id': response.user.userId,
          'fullName': response.user.fullName,
          'email': response.user.email,
          'username': response.user.username,
          'avatarUrl': response.user.avatarUrl,
        },
      );

      return DataStateSuccess(response.user);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> registerFace(
    String userId,
    List<String> images,
  ) async {
    try {
      final response = await authService.registerFace({
        'userId': userId,
        'images': images,
      });
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> deleteFaceRegistration() async {
    try {
      final response = await authService.deleteFaceRegistration();
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
