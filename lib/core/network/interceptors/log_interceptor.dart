import 'package:dio/dio.dart';

class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("[Request] ${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Data: ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("[Response] [${response.statusCode}] ${response.requestOptions.uri}");
    print("Data: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("[Error] [${err.response?.statusCode}] ${err.requestOptions.uri}");
    print("Message: ${err.message}");
    print("Data: ${err.response?.data}");
    // Nếu response.data là Map và có trường 'message', log riêng message
    final data = err.response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      print("Error message from response: ${data['message']}");
    }
    super.onError(err, handler);
  }
}
