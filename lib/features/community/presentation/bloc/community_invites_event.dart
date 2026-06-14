part of 'community_invites_bloc.dart';

abstract class CommunityInvitesEvent {
  CommunityInvitesEvent();
}

class FetchCommunityInvitesEvent extends CommunityInvitesEvent {
  FetchCommunityInvitesEvent();
}

class RespondToInviteEvent extends CommunityInvitesEvent {
  final String communityId;
  final String requestId;
  final String action; // 'approve' or 'reject'

  RespondToInviteEvent({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}

class RefreshInvitesEvent extends CommunityInvitesEvent {
  RefreshInvitesEvent();
}
