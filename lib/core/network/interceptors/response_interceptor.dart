import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = response.data;

    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data')) {
        response.data = responseData['data'];
      }
    }

    super.onResponse(response, handler);
  }
}
