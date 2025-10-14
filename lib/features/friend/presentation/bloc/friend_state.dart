part of 'friend_bloc.dart';

abstract class FriendState {
  const FriendState();
}

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

  const FriendRequestsLoaded({
    required this.friendRequests,
    required this.isReceived,
    this.sortBy = 'time',
    this.ascending = false,
    this.searchQuery,
    this.minMutualFriends,
  });

  FriendRequestsLoaded copyWith({
    List<FriendRequestEntity>? friendRequests,
    bool? isReceived,
    String? sortBy,
    bool? ascending,
    String? searchQuery,
    int? minMutualFriends,
  }) {
    return FriendRequestsLoaded(
      friendRequests: friendRequests ?? this.friendRequests,
      isReceived: isReceived ?? this.isReceived,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      searchQuery: searchQuery ?? this.searchQuery,
      minMutualFriends: minMutualFriends ?? this.minMutualFriends,
    );
  }
}

class FriendSuggestionsLoading extends FriendState {}

class FriendSuggestionsLoaded extends FriendState {
  final List<FriendSuggestionEntity> friendSuggestions;

  const FriendSuggestionsLoaded({required this.friendSuggestions});

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
