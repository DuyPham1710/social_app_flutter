import 'package:dio/dio.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
// import LocalStorage hoặc TokenRepository gì đó để lấy token, refresh token

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
    if (err.response?.statusCode == 401) {
      // Thực hiện refresh token ở đây
      // final newToken = await AuthRepository.refreshToken();
      // err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

      // retry lại request gốc
      // final cloneReq = await dio.fetch(err.requestOptions);
      // return handler.resolve(cloneReq);
    }
    super.onError(err, handler);
  }
}
