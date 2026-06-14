part of 'invite_friends_bloc.dart';

abstract class InviteFriendsEvent {
  InviteFriendsEvent();
}

class GetAvailableFriendsEvent extends InviteFriendsEvent {
  final String communityId;

  GetAvailableFriendsEvent({required this.communityId});
}

class InviteFriendEvent extends InviteFriendsEvent {
  final String communityId;
  final String userId;

  InviteFriendEvent({required this.communityId, required this.userId});
}
