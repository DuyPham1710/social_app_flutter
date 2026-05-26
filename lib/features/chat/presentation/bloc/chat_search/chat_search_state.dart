part of 'chat_search_bloc.dart';

abstract class ChatSearchState {
  const ChatSearchState();
}

class ChatSearchInitial extends ChatSearchState {}

class ChatSearchLoading extends ChatSearchState {}

class ChatSearchLoaded extends ChatSearchState {
  final List<FriendSuggestionEntity> suggestions;
  final Set<String> sentRequestUserIds;
  final Map<String, String> userIdToRequestIdMap; // userId -> requestId mapping

  const ChatSearchLoaded({
    required this.suggestions,
    required this.sentRequestUserIds,
    required this.userIdToRequestIdMap,
  });

  ChatSearchLoaded copyWith({
    List<FriendSuggestionEntity>? suggestions,
    Set<String>? sentRequestUserIds,
    Map<String, String>? userIdToRequestIdMap,
  }) {
    return ChatSearchLoaded(
      suggestions: suggestions ?? this.suggestions,
      sentRequestUserIds: sentRequestUserIds ?? this.sentRequestUserIds,
      userIdToRequestIdMap: userIdToRequestIdMap ?? this.userIdToRequestIdMap,
    );
  }
}

class ChatSearchError extends ChatSearchState {
  final String message;

  const ChatSearchError({required this.message});
}
