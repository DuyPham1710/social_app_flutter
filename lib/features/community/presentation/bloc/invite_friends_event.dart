part of 'invite_friends_bloc.dart';

abstract class InviteFriendsEvent {
  const InviteFriendsEvent();
}

class GetAvailableFriendsEvent extends InviteFriendsEvent {
  final String communityId;

  const GetAvailableFriendsEvent({required this.communityId});
}

class InviteFriendEvent extends InviteFriendsEvent {
  final String communityId;
  final String userId;

  const InviteFriendEvent({required this.communityId, required this.userId});
}
