import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

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

class CreateConversationEvent extends ConversationEvent {
  final String userId;
  final List<String> participantIds;
  final bool isGroup;
  final String? name;
  final String? avatar;

  const CreateConversationEvent({
    required this.userId,
    required this.participantIds,
    this.isGroup = false,
    this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [userId, participantIds, isGroup, name, avatar];
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

class LeaveConversationEvent extends ConversationEvent {
  final String conversationId;
  final String userId;

  const LeaveConversationEvent({
    required this.conversationId,
    required this.userId,
  });

  @override
  List<Object?> get props => [conversationId, userId];
}

class ConversationUpdatedEvent extends ConversationEvent {
  final ConversationEntity conversation;

  const ConversationUpdatedEvent(this.conversation);

  @override
  List<Object?> get props => [conversation];
}
