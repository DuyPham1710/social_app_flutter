import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/data/models/community_list_model.dart';
import 'package:social_app_fe/features/community/data/models/member_model.dart';
import 'package:social_app_fe/features/community/data/models/member_status_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/data/models/roadmap_point_list_model.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

abstract class CommunityRepository {
  // Community CRUD
  Future<DataState<CommunityModel>> createCommunity({
    required String name,
    String? description,
    required String privacy,
    String? type,
    String? avatar,
    String? coverImage,
  });

  Future<DataState<CommunityModel>> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? privacy,
    String? avatar,
    String? coverImage,
  });

  Future<DataState<void>> deleteCommunity(String communityId);

  Future<DataState<CommunityListModel>> getAllCommunities({
    required int page,
    required int limit,
    String? search,
  });

  Future<DataState<List<CommunityModel>>> getMyCommunities();

  Future<DataState<List<dynamic>>> getMyInvites();

  Future<DataState<CommunityModel>> getCommunityDetail(String communityId);

  // Member Management
  Future<DataState<void>> joinCommunity(String communityId);

  Future<DataState<void>> cancelJoinRequest(String communityId);

  Future<DataState<void>> leaveCommunity(String communityId);

  Future<DataState<MemberStatusModel>> getMemberStatus(String communityId);

  Future<DataState<List<MemberModel>>> getMembers({
    required String communityId,
    required int page,
    required int limit,
  });

  Future<DataState<void>> kickMember({
    required String communityId,
    required String memberId,
  });

  Future<DataState<void>> promoteToAdmin({
    required String communityId,
    required String memberId,
  });

  Future<DataState<void>> demoteAdmin({
    required String communityId,
    required String memberId,
  });

  // Request Management
  Future<DataState<List<CommunityRequestModel>>> getPendingRequests(
    String communityId,
  );

  Future<DataState<void>> respondToJoinRequest({
    required String communityId,
    required String requestId,
    required String action, // 'approve' or 'reject'
  });

  Future<DataState<void>> respondToInvite({
    required String communityId,
    required String requestId,
    required String action, // 'approve' or 'reject'
  });

  Future<DataState<void>> inviteMember({
    required String communityId,
    required String userId,
  });

  Future<DataState<List<dynamic>>> getAvailableFriends({
    required String communityId,
  });

  Future<DataState<void>> inviteFriend({
    required String communityId,
    required String userId,
  });

  // Posts
  Future<DataState<List<PostEntity>>> getCommunityPosts({
    required String communityId,
    required int page,
    required int limit,
  });

  Future<DataState<List<PostEntity>>> getPendingPosts({
    required String communityId,
    required int page,
    required int limit,
  });

  Future<DataState<void>> approveCommunityPost({
    required String communityId,
    required String postId,
    required String action, // 'approve' or 'reject'
  });

  // Roadmap Management
  Future<DataState<RoadmapPointListModel>> getRoadmapPoints({
    required String communityId,
    int? page,
    int? limit,
  });

  Future<DataState<RoadmapPointListModel>> getNearbyRoadmapPoints({
    required String communityId,
    required double lat,
    required double lng,
    double? radius,
  });

  Future<DataState<List<PostEntity>>> getRoadmapPointPosts({
    required String communityId,
    required String roadmapId,
    int? page,
    int? limit,
  });
}
