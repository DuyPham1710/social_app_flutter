part of 'friend_for_user_bloc.dart';

abstract class FriendForUserEvent {
  const FriendForUserEvent();
}

class LoadFriends extends FriendForUserEvent {
  const LoadFriends();
}

class LoadFriendRequests extends FriendForUserEvent {
  final bool received;

  const LoadFriendRequests({required this.received});
}

class LoadFriendSuggestions extends FriendForUserEvent {
  final int page;
  final int limit;

  const LoadFriendSuggestions({this.page = 1, this.limit = 10});
}

class LoadFriendPage extends FriendForUserEvent {
  const LoadFriendPage();
}

class SendFriendRequest extends FriendForUserEvent {
  final String receiverId;

  const SendFriendRequest({required this.receiverId});
}

class AcceptFriendRequest extends FriendForUserEvent {
  final String requestId;

  const AcceptFriendRequest({required this.requestId});
}

class RejectFriendRequest extends FriendForUserEvent {
  final String requestId;

  const RejectFriendRequest({required this.requestId});
}

class SortFriendRequests extends FriendForUserEvent {
  final String sortBy; // 'time', 'name', 'mutualFriends'
  final bool ascending;

  const SortFriendRequests({required this.sortBy, this.ascending = false});
}

class FilterFriendRequests extends FriendForUserEvent {
  final String? searchQuery;
  final int? minMutualFriends;

  const FilterFriendRequests({this.searchQuery, this.minMutualFriends});
}

class LoadSentFriendRequests extends FriendForUserEvent {
  const LoadSentFriendRequests();
}

class CancelSentFriendRequest extends FriendForUserEvent {
  final String requestId;

  const CancelSentFriendRequest({required this.requestId});
}

class RemoveFriend extends FriendForUserEvent {
  final String friendId;

  const RemoveFriend({required this.friendId});
}

class LoadFriendsByUserId extends FriendForUserEvent {
  final String userId;
  const LoadFriendsByUserId(this.userId);
}
