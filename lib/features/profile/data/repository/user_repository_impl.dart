import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/profile/data/data_sources/user_remote_data_source.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<UserModel>> getUserProfile() async {
    try {
      final response = await _remoteDataSource.getUserProfile();
      print(">>>>>>>>>>>>>Fetched user profile: $response");

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    } catch (e, st) {
      print("========= Parse error: $e\n$st");
      return DataStateError(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: "Không thể tải thông tin người dùng: $e",
        ),
      );
    }
  }

  @override
  Future<DataState<UserModel>> getUserProfileById(String userId) async {
    try {
      final response = await _remoteDataSource.getUserProfileById(userId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
