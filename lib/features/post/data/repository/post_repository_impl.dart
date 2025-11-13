import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:social_app_fe/features/post/data/models/create_post_model.dart';
import 'package:social_app_fe/features/post/data/models/post_list_model.dart';
import 'package:social_app_fe/features/post/data/models/post_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
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
      String? privacyString = post.privacyType!.name;

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
}
