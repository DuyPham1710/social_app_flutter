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

  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends MessageState {
  final String message;

  const MessagesError(this.message);

  @override
  List<Object?> get props => [message];
}
