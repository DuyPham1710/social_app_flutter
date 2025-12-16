part of 'chat_search_bloc.dart';

abstract class ChatSearchEvent {
  const ChatSearchEvent();
}

class LoadFriendSuggestions extends ChatSearchEvent {
  final int page;
  final int limit;

  const LoadFriendSuggestions({
    this.page = 1,
    this.limit = 4,
  });
}

class SendFriendRequestFromSearch extends ChatSearchEvent {
  final String receiverId;

  const SendFriendRequestFromSearch({required this.receiverId});
}

class CancelFriendRequestFromSearch extends ChatSearchEvent {
  final String userId;

  const CancelFriendRequestFromSearch({required this.userId});
}