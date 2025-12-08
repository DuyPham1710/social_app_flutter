import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/conversation_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';
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

  Future<DataState<MessageResponseEntity>> getMessagesAroundId({
    required String userId,
    required String conversationId,
    required String messageId,
    int limit = 20,
  });

  Future<DataState<ConversationEntity>> createConversation({
    required String userId,
    required List<String> participantIds,
    bool isGroup = false,
    String? name,
    String? avatar,
  });

  Future<DataState<void>> joinConversation({
    required String userId,
    required String conversationId,
  });

  Future<DataState<void>> leaveConversation({required String conversationId});

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
  Future<DataState<List<MessageEditLogEntity>>> getMessageEditLogs({
    required String userId,
    required String messageId,
  });

  // // Real-time events
  Stream<ConversationResponseEntity> get onConversationsLoaded;
  Stream<MessageResponseEntity> get onMessagesLoaded;
  Stream<Map<String, dynamic>> get onTypingStart;
  Stream<Map<String, dynamic>> get onTypingStop;
  Stream<MessageEntity> get onNewMessage;
  Stream<MessageEntity> get onMessageUpdated;
  Stream<Map<String, dynamic>> get onMessageRead;
  Stream<ConversationEntity> get onConversationUpdate;
  Stream<ConversationEntity> get onConversationCreated;
  // Stream<Map<String, dynamic>> get onUserOnline;
}
