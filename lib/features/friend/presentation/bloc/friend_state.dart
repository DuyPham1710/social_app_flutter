part of 'friend_bloc.dart';

abstract class FriendState {
  const FriendState();
}

// Import for SentFriendRequestEntity


class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<FriendEntity> friends;

  const FriendLoaded({required this.friends});

}

class FriendRequestsLoading extends FriendState {}

class FriendRequestsLoaded extends FriendState {
  final List<FriendRequestEntity> friendRequests;
  final bool isReceived;
  final String sortBy;
  final bool ascending;
  final String? searchQuery;
  final int? minMutualFriends;
  final Set<String> acceptedRequestIds;
  final Set<String> rejectedRequestIds;

  const FriendRequestsLoaded({
    required this.friendRequests,
    required this.isReceived,
    this.sortBy = 'time',
    this.ascending = false,
    this.searchQuery,
    this.minMutualFriends,
    this.acceptedRequestIds = const {},
    this.rejectedRequestIds = const {},
  });

  FriendRequestsLoaded copyWith({
    List<FriendRequestEntity>? friendRequests,
    bool? isReceived,
    String? sortBy,
    bool? ascending,
    String? searchQuery,
    int? minMutualFriends,
    Set<String>? acceptedRequestIds,
    Set<String>? rejectedRequestIds,
  }) {
    return FriendRequestsLoaded(
      friendRequests: friendRequests ?? this.friendRequests,
      isReceived: isReceived ?? this.isReceived,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      searchQuery: searchQuery ?? this.searchQuery,
      minMutualFriends: minMutualFriends ?? this.minMutualFriends,
      acceptedRequestIds: acceptedRequestIds ?? this.acceptedRequestIds,
      rejectedRequestIds: rejectedRequestIds ?? this.rejectedRequestIds,
    );
  }
}

class FriendSuggestionsLoading extends FriendState {}

class FriendSuggestionsLoaded extends FriendState {
  final List<FriendSuggestionEntity> friendSuggestions;
  final Set<String> sentRequestUserIds;

  const FriendSuggestionsLoaded({
    required this.friendSuggestions,
    this.sentRequestUserIds = const {},
  });

  FriendSuggestionsLoaded copyWith({
    List<FriendSuggestionEntity>? friendSuggestions,
    Set<String>? sentRequestUserIds,
  }) {
    return FriendSuggestionsLoaded(
      friendSuggestions: friendSuggestions ?? this.friendSuggestions,
      sentRequestUserIds: sentRequestUserIds ?? this.sentRequestUserIds,
    );
  }
}

class FriendActionLoading extends FriendState {}

class FriendActionSuccess extends FriendState {
  final String message;

  const FriendActionSuccess({required this.message});

}

class FriendError extends FriendState {
  final String message;

  const FriendError({required this.message});

}

class FriendActionError extends FriendState {
  final String message;

  const FriendActionError({required this.message});

}

class SentFriendRequestsLoading extends FriendState {}

class SentFriendRequestsLoaded extends FriendState {
  final List<SentFriendRequestEntity> sentRequests;
  final Set<String> cancelledRequestIds;

  const SentFriendRequestsLoaded({
    required this.sentRequests,
    this.cancelledRequestIds = const {},
  });

  SentFriendRequestsLoaded copyWith({
    List<SentFriendRequestEntity>? sentRequests,
    Set<String>? cancelledRequestIds,
  }) {
    return SentFriendRequestsLoaded(
      sentRequests: sentRequests ?? this.sentRequests,
      cancelledRequestIds: cancelledRequestIds ?? this.cancelledRequestIds,
    );
  }
}
