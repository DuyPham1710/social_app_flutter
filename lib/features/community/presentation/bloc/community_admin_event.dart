part of 'community_admin_bloc.dart';

abstract class CommunityAdminEvent {
  CommunityAdminEvent();
}

class GetPendingRequestsRequested extends CommunityAdminEvent {
  final String communityId;

  GetPendingRequestsRequested(this.communityId);
}

class RespondToJoinRequestRequested extends CommunityAdminEvent {
  final String communityId;
  final String requestId;
  final String action;

  RespondToJoinRequestRequested({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}

class GetPendingPostsRequested extends CommunityAdminEvent {
  final String communityId;
  final int page;
  final int limit;

  GetPendingPostsRequested({
    required this.communityId,
    required this.page,
    required this.limit,
  });
}

class ApproveCommunityPostRequested extends CommunityAdminEvent {
  final String communityId;
  final String postId;
  final String action;

  ApproveCommunityPostRequested({
    required this.communityId,
    required this.postId,
    required this.action,
  });
}

class KickMemberRequested extends CommunityAdminEvent {
  final String communityId;
  final String memberId;

  KickMemberRequested({
    required this.communityId,
    required this.memberId,
  });
}

class PromoteToAdminRequested extends CommunityAdminEvent {
  final String communityId;
  final String memberId;

  PromoteToAdminRequested({
    required this.communityId,
    required this.memberId,
  });
}

class DemoteAdminRequested extends CommunityAdminEvent {
  final String communityId;
  final String memberId;

  DemoteAdminRequested({
    required this.communityId,
    required this.memberId,
  });
}
