part of 'community_detail_bloc.dart';

abstract class CommunityDetailEvent {
  CommunityDetailEvent();
}

class CommunityDetailFetched extends CommunityDetailEvent {
  final String communityId;

  CommunityDetailFetched(this.communityId);
}

class JoinCommunityRequested extends CommunityDetailEvent {
  final String communityId;

  JoinCommunityRequested(this.communityId);
}

class LeaveCommunityRequested extends CommunityDetailEvent {
  final String communityId;

  LeaveCommunityRequested(this.communityId);
}

class CancelJoinRequestRequested extends CommunityDetailEvent {
  final String communityId;

  CancelJoinRequestRequested(this.communityId);
}

class MemberStatusFetched extends CommunityDetailEvent {
  final String communityId;

  MemberStatusFetched(this.communityId);
}

class RespondToInviteRequested extends CommunityDetailEvent {
  final String communityId;
  final String requestId;
  final String action;

  RespondToInviteRequested({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}

class DeleteCommunityRequested extends CommunityDetailEvent {
  final String communityId;

  DeleteCommunityRequested(this.communityId);
}
