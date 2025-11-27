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

  // @override
  // Stream<MessageEntity> get onNewMessage {
  //   return _remoteDataSource.onNewMessage.map((model) => model.toEntity());
  // }

  // @override
  // Stream<ConversationEntity> get onConversationUpdate {
  //   return _remoteDataSource.onConversationUpdate.map((model) => model.toEntity());
  // }

  // @override
  // Stream<Map<String, dynamic>> get onTyping => _remoteDataSource.onTyping;

  // @override
  // Stream<Map<String, dynamic>> get onUserOnline => _remoteDataSource.onUserOnline;
}
