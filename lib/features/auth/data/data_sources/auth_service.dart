import 'package:dio/dio.dart';
import 'package:social_app_fe/core/constants/constants.dart';

@RestApi(baseUrl: BASE_URL)
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @Post('/auth/login')
  Future<AuthResponse> login(@Body() AuthRequest request);
}
