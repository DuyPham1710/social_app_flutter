import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/conversation_response_entity.dart';

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

  // // Real-time events
  Stream<ConversationResponseEntity> get onConversationsLoaded;
  // Stream<MessageEntity> get onNewMessage;
  // Stream<ConversationEntity> get onConversationUpdate;
  // Stream<Map<String, dynamic>> get onTyping;
  // Stream<Map<String, dynamic>> get onUserOnline;
}
