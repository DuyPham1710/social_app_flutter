import 'package:social_app_fe/features/chat/data/models/chat_models.dart';
import 'package:social_app_fe/features/chat/data/models/message_reponse_model.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

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

  // Load messages around a specific message ID
  Future<MessageReponseModel> getMessagesAroundId({
    required String userId,
    required String conversationId,
    required String messageId,
    int limit = 20,
  });

  // Join conversation
  Future<void> joinConversation({
    required String userId,
    required String conversationId,
  });

  // Leave conversation
  Future<void> leaveConversation({required String conversationId});

  // Typing events
  void emitTypingStart({
    required String userId,
    required String conversationId,
  });

  void emitTypingStop({required String userId, required String conversationId});

  // Send message
  void sendMessage({
    required String userId,
    required String conversationId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
  });

  // Mark messages as read
  void markAsRead({
    required String userId,
    required String conversationId,
    String? messageId,
  });

  // // Real-time events
  Stream<ConversationsResponseModel> get onConversationsLoaded;
  Stream<MessageReponseModel> get onMessagesLoaded;
  Stream<Map<String, dynamic>> get onTypingStart;
  Stream<Map<String, dynamic>> get onTypingStop;
  Stream<MessageEntity> get onNewMessage;
  Stream<ConversationModel> get onConversationUpdate;
  // Stream<Map<String, dynamic>> get onUserOnline;

  // Connection management
  void connect(String userId, String username);
  Future<void> waitForConnection({Duration timeout});
  void disconnect();
  void dispose();
}
