part of 'community_detail_bloc.dart';

abstract class CommunityDetailEvent {
  const CommunityDetailEvent();
}

class CommunityDetailFetched extends CommunityDetailEvent {
  final String communityId;

  const CommunityDetailFetched(this.communityId);
}

class JoinCommunityRequested extends CommunityDetailEvent {
  final String communityId;

  const JoinCommunityRequested(this.communityId);
}

class LeaveCommunityRequested extends CommunityDetailEvent {
  final String communityId;

  const LeaveCommunityRequested(this.communityId);
}

class CancelJoinRequestRequested extends CommunityDetailEvent {
  final String communityId;

  const CancelJoinRequestRequested(this.communityId);
}

class MemberStatusFetched extends CommunityDetailEvent {
  final String communityId;

  const MemberStatusFetched(this.communityId);
}

class RespondToInviteRequested extends CommunityDetailEvent {
  final String communityId;
  final String requestId;
  final String action;

  const RespondToInviteRequested({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}

class DeleteCommunityRequested extends CommunityDetailEvent {
  final String communityId;

  const DeleteCommunityRequested(this.communityId);
}
