import 'package:social_app_fe/features/chat/data/models/chat_models.dart';
import 'package:social_app_fe/features/chat/data/models/message_reponse_model.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';

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

  // Create conversation
  Future<ConversationModel> createConversation({
    required String userId,
    required List<String> participantIds,
    bool isGroup = false,
    String? name,
    String? avatar,
  });

  // Join conversation
  Future<void> joinConversation({
    required String userId,
    required String conversationId,
  });

  // Leave conversation
  Future<void> leaveConversation({
    required String conversationId,
    required String userId,
  });

  // Update conversation
  void updateConversation({
    required String userId,
    required String conversationId,
    String? name,
    String? avatar,
    String? createdBy,
    List<String>? participantIds,
  });

  // Typing events
  void emitTypingStart({
    required String userId,
    required String conversationId,
  });

  void emitTypingStop({required String userId, required String conversationId});

  // Send message (WebSocket)
  void sendMessage({
    required String userId,
    required String conversationId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
    Map<String, dynamic>? metadata,
  });

  // Upload files and return attachments URLs (HTTP with MultipartFile)
  Future<List<Map<String, dynamic>>> sendMessageWithFiles({
    required String conversationId,
    String? text,
    List<String>? filePaths,
    String? replyTo,
  });

  // Apply voice effect to audio file and return converted file path
  Future<String> applyVoiceEffect({
    required String filePath,
    required String voicePreset,
  });

  // Mark messages as read
  void markAsRead({
    required String userId,
    required String conversationId,
    String? messageId,
  });

  // Edit message
  void editMessage({
    required String userId,
    required String messageId,
    required String newText,
  });

  // Delete message
  void deleteMessage({
    required String userId,
    required String messageId,
    required bool deleteForEveryone,
  });

  // React to message
  void reactMessage({
    required String userId,
    required String conversationId,
    required String messageId,
    required String emojiId,
  });

  // Get message edit logs
  Future<List<MessageEditLogEntity>> getMessageEditLogs({
    required String userId,
    required String messageId,
  });

  // // Real-time events
  Stream<ConversationsResponseModel> get onConversationsLoaded;
  Stream<MessageReponseModel> get onMessagesLoaded;
  Stream<Map<String, dynamic>> get onTypingStart;
  Stream<Map<String, dynamic>> get onTypingStop;
  Stream<MessageEntity> get onNewMessage;
  Stream<MessageEntity> get onMessageUpdated;
  Stream<Map<String, dynamic>> get onMessageRead;
  Stream<ConversationModel> get onConversationUpdate;
  Stream<ConversationModel> get onConversationCreated;
  // Stream<Map<String, dynamic>> get onUserOnline;

  // Connection management
  void connect(String userId, String username);
  Future<void> waitForConnection({Duration timeout});
  void disconnect();
  void dispose();
}
