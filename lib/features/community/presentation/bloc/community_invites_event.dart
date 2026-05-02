part of 'community_invites_bloc.dart';

abstract class CommunityInvitesEvent {
  const CommunityInvitesEvent();
}

class FetchCommunityInvitesEvent extends CommunityInvitesEvent {
  const FetchCommunityInvitesEvent();
}

class RespondToInviteEvent extends CommunityInvitesEvent {
  final String communityId;
  final String requestId;
  final String action; // 'approve' or 'reject'

  const RespondToInviteEvent({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}

class RefreshInvitesEvent extends CommunityInvitesEvent {
  const RefreshInvitesEvent();
}
