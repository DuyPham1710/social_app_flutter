part of 'community_admin_bloc.dart';

abstract class CommunityAdminEvent {
  const CommunityAdminEvent();
}

class GetPendingRequestsRequested extends CommunityAdminEvent {
  final String communityId;

  const GetPendingRequestsRequested(this.communityId);
}

class RespondToJoinRequestRequested extends CommunityAdminEvent {
  final String communityId;
  final String requestId;
  final String action;

  const RespondToJoinRequestRequested({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}

class GetPendingPostsRequested extends CommunityAdminEvent {
  final String communityId;
  final int page;
  final int limit;

  const GetPendingPostsRequested({
    required this.communityId,
    required this.page,
    required this.limit,
  });
}

class ApproveCommunityPostRequested extends CommunityAdminEvent {
  final String communityId;
  final String postId;
  final String action;

  const ApproveCommunityPostRequested({
    required this.communityId,
    required this.postId,
    required this.action,
  });
}

class KickMemberRequested extends CommunityAdminEvent {
  final String communityId;
  final String memberId;

  const KickMemberRequested({
    required this.communityId,
    required this.memberId,
  });
}

class PromoteToAdminRequested extends CommunityAdminEvent {
  final String communityId;
  final String memberId;

  const PromoteToAdminRequested({
    required this.communityId,
    required this.memberId,
  });
}

class DemoteAdminRequested extends CommunityAdminEvent {
  final String communityId;
  final String memberId;

  const DemoteAdminRequested({
    required this.communityId,
    required this.memberId,
  });
}
