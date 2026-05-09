import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/entities/message-edit-log_entity.dart';
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
  Future<DataState<MessageResponseEntity>> getMessagesAroundId({
    required String userId,
    required String conversationId,
    required String messageId,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDataSource.getMessagesAroundId(
        userId: userId,
        conversationId: conversationId,
        messageId: messageId,
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
  Future<DataState<ConversationEntity>> createConversation({
    required String userId,
    required List<String> participantIds,
    bool isGroup = false,
    String? name,
    String? avatar,
  }) async {
    try {
      final conversation = await _remoteDataSource.createConversation(
        userId: userId,
        participantIds: participantIds,
        isGroup: isGroup,
        name: name,
        avatar: avatar,
      );
      return DataStateSuccess(conversation.toEntity());
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
    required String userId,
  }) async {
    try {
      await _remoteDataSource.leaveConversation(
        conversationId: conversationId,
        userId: userId,
      );
      return const DataStateSuccess(null);
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  void updateConversation({
    required String userId,
    required String conversationId,
    String? name,
    String? avatar,
    String? createdBy,
    List<String>? participantIds,
  }) {
    _remoteDataSource.updateConversation(
      userId: userId,
      conversationId: conversationId,
      name: name,
      avatar: avatar,
      createdBy: createdBy,
      participantIds: participantIds,
    );
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
    Map<String, dynamic>? metadata,
  }) {
    _remoteDataSource.sendMessage(
      userId: userId,
      conversationId: conversationId,
      text: text,
      attachments: attachments,
      replyTo: replyTo,
      metadata: metadata,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> sendMessageWithFiles({
    required String conversationId,
    String? text,
    List<String>? filePaths,
    String? replyTo,
  }) async {
    return await _remoteDataSource.sendMessageWithFiles(
      conversationId: conversationId,
      text: text,
      filePaths: filePaths,
      replyTo: replyTo,
    );
  }

  @override
  Future<DataState<String>> applyVoiceEffect({
    required String filePath,
    required String voicePreset,
  }) async {
    try {
      final newPath = await _remoteDataSource.applyVoiceEffect(
        filePath: filePath,
        voicePreset: voicePreset,
      );
      return DataStateSuccess(newPath);
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
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

  @override
  void editMessage({
    required String userId,
    required String messageId,
    required String newText,
  }) {
    _remoteDataSource.editMessage(
      userId: userId,
      messageId: messageId,
      newText: newText,
    );
  }

  @override
  void reactMessage({
    required String userId,
    required String conversationId,
    required String messageId,
    required String emojiId,
  }) {
    _remoteDataSource.reactMessage(
      userId: userId,
      conversationId: conversationId,
      messageId: messageId,
      emojiId: emojiId,
    );
  }

  @override
  void deleteMessage({
    required String userId,
    required String messageId,
    required bool deleteForEveryone,
  }) {
    _remoteDataSource.deleteMessage(
      userId: userId,
      messageId: messageId,
      deleteForEveryone: deleteForEveryone,
    );
  }

  @override
  Future<DataState<List<MessageEditLogEntity>>> getMessageEditLogs({
    required String userId,
    required String messageId,
  }) async {
    try {
      final editLogs = await _remoteDataSource.getMessageEditLogs(
        userId: userId,
        messageId: messageId,
      );
      return DataStateSuccess(editLogs);
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  Stream<MessageEntity> get onMessageUpdated =>
      _remoteDataSource.onMessageUpdated;

  @override
  Stream<Map<String, dynamic>> get onMessageRead =>
      _remoteDataSource.onMessageRead;

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

  @override
  Stream<ConversationEntity> get onConversationCreated {
    return _remoteDataSource.onConversationCreated.map(
      (model) => model.toEntity(),
    );
  }

  // @override
  // Stream<Map<String, dynamic>> get onUserOnline => _remoteDataSource.onUserOnline;
}
