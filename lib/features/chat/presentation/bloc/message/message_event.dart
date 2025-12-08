import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessagesEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final int page;
  final int limit;

  const LoadMessagesEvent({
    required this.userId,
    required this.conversationId,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, conversationId, page, limit];
}

class LoadMoreOldMessagesEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final int page;
  final int limit;

  const LoadMoreOldMessagesEvent({
    required this.userId,
    required this.conversationId,
    required this.page,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, conversationId, page, limit];
}

// class LoadMoreOldMessagesEvent extends MessageEvent {
//   final String userId;
//   final String conversationId;
//   final int page;
//   final int limit;

//   const LoadMoreOldMessagesEvent({
//     required this.userId,
//     required this.conversationId,
//     required this.page,
//     this.limit = 20,
//   });

//   @override
//   List<Object?> get props => [userId, conversationId, page, limit];
// }

class LoadMoreNewMessagesEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final int page;
  final int limit;

  const LoadMoreNewMessagesEvent({
    required this.userId,
    required this.conversationId,
    required this.page,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, conversationId, page, limit];
}

class TypingStartEvent extends MessageEvent {
  final String userId;
  final String conversationId;

  const TypingStartEvent({required this.userId, required this.conversationId});

  @override
  List<Object?> get props => [userId, conversationId];
}

class TypingStopEvent extends MessageEvent {
  final String userId;
  final String conversationId;

  const TypingStopEvent({required this.userId, required this.conversationId});

  @override
  List<Object?> get props => [userId, conversationId];
}

class NewMessageReceivedEvent extends MessageEvent {
  final MessageEntity messageData;

  const NewMessageReceivedEvent(this.messageData);

  @override
  List<Object?> get props => [messageData];
}

class SendMessageEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final String? text;
  final List<Map<String, dynamic>>? attachments;
  final String? replyTo;

  const SendMessageEvent({
    required this.userId,
    required this.conversationId,
    this.text,
    this.attachments,
    this.replyTo,
  });

  @override
  List<Object?> get props => [
    userId,
    conversationId,
    text,
    attachments,
    replyTo,
  ];
}

class MarkAsReadEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final String? messageId;

  const MarkAsReadEvent({
    required this.userId,
    required this.conversationId,
    this.messageId,
  });

  @override
  List<Object?> get props => [userId, conversationId, messageId];
}

class LoadMessagesAroundIdEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final String messageId;
  final int limit;

  const LoadMessagesAroundIdEvent({
    required this.userId,
    required this.conversationId,
    required this.messageId,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, conversationId, messageId, limit];
}

class EditMessageEvent extends MessageEvent {
  final String userId;
  final String messageId;
  final String newText;

  const EditMessageEvent({
    required this.userId,
    required this.messageId,
    required this.newText,
  });

  @override
  List<Object?> get props => [userId, messageId, newText];
}

class ReactMessageEvent extends MessageEvent {
  final String userId;
  final String conversationId;
  final String messageId;
  final String emojiId;

  const ReactMessageEvent({
    required this.userId,
    required this.conversationId,
    required this.messageId,
    required this.emojiId,
  });

  @override
  List<Object?> get props => [userId, conversationId, messageId, emojiId];
}

class DeleteMessageEvent extends MessageEvent {
  final String userId;
  final String messageId;
  final bool deleteForEveryone;

  const DeleteMessageEvent({
    required this.userId,
    required this.messageId,
    required this.deleteForEveryone,
  });

  @override
  List<Object?> get props => [userId, messageId, deleteForEveryone];
}

class MessageUpdatedReceivedEvent extends MessageEvent {
  final MessageEntity messageData;

  const MessageUpdatedReceivedEvent(this.messageData);

  @override
  List<Object?> get props => [messageData];
}

class MessageReadReceivedEvent extends MessageEvent {
  final String messageId;
  final String userId;
  final Map<String, dynamic> userInfo; // { userId, username, fullName, avatarUrl }
  final DateTime readAt;

  const MessageReadReceivedEvent({
    required this.messageId,
    required this.userId,
    required this.userInfo,
    required this.readAt,
  });

  @override
  List<Object?> get props => [messageId, userId, userInfo, readAt];
}
