import 'package:flutter/foundation.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/data_sources/remote/community_remote_data_source.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/data/models/community_list_model.dart';
import 'package:social_app_fe/features/community/data/models/member_model.dart';
import 'package:social_app_fe/features/community/data/models/member_status_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';
import 'package:dio/dio.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;

  CommunityRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<CommunityModel>> createCommunity({
    required String name,
    String? description,
    required String privacy,
    String? avatar,
    String? coverImage,
  }) async {
    try {
      MultipartFile? avatarFile;
      MultipartFile? coverImageFile;

      if (avatar != null && avatar.isNotEmpty) {
        if (kIsWeb) {
          final response = await Dio().get<List<int>>(
            avatar,
            options: Options(responseType: ResponseType.bytes),
          );
          avatarFile = MultipartFile.fromBytes(
            response.data!,
            filename: 'avatar.jpg',
          );
        } else {
          avatarFile = await MultipartFile.fromFile(
            avatar,
            filename: avatar.split('/').last,
          );
        }
      }

      if (coverImage != null && coverImage.isNotEmpty) {
        if (kIsWeb) {
          final response = await Dio().get<List<int>>(
            coverImage,
            options: Options(responseType: ResponseType.bytes),
          );
          coverImageFile = MultipartFile.fromBytes(
            response.data!,
            filename: 'cover.jpg',
          );
        } else {
          coverImageFile = await MultipartFile.fromFile(
            coverImage,
            filename: coverImage.split('/').last,
          );
        }
      }

      final response = await _remoteDataSource.createCommunity(
        name: name,
        description: description,
        privacy: privacy,
        avatar: avatarFile != null ? [avatarFile] : null,
        coverImage: coverImageFile != null ? [coverImageFile] : null,
      );
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<CommunityModel>> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? privacy,
    String? avatar,
    String? coverImage,
  }) async {
    try {
      MultipartFile? avatarFile;
      MultipartFile? coverImageFile;

      if (avatar != null && avatar.isNotEmpty && !avatar.startsWith('http')) {
        if (kIsWeb) {
          final response = await Dio().get<List<int>>(
            avatar,
            options: Options(responseType: ResponseType.bytes),
          );
          avatarFile = MultipartFile.fromBytes(
            response.data!,
            filename: 'avatar.jpg',
          );
        } else {
          avatarFile = await MultipartFile.fromFile(
            avatar,
            filename: avatar.split('/').last,
          );
        }
      }

      if (coverImage != null &&
          coverImage.isNotEmpty &&
          !coverImage.startsWith('http')) {
        if (kIsWeb) {
          final response = await Dio().get<List<int>>(
            coverImage,
            options: Options(responseType: ResponseType.bytes),
          );
          coverImageFile = MultipartFile.fromBytes(
            response.data!,
            filename: 'cover.jpg',
          );
        } else {
          coverImageFile = await MultipartFile.fromFile(
            coverImage,
            filename: coverImage.split('/').last,
          );
        }
      }

      final response = await _remoteDataSource.updateCommunity(
        communityId: communityId,
        name: name,
        description: description,
        privacy: privacy,
        avatar: avatarFile != null ? [avatarFile] : null,
        coverImage: coverImageFile != null ? [coverImageFile] : null,
      );
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> deleteCommunity(String communityId) async {
    try {
      await _remoteDataSource.deleteCommunity(communityId);
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<CommunityListModel>> getAllCommunities({
    required int page,
    required int limit,
    String? search,
  }) async {
    try {
      final response = await _remoteDataSource.getAllCommunities(
        page: page,
        limit: limit,
        search: search,
      );
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<CommunityModel>>> getMyCommunities() async {
    try {
      final response = await _remoteDataSource.getMyCommunities();
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<dynamic>>> getMyInvites() async {
    try {
      final response = await _remoteDataSource.getMyInvites();
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<CommunityModel>> getCommunityDetail(
    String communityId,
  ) async {
    try {
      final response = await _remoteDataSource.getCommunityDetail(communityId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> joinCommunity(String communityId) async {
    try {
      await _remoteDataSource.joinCommunity(communityId);
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> cancelJoinRequest(String communityId) async {
    try {
      await _remoteDataSource.cancelJoinRequest(communityId);
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> leaveCommunity(String communityId) async {
    try {
      await _remoteDataSource.leaveCommunity(communityId);
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<MemberStatusModel>> getMemberStatus(
    String communityId,
  ) async {
    try {
      final response = await _remoteDataSource.getMemberStatus(communityId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<MemberModel>>> getMembers({
    required String communityId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _remoteDataSource.getMembers(
        communityId: communityId,
        page: page,
        limit: limit,
      );
      return DataStateSuccess(response.data);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> kickMember({
    required String communityId,
    required String memberId,
  }) async {
    try {
      await _remoteDataSource.kickMember(
        communityId: communityId,
        memberId: memberId,
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> promoteToAdmin({
    required String communityId,
    required String memberId,
  }) async {
    try {
      await _remoteDataSource.promoteToAdmin(
        communityId: communityId,
        memberId: memberId,
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> demoteAdmin({
    required String communityId,
    required String memberId,
  }) async {
    try {
      await _remoteDataSource.demoteAdmin(
        communityId: communityId,
        memberId: memberId,
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> inviteMember({
    required String communityId,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.inviteMember(
        communityId: communityId,
        body: {'userId': userId},
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<dynamic>>> getAvailableFriends({
    required String communityId,
  }) async {
    try {
      final response = await _remoteDataSource.getAvailableFriends(
        communityId: communityId,
      );
      // Convert dynamic response to List<dynamic>
      List<dynamic> friendsList = response is List ? response : [];
      return DataStateSuccess(friendsList);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> inviteFriend({
    required String communityId,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.inviteFriend(
        communityId: communityId,
        body: {'userId': userId},
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<CommunityRequestModel>>> getPendingRequests(
    String communityId,
  ) async {
    try {
      final response = await _remoteDataSource.getPendingRequests(communityId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> respondToJoinRequest({
    required String communityId,
    required String requestId,
    required String action,
  }) async {
    try {
      await _remoteDataSource.respondToJoinRequest(
        communityId: communityId,
        requestId: requestId,
        body: {'action': action},
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> respondToInvite({
    required String communityId,
    required String requestId,
    required String action,
  }) async {
    try {
      await _remoteDataSource.respondToInvite(
        communityId: communityId,
        requestId: requestId,
        body: {'action': action},
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<CommunityPostModel>>> getCommunityPosts({
    required String communityId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _remoteDataSource.getCommunityPosts(
        communityId: communityId,
        page: page,
        limit: limit,
      );
      return DataStateSuccess(response.data);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<CommunityPostModel>>> getPendingPosts({
    required String communityId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _remoteDataSource.getPendingPosts(
        communityId: communityId,
        page: page,
        limit: limit,
      );
      // Extract posts from CommunityPostListModel
      return DataStateSuccess(response.data);
    } on DioException catch (e) {
      debugPrint('[getPendingPosts] DioException: ${e.message}');
      return DataStateError(e);
    } catch (e, stackTrace) {
      debugPrint('[getPendingPosts] Exception: $e');
      debugPrint('[getPendingPosts] StackTrace: $stackTrace');
      return DataStateError(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> approveCommunityPost({
    required String communityId,
    required String postId,
    required String action,
  }) async {
    try {
      await _remoteDataSource.approveCommunityPost(
        communityId: communityId,
        postId: postId,
        body: {'action': action},
      );
      return DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
