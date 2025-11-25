import 'package:social_app_fe/features/chat/data/models/chat_models.dart';

abstract class ChatRemoteDataSource {
  // Load conversations
  Future<ConversationsResponseModel> getConversations({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  // // Real-time events
  Stream<ConversationsResponseModel> get onConversationsLoaded;
  // Stream<MessageModel> get onNewMessage;
  // Stream<ConversationModel> get onConversationUpdate;
  // Stream<Map<String, dynamic>> get onTyping;
  // Stream<Map<String, dynamic>> get onUserOnline;

  // Connection management
  void connect(String userId, String username);
  Future<void> waitForConnection({Duration timeout});
  void disconnect();
  void dispose();
}
