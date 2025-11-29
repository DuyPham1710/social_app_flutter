import 'package:social_app_fe/features/chat/data/models/chat_models.dart';
import 'package:social_app_fe/features/chat/data/models/message_reponse_model.dart';

abstract class ChatRemoteDataSource {
  // Load conversations
  Future<ConversationsResponseModel> getConversations({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  // Load messages in a conversation
  Future<MessageReponseModel> getConversationMessages({
    required String userId,
    required String conversationId,
    int page = 1,
    int limit = 20,
  });

  // Join conversation
  Future<void> joinConversation({
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
  Stream<ConversationsResponseModel> get onConversationsLoaded;
  Stream<MessageReponseModel> get onMessagesLoaded;
  Stream<Map<String, dynamic>> get onTypingStart;
  Stream<Map<String, dynamic>> get onTypingStop;
  // Stream<MessageModel> get onNewMessage;
  // Stream<ConversationModel> get onConversationUpdate;
  // Stream<Map<String, dynamic>> get onUserOnline;

  // Connection management
  void connect(String userId, String username);
  Future<void> waitForConnection({Duration timeout});
  void disconnect();
  void dispose();
}
