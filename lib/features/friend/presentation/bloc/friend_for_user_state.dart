part of 'friend_for_user_bloc.dart';

abstract class FriendForUserState {
  const FriendForUserState();
}

// Import for SentFriendRequestEntity

class FriendInitial extends FriendForUserState {}

class FriendLoading extends FriendForUserState {}

class FriendLoaded extends FriendForUserState {
  final List<FriendEntity> friends;

  const FriendLoaded({required this.friends});
}

class FriendRequestsLoading extends FriendForUserState {}

class FriendRequestsLoaded extends FriendForUserState {
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

class FriendSuggestionsLoading extends FriendForUserState {}

class FriendSuggestionsLoaded extends FriendForUserState {
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

class FriendPageLoaded extends FriendForUserState {
  final List<FriendRequestEntity> friendRequests;
  final List<FriendSuggestionEntity> friendSuggestions;
  final Set<String> acceptedRequestIds;
  final Set<String> rejectedRequestIds;
  final Set<String> sentRequestUserIds;
  final bool isLoadingRequests;
  final bool isLoadingSuggestions;
  final String sortBy;
  final bool ascending;
  final String? searchQuery;
  final int? minMutualFriends;

  const FriendPageLoaded({
    required this.friendRequests,
    required this.friendSuggestions,
    this.acceptedRequestIds = const {},
    this.rejectedRequestIds = const {},
    this.sentRequestUserIds = const {},
    this.isLoadingRequests = false,
    this.isLoadingSuggestions = false,
    this.sortBy = 'time',
    this.ascending = false,
    this.searchQuery,
    this.minMutualFriends,
  });

  FriendPageLoaded copyWith({
    List<FriendRequestEntity>? friendRequests,
    List<FriendSuggestionEntity>? friendSuggestions,
    Set<String>? acceptedRequestIds,
    Set<String>? rejectedRequestIds,
    Set<String>? sentRequestUserIds,
    bool? isLoadingRequests,
    bool? isLoadingSuggestions,
    String? sortBy,
    bool? ascending,
    String? searchQuery,
    int? minMutualFriends,
  }) {
    return FriendPageLoaded(
      friendRequests: friendRequests ?? this.friendRequests,
      friendSuggestions: friendSuggestions ?? this.friendSuggestions,
      acceptedRequestIds: acceptedRequestIds ?? this.acceptedRequestIds,
      rejectedRequestIds: rejectedRequestIds ?? this.rejectedRequestIds,
      sentRequestUserIds: sentRequestUserIds ?? this.sentRequestUserIds,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      searchQuery: searchQuery ?? this.searchQuery,
      minMutualFriends: minMutualFriends ?? this.minMutualFriends,
    );
  }
}

class FriendActionLoading extends FriendForUserState {}

class FriendActionSuccess extends FriendForUserState {
  final String message;

  const FriendActionSuccess({required this.message});
}

class FriendError extends FriendForUserState {
  final String message;

  const FriendError({required this.message});
}

class FriendActionError extends FriendForUserState {
  final String message;

  const FriendActionError({required this.message});
}

class SentFriendRequestsLoading extends FriendForUserState {}

class SentFriendRequestsLoaded extends FriendForUserState {
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

class FriendByUserLoaded extends FriendForUserState {
  final List<FriendEntity> friends;

  const FriendByUserLoaded({required this.friends});
}
