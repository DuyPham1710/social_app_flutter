import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/conversation_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';

abstract class ChatRepository {
  // Connection management
  void connect(String userId, String username);
  Future<void> waitForConnection({Duration timeout});
  void disconnect();
  void dispose();

  // Conversation operations
  Future<DataState<ConversationResponseEntity>> getConversations({
    required String userId,
    int page = 1,
    int limit = 10,
  });

  Future<DataState<MessageResponseEntity>> getConversationMessages({
    required String userId,
    required String conversationId,
    int page = 1,
    int limit = 20,
  });

  Future<DataState<void>> joinConversation({
    required String userId,
    required String conversationId,
  });

  // Typing events
  void emitTypingStart({
    required String userId,
    required String conversationId,
  });

  void emitTypingStop({
    required String userId,
    required String conversationId,
  });

  // // Real-time events
  Stream<ConversationResponseEntity> get onConversationsLoaded;
  Stream<MessageResponseEntity> get onMessagesLoaded;
  Stream<Map<String, dynamic>> get onTypingStart;
  Stream<Map<String, dynamic>> get onTypingStop;
  // Stream<MessageEntity> get onNewMessage;
  // Stream<ConversationEntity> get onConversationUpdate;
  // Stream<Map<String, dynamic>> get onUserOnline;
}
