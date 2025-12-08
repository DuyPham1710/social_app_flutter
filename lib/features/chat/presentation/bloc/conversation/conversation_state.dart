import 'package:equatable/equatable.dart';
import '../../../domain/entities/conversation_response_entity.dart';
import '../../../domain/entities/chat_entities.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {
  const ConversationInitial();
}

// class ConversationConnecting extends ConversationState {
//   const ConversationConnecting();
// }

// class ConversationConnected extends ConversationState {
//   final String userId;
//   final String? username;

//   const ConversationConnected({required this.userId, this.username});
//   @override
//   List<Object?> get props => [userId, username];
// }

// class ConversationDisconnected extends ConversationState {
//   const ConversationDisconnected();
// }

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Conversations states
class ConversationsLoading extends ConversationState {
  const ConversationsLoading();
}

class ConversationsLoaded extends ConversationState {
  final ConversationResponseEntity conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationsError extends ConversationState {
  final String? message;

  const ConversationsError({this.message});

  @override
  List<Object?> get props => [message];
}

// Join conversation states
class JoinConversationLoading extends ConversationState {
  const JoinConversationLoading();
}

class JoinConversationSuccess extends ConversationState {
  final String conversationId;

  const JoinConversationSuccess(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class JoinConversationError extends ConversationState {
  final String message;

  const JoinConversationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Create conversation states
class CreateConversationLoading extends ConversationState {
  const CreateConversationLoading();
}

class CreateConversationSuccess extends ConversationState {
  final ConversationEntity conversation;

  const CreateConversationSuccess(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class CreateConversationError extends ConversationState {
  final String? message;

  const CreateConversationError({this.message});

  @override
  List<Object?> get props => [message];
}
