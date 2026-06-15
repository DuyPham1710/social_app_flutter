part of 'invite_friends_bloc.dart';

abstract class InviteFriendsState {
  InviteFriendsState();
}

class InviteFriendsInitial extends InviteFriendsState {
  InviteFriendsInitial();
}

class InviteFriendsLoading extends InviteFriendsState {
  InviteFriendsLoading();
}

class InviteFriendsLoaded extends InviteFriendsState {
  final List<dynamic> friends;

  InviteFriendsLoaded({required this.friends});
}

class InviteFriendsInviting extends InviteFriendsState {
  InviteFriendsInviting();
}

class InviteFriendsSuccess extends InviteFriendsState {
  final String message;
  final List<dynamic> friends;

  InviteFriendsSuccess({required this.message, required this.friends});
}

class InviteFriendsError extends InviteFriendsState {
  final String message;

  InviteFriendsError({required this.message});
}
