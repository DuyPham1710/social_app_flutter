import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/auth_response.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/data/models/reset_password_request.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() AuthRequest request);

  @POST('/auth/register')
  Future<UserModel> register(@Body() RegisterRequest request);

  @PATCH('/auth/verify-account')
  Future<UserModel> verifyOtp(@Body() VerifyOtpRequest request);

  @PATCH('/auth/resend-otp')
  Future<Map<String, dynamic>> resendOtp(@Body() Map<String, dynamic> email);

  @PUT('/user')
  Future<UserModel> updatePersonalInfo(@Body() UserModel user);

  @PATCH('/auth/reset-password')
  Future<UserModel> resetPassword(@Body() ResetPasswordRequest request);

  @POST('/auth/refresh')
  Future<AuthResponse> refreshToken();
}
