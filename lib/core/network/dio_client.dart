import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/network/interceptors/auth_interceptor.dart';
import 'package:social_app_fe/core/network/interceptors/log_interceptor.dart';
import 'package:social_app_fe/core/network/interceptors/response_interceptor.dart';
import 'dart:io';
import 'package:dio/io.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? 'http://192.168.100.218:3000/',
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
