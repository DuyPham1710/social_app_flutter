import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/entities/conversation_response_entity.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_sources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  void connect(String userId, String username) {
    _remoteDataSource.connect(userId, username);
  }

  @override
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 10),
  }) {
    return _remoteDataSource.waitForConnection(timeout: timeout);
  }

  @override
  void disconnect() {
    _remoteDataSource.disconnect();
  }

  @override
  void dispose() {
    _remoteDataSource.dispose();
  }

  @override
  Future<DataState<ConversationResponseEntity>> getConversations({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getConversations(
        userId: userId,
        page: page,
        limit: limit,
      );

      return DataStateSuccess(response.toEntity());
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  Future<DataState<MessageResponseEntity>> getConversationMessages({
    required String userId,
    required String conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDataSource.getConversationMessages(
        userId: userId,
        conversationId: conversationId,
        page: page,
        limit: limit,
      );
      return DataStateSuccess(response.toEntity());
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  Future<DataState<void>> joinConversation({
    required String userId,
    required String conversationId,
  }) async {
    try {
      await _remoteDataSource.joinConversation(
        userId: userId,
        conversationId: conversationId,
      );
      return const DataStateSuccess(null);
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  Future<DataState<void>> leaveConversation({
    required String conversationId,
  }) async {
    try {
      await _remoteDataSource.leaveConversation(conversationId: conversationId);
      return const DataStateSuccess(null);
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  Stream<ConversationResponseEntity> get onConversationsLoaded {
    return _remoteDataSource.onConversationsLoaded.map((response) {
      return response.toEntity();
    });
  }

  @override
  Stream<MessageResponseEntity> get onMessagesLoaded {
    return _remoteDataSource.onMessagesLoaded.map((response) {
      return response.toEntity();
    });
  }

  @override
  Stream<Map<String, dynamic>> get onTypingStart =>
      _remoteDataSource.onTypingStart;

  @override
  Stream<Map<String, dynamic>> get onTypingStop =>
      _remoteDataSource.onTypingStop;

  @override
  Stream<MessageEntity> get onNewMessage => _remoteDataSource.onNewMessage;

  @override
  void emitTypingStart({
    required String userId,
    required String conversationId,
  }) {
    _remoteDataSource.emitTypingStart(
      userId: userId,
      conversationId: conversationId,
    );
  }

  @override
  void emitTypingStop({
    required String userId,
    required String conversationId,
  }) {
    _remoteDataSource.emitTypingStop(
      userId: userId,
      conversationId: conversationId,
    );
  }

  @override
  void sendMessage({
    required String userId,
    required String conversationId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
  }) {
    _remoteDataSource.sendMessage(
      userId: userId,
      conversationId: conversationId,
      text: text,
      attachments: attachments,
      replyTo: replyTo,
    );
  }

  @override
  void markAsRead({
    required String userId,
    required String conversationId,
    String? messageId,
  }) {
    _remoteDataSource.markAsRead(
      userId: userId,
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  // @override
  // Stream<MessageEntity> get onNewMessage {
  //   return _remoteDataSource.onNewMessage.map((model) => model.toEntity());
  // }

  @override
  Stream<ConversationEntity> get onConversationUpdate {
    return _remoteDataSource.onConversationUpdate.map(
      (model) => model.toEntity(),
    );
  }

  // @override
  // Stream<Map<String, dynamic>> get onUserOnline => _remoteDataSource.onUserOnline;
}
