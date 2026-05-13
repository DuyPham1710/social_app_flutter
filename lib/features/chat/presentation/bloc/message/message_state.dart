import 'package:equatable/equatable.dart';
import '../../../domain/entities/message_response_entity.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

// Messages states
class MessagesLoading extends MessageState {
  const MessagesLoading();
}

class MessagesLoaded extends MessageState {
  final MessageResponseEntity messages;
  final String? typingUserId;
  final bool isTyping;
  final bool isUploadingFiles;

  const MessagesLoaded(
    this.messages, {
    this.typingUserId,
    this.isTyping = false,
    this.isUploadingFiles = false,
  });

  @override
  List<Object?> get props => [messages, typingUserId, isTyping, isUploadingFiles];
}

class MessagesError extends MessageState {
  final String message;

  const MessagesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Typing states
class TypingState extends MessageState {
  final String userId;
  final String conversationId;
  final bool isTyping;

  const TypingState({
    required this.userId,
    required this.conversationId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [userId, conversationId, isTyping];
}