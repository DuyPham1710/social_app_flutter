part of 'invite_friends_bloc.dart';

abstract class InviteFriendsState {
  const InviteFriendsState();
}

class InviteFriendsInitial extends InviteFriendsState {
  const InviteFriendsInitial();
}

class InviteFriendsLoading extends InviteFriendsState {
  const InviteFriendsLoading();
}

class InviteFriendsLoaded extends InviteFriendsState {
  final List<dynamic> friends;

  const InviteFriendsLoaded({required this.friends});
}

class InviteFriendsInviting extends InviteFriendsState {
  const InviteFriendsInviting();
}

class InviteFriendsSuccess extends InviteFriendsState {
  final String message;
  final List<dynamic> friends;

  const InviteFriendsSuccess({required this.message, required this.friends});
}

class InviteFriendsError extends InviteFriendsState {
  final String message;

  const InviteFriendsError({required this.message});
}
