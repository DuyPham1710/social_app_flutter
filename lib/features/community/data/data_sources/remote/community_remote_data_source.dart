import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/data/models/community_list_model.dart';
import 'package:social_app_fe/features/community/data/models/member_model.dart';
import 'package:social_app_fe/features/community/data/models/member_list_model.dart';
import 'package:social_app_fe/features/community/data/models/member_status_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/data/models/community_post_list_model.dart';
import 'package:social_app_fe/features/community/data/models/community_invite_model.dart';

part 'community_remote_data_source.g.dart';

@RestApi()
abstract class CommunityRemoteDataSource {
  factory CommunityRemoteDataSource(Dio dio, {String baseUrl}) =
      _CommunityRemoteDataSource;

  @POST('/community')
  @MultiPart()
  Future<CommunityModel> createCommunity({
    @Part(name: 'name') required String name,
    @Part(name: 'description') String? description,
    @Part(name: 'privacy') required String privacy,
    @Part(name: 'avatar') List<MultipartFile>? avatar,
    @Part(name: 'coverImage') List<MultipartFile>? coverImage,
  });

  @GET('/community')
  Future<CommunityListModel> getAllCommunities({
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('search') String? search,
  });

  @GET('/community/me')
  Future<List<CommunityModel>> getMyCommunities();

  @GET('/community/invites')
  Future<List<CommunityInviteModel>> getMyInvites();

  @GET('/community/{communityId}')
  Future<CommunityModel> getCommunityDetail(
    @Path('communityId') String communityId,
  );

  @POST('/community/{communityId}/join')
  Future<void> joinCommunity(@Path('communityId') String communityId);

  @DELETE('/community/{communityId}/join')
  Future<void> cancelJoinRequest(@Path('communityId') String communityId);

  @DELETE('/community/{communityId}/leave')
  Future<void> leaveCommunity(@Path('communityId') String communityId);

  @GET('/community/{communityId}/members/status')
  Future<MemberStatusModel> getMemberStatus(
    @Path('communityId') String communityId,
  );

  @GET('/community/{communityId}/members')
  Future<MemberListModel> getMembers({
    @Path('communityId') required String communityId,
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  @GET('/community/{communityId}/available-friends')
  Future<dynamic> getAvailableFriends({
    @Path('communityId') required String communityId,
  });

  @DELETE('/community/{communityId}/members/{memberId}')
  Future<void> kickMember({
    @Path('communityId') required String communityId,
    @Path('memberId') required String memberId,
  });

  @PATCH('/community/{communityId}/members/{memberId}/promote')
  Future<void> promoteToAdmin({
    @Path('communityId') required String communityId,
    @Path('memberId') required String memberId,
  });

  @PATCH('/community/{communityId}/members/{memberId}/demote')
  Future<void> demoteAdmin({
    @Path('communityId') required String communityId,
    @Path('memberId') required String memberId,
  });

  @POST('/community/{communityId}/invite')
  Future<void> inviteMember({
    @Path('communityId') required String communityId,
    @Body() required Map<String, dynamic> body,
  });

  @POST('/community/{communityId}/invite-friend')
  Future<void> inviteFriend({
    @Path('communityId') required String communityId,
    @Body() required Map<String, dynamic> body,
  });

  @GET('/community/{communityId}/requests')
  Future<List<CommunityRequestModel>> getPendingRequests(
    @Path('communityId') String communityId,
  );

  @PATCH('/community/{communityId}/requests/{requestId}')
  Future<void> respondToJoinRequest({
    @Path('communityId') required String communityId,
    @Path('requestId') required String requestId,
    @Body() required Map<String, dynamic> body,
  });

  @PATCH('/community/{communityId}/invites/{requestId}')
  Future<void> respondToInvite({
    @Path('communityId') required String communityId,
    @Path('requestId') required String requestId,
    @Body() required Map<String, dynamic> body,
  });

  @GET('/community/{communityId}/posts')
  Future<CommunityPostListModel> getCommunityPosts({
    @Path('communityId') required String communityId,
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  @GET('/community/{communityId}/posts/pending')
  Future<CommunityPostListModel> getPendingPosts({
    @Path('communityId') required String communityId,
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  @PATCH('/community/{communityId}/posts/{postId}')
  Future<void> approveCommunityPost({
    @Path('communityId') required String communityId,
    @Path('postId') required String postId,
    @Body() required Map<String, dynamic> body,
  });
}
