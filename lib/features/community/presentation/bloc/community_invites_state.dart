part of 'community_invites_bloc.dart';

abstract class CommunityInvitesState {
  CommunityInvitesState();
}

class CommunityInvitesInitial extends CommunityInvitesState {
  CommunityInvitesInitial();
}

class CommunityInvitesLoading extends CommunityInvitesState {
  CommunityInvitesLoading();
}

class CommunityInvitesLoaded extends CommunityInvitesState {
  final List<dynamic> invites;

  CommunityInvitesLoaded({required this.invites});
}

class CommunityInvitesEmpty extends CommunityInvitesState {
  CommunityInvitesEmpty();
}

class CommunityInvitesProcessing extends CommunityInvitesState {
  CommunityInvitesProcessing();
}

class CommunityInvitesSuccess extends CommunityInvitesState {
  final String message;
  final List<dynamic> invites;

  CommunityInvitesSuccess({required this.message, required this.invites});
}

class CommunityInvitesError extends CommunityInvitesState {
  final String message;

  CommunityInvitesError({required this.message});
}
