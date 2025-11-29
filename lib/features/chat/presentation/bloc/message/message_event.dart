import 'package:equatable/equatable.dart';

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

class TypingStartEvent extends MessageEvent {
  final String userId;
  final String conversationId;

  const TypingStartEvent({
    required this.userId,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [userId, conversationId];
}

class TypingStopEvent extends MessageEvent {
  final String userId;
  final String conversationId;

  const TypingStopEvent({
    required this.userId,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [userId, conversationId];
}