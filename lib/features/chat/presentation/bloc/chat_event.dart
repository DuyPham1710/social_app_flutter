import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// class ConnectChatEvent extends ChatEvent {
//   const ConnectChatEvent();
// }

// class DisconnectChatEvent extends ChatEvent {
//   const DisconnectChatEvent();
// }

class LoadConversationsEvent extends ChatEvent {
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
