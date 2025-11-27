import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

// class ConnectChatEvent extends ChatEvent {
//   const ConnectChatEvent();
// }

// class DisconnectChatEvent extends ChatEvent {
//   const DisconnectChatEvent();
// }

class LoadConversationsEvent extends ConversationEvent {
  final String userId;
  final int page;
  final int limit;

  const LoadConversationsEvent({
    required this.userId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [userId, page, limit];
}

class JoinConversationEvent extends ConversationEvent {
  final String userId;
  final String conversationId;

  const JoinConversationEvent({
    required this.userId,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [userId, conversationId];
}
