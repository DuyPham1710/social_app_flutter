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
  final int suggestionPage;
  final bool hasMoreSuggestions;
  final bool isLoadingMore;

  const FriendSuggestionsLoaded({
    required this.friendSuggestions,
    this.sentRequestUserIds = const {},
    this.suggestionPage = 1,
    this.hasMoreSuggestions = true,
    this.isLoadingMore = false,
  });

  FriendSuggestionsLoaded copyWith({
    List<FriendSuggestionEntity>? friendSuggestions,
    Set<String>? sentRequestUserIds,
    int? suggestionPage,
    bool? hasMoreSuggestions,
    bool? isLoadingMore,
  }) {
    return FriendSuggestionsLoaded(
      friendSuggestions: friendSuggestions ?? this.friendSuggestions,
      sentRequestUserIds: sentRequestUserIds ?? this.sentRequestUserIds,
      suggestionPage: suggestionPage ?? this.suggestionPage,
      hasMoreSuggestions: hasMoreSuggestions ?? this.hasMoreSuggestions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class FriendPageLoaded extends FriendState {
  final List<FriendRequestEntity> friendRequests;
  final List<FriendSuggestionEntity> friendSuggestions;
  final Set<String> acceptedRequestIds;
  final Set<String> rejectedRequestIds;
  final Set<String> sentRequestUserIds;
  final bool isLoadingRequests;
  final bool isLoadingSuggestions;
  final bool isLoadingMoreSuggestions;
  final int suggestionPage;
  final bool hasMoreSuggestions;
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
    this.isLoadingMoreSuggestions = false,
    this.suggestionPage = 1,
    this.hasMoreSuggestions = true,
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
    bool? isLoadingMoreSuggestions,
    int? suggestionPage,
    bool? hasMoreSuggestions,
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
      isLoadingMoreSuggestions:
          isLoadingMoreSuggestions ?? this.isLoadingMoreSuggestions,
      suggestionPage: suggestionPage ?? this.suggestionPage,
      hasMoreSuggestions: hasMoreSuggestions ?? this.hasMoreSuggestions,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      searchQuery: searchQuery ?? this.searchQuery,
      minMutualFriends: minMutualFriends ?? this.minMutualFriends,
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

class FriendByUserLoaded extends FriendState {
  final List<FriendEntity> friends;

  const FriendByUserLoaded({required this.friends});
}
