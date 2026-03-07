import 'package:dio/dio.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/interceptors/log_interceptor.dart';
import 'package:social_app_fe/core/network/interceptors/response_interceptor.dart';
import 'package:social_app_fe/core/network/services/token_refresh_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Kiểm tra nếu là 401 và không phải request refresh hoặc login
    if (err.response?.statusCode == 401 &&
        !_isAuthRequest(err.requestOptions)) {
      try {
        // refresh token
        final newAccessToken = await TokenRefreshService.refreshToken();

        if (newAccessToken != null) {
          // Refresh thành công, cập nhật header cho request gốc
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';

          // Tạo Dio instance mới để retry request với base config nhưng không auth interceptor
          final dio = Dio();
          dio.options.baseUrl = err.requestOptions.baseUrl;
          dio.options.connectTimeout = err.requestOptions.connectTimeout;
          dio.options.receiveTimeout = err.requestOptions.receiveTimeout;

          // Thêm ResponseInterceptor để unwrap response.data
          dio.interceptors.addAll([AppLogInterceptor(), ResponseInterceptor()]);

          // Retry request gốc
          try {
            final cloneResponse = await dio.fetch(err.requestOptions);
            return handler.resolve(cloneResponse);
          } catch (retryError) {
            return handler.reject(err);
          }
        } else {
          // Refresh thất bại, xoá token và để lỗi 401 đi qua
          await TokenStorage.clear();
          return handler.reject(err);
        }
      } catch (e) {
        // Lỗi khi refresh, xoá token và để lỗi 401 đi qua
        await TokenStorage.clear();
        return handler.reject(err);
      }
    }

    super.onError(err, handler);
  }

  /// Kiểm tra xem có phải request auth không (để tránh infinite loop)
  bool _isAuthRequest(RequestOptions options) {
    return options.path.contains('/auth/refresh') ||
        options.path.contains('/auth/login') ||
        options.path.contains('/auth/register');
  }
}
