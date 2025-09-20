import 'package:dio/dio.dart';
import 'package:social_app_fe/core/constants/constants.dart';
import 'package:social_app_fe/core/network/interceptors/auth_interceptor.dart';
import 'package:social_app_fe/core/network/interceptors/log_interceptor.dart';
import 'package:social_app_fe/core/network/interceptors/response_interceptor.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      AppLogInterceptor(),
      ResponseInterceptor(),
    ]);

    return dio;
  }
}
