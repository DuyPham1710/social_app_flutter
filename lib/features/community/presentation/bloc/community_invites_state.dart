part of 'community_invites_bloc.dart';

abstract class CommunityInvitesState {
  const CommunityInvitesState();
}

class CommunityInvitesInitial extends CommunityInvitesState {
  const CommunityInvitesInitial();
}

class CommunityInvitesLoading extends CommunityInvitesState {
  const CommunityInvitesLoading();
}

class CommunityInvitesLoaded extends CommunityInvitesState {
  final List<dynamic> invites;

  const CommunityInvitesLoaded({required this.invites});
}

class CommunityInvitesEmpty extends CommunityInvitesState {
  const CommunityInvitesEmpty();
}

class CommunityInvitesProcessing extends CommunityInvitesState {
  const CommunityInvitesProcessing();
}

class CommunityInvitesSuccess extends CommunityInvitesState {
  final String message;
  final List<dynamic> invites;

  const CommunityInvitesSuccess({required this.message, required this.invites});
}

class CommunityInvitesError extends CommunityInvitesState {
  final String message;

  const CommunityInvitesError({required this.message});
}
