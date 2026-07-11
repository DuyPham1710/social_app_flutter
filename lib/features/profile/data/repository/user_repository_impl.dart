import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/data/data_sources/user_remote_data_source.dart';
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final Dio _dio;

  UserRepositoryImpl(this._remoteDataSource, this._dio);

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

  @override
  Future<DataState<UserEntity>> updateUserProfile(
    UpdateUserEntity params,
  ) async {
    try {
      MultipartFile? avatarMultipart;
      if (params.avatarBytes != null && params.avatarName != null) {
        avatarMultipart = MultipartFile.fromBytes(
          params.avatarBytes!,
          filename: params.avatarName,
        );
      } else if (params.avatarFile != null) {
        avatarMultipart = await MultipartFile.fromFile(
          params.avatarFile!.path,
          filename: params.avatarFile!.path.split('/').last,
        );
      }

      MultipartFile? coverMultipart;
      if (params.coverBytes != null && params.coverName != null) {
        coverMultipart = MultipartFile.fromBytes(
          params.coverBytes!,
          filename: params.coverName,
        );
      } else if (params.coverFile != null) {
        coverMultipart = await MultipartFile.fromFile(
          params.coverFile!.path,
          filename: params.coverFile!.path.split('/').last,
        );
      }

      final userModel = await _remoteDataSource.updateUserProfile(
        fullName: params.fullName,
        phoneNumber: null,
        dateOfBirth: null,
        gender: null,
        bio: params.bio,
        school: params.school,
        currentCity: params.currentCity,
        hometown: params.hometown,
        workplace: params.workplace,
        relationshipStatus: params.relationshipStatus,

        // File ảnh
        avatarFile: avatarMultipart != null ? [avatarMultipart] : null,
        coverFile: coverMultipart != null ? [coverMultipart] : null,
      );

      return DataStateSuccess(userModel);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> reportUser({
    required String reportedUserId,
    required String reason,
    String? description,
  }) async {
    try {
      await _remoteDataSource.reportUser(reportedUserId, {
        'reason': reason,
        if (description != null) 'description': description,
      });
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> getNotificationSettings() async {
    try {
      final response = await _dio.get('/user/notification-settings');
      final data = response.data as Map<String, dynamic>;
      return DataStateSuccess(data);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> updateNotificationSettings({
    bool? notifyOnFaceDetected,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (notifyOnFaceDetected != null) {
        body['notifyOnFaceDetected'] = notifyOnFaceDetected;
      }
      final response = await _dio.patch(
        '/user/notification-settings',
        data: body,
      );
      final data = response.data as Map<String, dynamic>;
      return DataStateSuccess(data);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
