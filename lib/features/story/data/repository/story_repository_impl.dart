import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/data/data_sources/remote/story_remote_data_source.dart';
import 'package:social_app_fe/features/story/data/models/grouped_story_list_model.dart';
import 'package:social_app_fe/features/story/data/models/react_story_model.dart';
import 'package:social_app_fe/features/story/domain/entities/create_story_entity.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<GroupedStoryListModel>> getHomeStories({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getHomeStories(page, limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<GroupedStoryListModel>> getMyArchivedStories({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.getMyArchivedStories(page, limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> createStory({
    required CreateStoryEntity story,
  }) async {
    try {
      // Convert file to List<MultipartFile> nếu có
      List<MultipartFile>? multipartFiles;
      if (story.fileBytes != null && story.fileName != null) {
        multipartFiles = [
          MultipartFile.fromBytes(
            story.fileBytes!,
            filename: story.fileName,
          ),
        ];
      } else if (story.file != null) {
        multipartFiles = [
          await MultipartFile.fromFile(
            story.file!.path,
            filename: story.file!.path.split('/').last,
          ),
        ];
      }

      // Convert music to JSON string nếu có
      String? musicJson;
      if (story.music != null) {
        musicJson = jsonEncode({
          'id': story.music!.id,
          'title': story.music!.title,
          'preview': story.music!.preview,
          'artist': {
            'id': story.music!.artist.id,
            'name': story.music!.artist.name,
            'picture': story.music!.artist.picture,
          },
          'album': {
            'id': story.music!.album.id,
            'title': story.music!.album.title,
            'cover': story.music!.album.cover,
          },
        });
      }

      // Convert lists to JSON strings
      String? friendsExceptJson;
      if (story.friendsExcept != null && story.friendsExcept!.isNotEmpty) {
        friendsExceptJson = jsonEncode(story.friendsExcept);
      }

      String? friendsDetailJson;
      if (story.friendsDetail != null && story.friendsDetail!.isNotEmpty) {
        friendsDetailJson = jsonEncode(story.friendsDetail);
      }

      // Map privacy type to string
      final privacyTypeString = switch (story.privacyType) {
        PrivacyType.public => 'public',
        PrivacyType.friends => 'friends',
        PrivacyType.friendsExcept => 'friends_except',
        PrivacyType.friendsDetail => 'friends_detail',
        PrivacyType.private => 'private',
      };

      await remoteDataSource.createStory(
        story.title,
        story.mediaType.name,
        musicJson,
        privacyTypeString,
        friendsExceptJson,
        friendsDetailJson,
        multipartFiles,
      );
      // Nếu không throw exception coi như thành công
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> updateStoryPrivacy({
    required String storyId,
    required PrivacyType privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
  }) async {
    try {
      // Map privacy type to string
      final privacyTypeString = switch (privacyType) {
        PrivacyType.public => 'public',
        PrivacyType.friends => 'friends',
        PrivacyType.friendsExcept => 'friends_except',
        PrivacyType.friendsDetail => 'friends_detail',
        PrivacyType.private => 'private',
      };

      // Build request body
      final Map<String, dynamic> body = {'privacy_type': privacyTypeString};

      if (friendsExcept != null && friendsExcept.isNotEmpty) {
        body['friends_except'] = friendsExcept;
      }

      if (friendsDetail != null && friendsDetail.isNotEmpty) {
        body['friends_detail'] = friendsDetail;
      }

      await remoteDataSource.updateStoryPrivacy(storyId, body);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> deleteStory({required String storyId}) async {
    try {
      await remoteDataSource.deleteStory(storyId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> archiveStory({required String storyId}) async {
    try {
      await remoteDataSource.archiveStory(storyId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<ReactStoryModel?>> createOrUpdateReactStory({
    required String storyId,
    required String emojiId,
  }) async {
    try {
      final response = await remoteDataSource.createOrUpdateReactStory({
        'storyId': storyId,
        'emojiId': emojiId,
      });
      return DataStateSuccess(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 204 ||
          (e.response?.statusCode == 200 && e.response?.data == null)) {
        return DataStateSuccess(null);
      }
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<ReactStoryModel>>> getStoryReacts({
    required String storyId,
  }) async {
    try {
      final response = await remoteDataSource.getStoryReacts(storyId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>?>> checkUserReactStory({
    required String storyId,
  }) async {
    try {
      final response = await remoteDataSource.checkUserReactStory(storyId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<ReactStoryModel>> updateReactStory({
    required String storyId,
    required String emojiId,
  }) async {
    try {
      final response = await remoteDataSource.updateReactStory(storyId, {
        'emojiId': emojiId,
      });
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> deleteReactStory({required String storyId}) async {
    try {
      await remoteDataSource.deleteReactStory(storyId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
