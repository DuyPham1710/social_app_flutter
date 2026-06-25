import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/data/models/reset_password_request.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<DataState<UserEntity>> login(AuthRequest request);
  Future<DataState<UserEntity>> register(RegisterRequest request);
  Future<DataState<UserEntity>> verifyOtp(VerifyOtpRequest request);
  Future<DataState<String>> resendOtp(String email);

  Future<DataState<UserEntity>> updatePersonalInfo(UserEntity user);

  Future<DataState<UserEntity>> resetPassword(ResetPasswordRequest request);

  Future<DataState<UserEntity>> getCurrentUser();

  Future<DataState<UserEntity>> refreshToken();

  Future<DataState<Map<String, dynamic>>> registerFace(
    String userId,
    List<String> images,
  );

  Future<DataState<Map<String, dynamic>>> deleteFaceRegistration();

  Future<DataState<void>> deleteIncompleteRegistration(String userId);

  Future<DataState<Map<String, dynamic>>> googleAuth(String idToken);
}
