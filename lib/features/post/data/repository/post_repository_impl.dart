import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:social_app_fe/features/post/data/models/create_post_model.dart';
import 'package:social_app_fe/features/post/data/models/post_list_model.dart';
import 'package:social_app_fe/features/post/data/models/post_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/post/data/models/post_translation_model.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<PostListModel>> getHomePosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getHomePosts(page, limit);

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<ReactPostModel>> reactPost({
    required String postId,
    required String emoji,
  }) async {
    try {
      final response = await remoteDataSource.reactPost({
        'postId': postId,
        'emojiId': emoji,
      });

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PostModel>> getPostDetail({required String postId}) async {
    try {
      final response = await remoteDataSource.getPostDetail(postId);

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PostListModel>> getProfilePosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getProfilePosts(page, limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PostListModel>> getUserPosts({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getUserPosts(userId, page, limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<String>> createPost({required CreatePostEntity post}) async {
    try {
      final model = CreatePostModel.fromEntity(post);
      // Convert Files to MultipartFiles
      List<MultipartFile>? multipartFiles;
      if (model.files != null && model.files!.isNotEmpty) {
        multipartFiles = [];
        for (var file in model.files!) {
          final multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
          multipartFiles.add(multipartFile);
        }
      }

      String? layoutString = post.layout!.name;
      String? privacyString = PrivacyUtil.privacyTypeToApiString(post.privacyType!);

      // Convert lists to JSON strings
      final ordersString = post.orders != null ? jsonEncode(post.orders) : null;
      final titlesString = post.titles != null ? jsonEncode(post.titles) : null;
      final friendsExceptString = post.friendsExcept != null
          ? jsonEncode(post.friendsExcept)
          : null;
      final friendsDetailString = post.friendsDetail != null
          ? jsonEncode(post.friendsDetail)
          : null;

      final response = await remoteDataSource.createPost(
        post.caption,
        layoutString,
        privacyString,
        ordersString,
        titlesString,
        friendsExceptString,
        friendsDetailString,
        multipartFiles,
      );

      return DataStateSuccess(response.message);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> reportPost({
    required String postId,
    required String reason,
    String? description,
  }) async {
    try {
      await remoteDataSource.reportPost(postId, {
        'reason': reason,
        if (description != null && description.isNotEmpty)
          'description': description,
      });
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> updatePostPrivacy({
    required String postId,
    required PrivacyType privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
  }) async {
    try {
      // Map privacy type to string
      String privacyTypeString;
      switch (privacyType) {
        case PrivacyType.public:
          privacyTypeString = 'public';
          break;
        case PrivacyType.friends:
          privacyTypeString = 'friends';
          break;
        case PrivacyType.friendsExcept:
          privacyTypeString = 'friends_except';
          break;
        case PrivacyType.friendsDetail:
          privacyTypeString = 'friends_detail';
          break;
        case PrivacyType.private:
          privacyTypeString = 'private';
          break;
      }

      // Build request body - luôn gửi cả hai field để backend có thể clear đúng
      final Map<String, dynamic> body = {
        'privacy_type': privacyTypeString,
      };

      // Gửi friends_except nếu privacy_type là friendsExcept và có dữ liệu
      if (privacyType == PrivacyType.friendsExcept && friendsExcept != null && friendsExcept.isNotEmpty) {
        body['friends_except'] = friendsExcept;
      } else {
        // Gửi null để backend clear field này
        body['friends_except'] = null;
      }

      // Gửi friends_detail nếu privacy_type là friendsDetail và có dữ liệu
      if (privacyType == PrivacyType.friendsDetail && friendsDetail != null && friendsDetail.isNotEmpty) {
        body['friends_detail'] = friendsDetail;
      } else {
        // Gửi null để backend clear field này
        body['friends_detail'] = null;
      }

      await remoteDataSource.updatePostPrivacy(postId, body);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> deletePost({
    required String postId,
  }) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PostTranslationModel>> translateCaption({
    required String postId,
    String targetLang = 'vi',
  }) async {
    try {
      final response =
          await remoteDataSource.translateCaption(postId, targetLang);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
