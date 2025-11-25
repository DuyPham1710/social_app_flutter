import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation_response_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

// class ChatConnecting extends ChatState {
//   const ChatConnecting();
// }

// class ChatConnected extends ChatState {
//   final String userId;
//   final String? username;

//   const ChatConnected({required this.userId, this.username});

//   @override
//   List<Object?> get props => [userId, username];
// }

// class ChatDisconnected extends ChatState {
//   const ChatDisconnected();
// }

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

// Conversations states
class ConversationsLoading extends ChatState {
  const ConversationsLoading();
}

class ConversationsLoaded extends ChatState {
  final ConversationResponseEntity conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationsError extends ChatState {
  final String? message;

  const ConversationsError({this.message});

  @override
  List<Object?> get props => [message];
}
