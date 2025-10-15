part of 'friend_bloc.dart';

abstract class FriendEvent {
  const FriendEvent();
}

class LoadFriends extends FriendEvent {
  const LoadFriends();
}

class LoadFriendRequests extends FriendEvent {
  final bool received;

  const LoadFriendRequests({required this.received});

}

class LoadFriendSuggestions extends FriendEvent {
  final int page;
  final int limit;

  const LoadFriendSuggestions({this.page = 1, this.limit = 10});

}

class SendFriendRequest extends FriendEvent {
  final String receiverId;

  const SendFriendRequest({required this.receiverId});

}

class AcceptFriendRequest extends FriendEvent {
  final String requestId;

  const AcceptFriendRequest({required this.requestId});

}

class RejectFriendRequest extends FriendEvent {
  final String requestId;

  const RejectFriendRequest({required this.requestId});

}

class SortFriendRequests extends FriendEvent {
  final String sortBy; // 'time', 'name', 'mutualFriends'
  final bool ascending;

  const SortFriendRequests({
    required this.sortBy,
    this.ascending = false,
  });
}

class FilterFriendRequests extends FriendEvent {
  final String? searchQuery;
  final int? minMutualFriends;

  const FilterFriendRequests({
    this.searchQuery,
    this.minMutualFriends,
  });
}

class LoadSentFriendRequests extends FriendEvent {
  const LoadSentFriendRequests();
}

class CancelSentFriendRequest extends FriendEvent {
  final String requestId;

  const CancelSentFriendRequest({required this.requestId});
}
