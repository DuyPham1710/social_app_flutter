import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:social_app_fe/core/constants/constants.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/data/models/auth_response.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() AuthRequest request);
}
