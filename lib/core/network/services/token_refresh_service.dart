import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/local/token_storage.dart';

class TokenRefreshService {
  static Future<String?> refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      // Tạo Dio instance riêng cho refresh (không có interceptor để tránh loop)
      final dio = Dio();
      final baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.100.218:3000/';

      final response = await dio.post(
        '${baseUrl}auth/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('data')) {
            final data = responseData['data'];
            final newAccessToken = data['accessToken'];
            final newRefreshToken = data['refreshToken'];
            final user = data['user'];

            // Lưu token mới
            await TokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
              userData: {
                'id': user['userId'],
                'fullName': user['fullName'],
                'email': user['email'],
                'username': user['username'],
                'avatarUrl': user['avatarUrl'],
              },
            );

            return newAccessToken;
          }
        }
      }

      return null;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }
}
