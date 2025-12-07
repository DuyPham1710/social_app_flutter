import 'dart:async';
import 'dart:developer' as developer;
import 'package:social_app_fe/features/chat/data/models/message_reponse_model.dart';
import 'package:social_app_fe/features/chat/data/models/message-edit-log_model.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';

import '../../../../core/network/websocket/socket_client.dart';
import '../models/chat_models.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SocketClient _socketClient;

  // Stream controllers for real-time events
  final _conversationsLoadedController =
      StreamController<ConversationsResponseModel>.broadcast();
  final _messagesLoadedController =
      StreamController<MessageReponseModel>.broadcast();
  final _typingStartController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _typingStopController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _newMessageController = StreamController<MessageEntity>.broadcast();
  final _messageUpdatedController = StreamController<MessageEntity>.broadcast();
  final _messageReadController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _conversationUpdateController =
      StreamController<ConversationModel>.broadcast();
  // final _userOnlineController =
  //     StreamController<Map<String, dynamic>>.broadcast();

  // Cache for conversations data
  final Map<String, ConversationsResponseModel> _conversationsCache = {};

  // Connection state tracking
  bool _isConnected = false;
  Completer<void>? _connectionCompleter;

  ChatRemoteDataSourceImpl(this._socketClient);

  // Getters
  @override
  Stream<ConversationsResponseModel> get onConversationsLoaded =>
      _conversationsLoadedController.stream;

  @override
  Stream<MessageReponseModel> get onMessagesLoaded =>
      _messagesLoadedController.stream;

  @override
  Stream<Map<String, dynamic>> get onTypingStart =>
      _typingStartController.stream;

  @override
  Stream<Map<String, dynamic>> get onTypingStop => _typingStopController.stream;

  @override
  Stream<MessageEntity> get onNewMessage => _newMessageController.stream;

  @override
  Stream<MessageEntity> get onMessageUpdated =>
      _messageUpdatedController.stream;

  @override
  Stream<Map<String, dynamic>> get onMessageRead =>
      _messageReadController.stream;

  @override
  Stream<ConversationModel> get onConversationUpdate =>
      _conversationUpdateController.stream;

  // @override
  // Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;

  /// Connect to chat namespace
  @override
  void connect(String userId, String username) {
    // Reset connection state
    _isConnected = false;
    _connectionCompleter = Completer<void>();

    _socketClient.connect(
      namespace: 'chat',
      userId: userId,
      username: username,
    );

    // Setup connection listeners
    _setupConnectionListeners();
    _setupConversationListeners();
    _setupMessageListeners();
    _setupTypingListeners();
    _setupNewMessageListeners();
    _setupMessageUpdatedListeners();
    _setupMessageReadListeners();
  }

  /// Wait for connection to be established
  @override
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (_isConnected) {
      return;
    }

    if (_connectionCompleter == null) {
      throw Exception('Connection not initiated');
    }

    return _connectionCompleter!.future.timeout(
      timeout,
      onTimeout: () {
        throw TimeoutException('Connection timeout', timeout);
      },
    );
  }

  /// Setup connection listeners
  void _setupConnectionListeners() {
    // Listen for connection success
    _socketClient.on('connected').listen((data) {
      developer.log(
        'Connected to chat namespace: ${data['message']}',
        name: 'ChatDataSource',
      );
    });

    // Listen for register acknowledgment
    _socketClient.on('register:ack').listen((data) {
      developer.log(
        'Registered to chat namespace: ${data['userId']} (${data['username']})',
        name: 'ChatDataSource',
      );

      // Mark as connected when registration is acknowledged
      _isConnected = true;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }
    });

    // Listen for errors
    _socketClient.on('error').listen((data) {
      developer.log('Chat error: ${data['message']}', name: 'ChatDataSource');
    });
  }

  /// Setup listeners for conversation events
  void _setupConversationListeners() {
    // Listen for conversations loaded
    _socketClient.on('conversations:list').listen((data) {
      developer.log(
        'Conversations loaded from backend',
        name: 'ChatDataSource',
      );
      developer.log(
        'Raw response data: ${data.toString()}',
        name: 'ChatDataSource',
      );
      try {
        final response = ConversationsResponseModel.fromJson(data);

        // Cache the response
        final cacheKey =
            '${response.pagination.currentPage}_${response.pagination.itemsPerPage}';
        _conversationsCache[cacheKey] = response;

        _conversationsLoadedController.add(response);

        developer.log(
          'Loaded ${response.data.length} conversations, page ${response.pagination.currentPage}/${response.pagination.totalPages}',
          name: 'ChatDataSource',
        );
      } catch (e) {
        developer.log(
          'Error parsing conversations:list: $e',
          name: 'ChatDataSource',
        );
      }
    });

    // Listen for conversation updates
    _socketClient.on('conversation:updated').listen((data) {
      developer.log('Conversation updated event', name: 'ChatDataSource');
      try {
        final conversation = ConversationModel.fromJson(
          data as Map<String, dynamic>,
        );
        _conversationUpdateController.add(conversation);
      } catch (e) {
        developer.log(
          'Error parsing conversation:updated: $e',
          name: 'ChatDataSource',
        );
      }
    });
  }

  // /// Setup listeners for message events
  void _setupMessageListeners() {
    // Listen for messages loaded
    _socketClient.on('messages:loaded').listen((data) {
      developer.log('Messages loaded from backend', name: 'ChatDataSource');
      developer.log(
        'Raw messages data: ${data.toString()}',
        name: 'ChatDataSource',
      );
      try {
        final response = MessageReponseModel.fromJson(data);
        _messagesLoadedController.add(response);

        developer.log(
          'Loaded ${response.data.length} messages, page ${response.pagination.currentPage}/${response.pagination.totalPages}',
          name: 'ChatDataSource',
        );
      } catch (e) {
        developer.log(
          'Error parsing messages:loaded: $e',
          name: 'ChatDataSource',
        );
      }
    });
  }

  /// Setup listeners for new message events
  void _setupNewMessageListeners() {
    _socketClient.on('message:new').listen((data) {
      developer.log('New message event: $data', name: 'ChatDataSource');

      try {
        final messageModel = MessageModel.fromJson(data);
        final messageEntity = messageModel.toEntity();
        _newMessageController.add(messageEntity);

        developer.log(
          'New message parsed successfully: ${messageEntity.id}',
          name: 'ChatDataSource',
        );
      } catch (e, stackTrace) {
        developer.log('Error parsing message:new: $e', name: 'ChatDataSource');
        developer.log('Raw data: $data', name: 'ChatDataSource');
        developer.log('Stack trace: $stackTrace', name: 'ChatDataSource');
      }
    });
  }

  /// Setup listeners for message updated events
  void _setupMessageUpdatedListeners() {
    _socketClient.on('message:updated').listen((data) {
      developer.log('Message updated event: $data', name: 'ChatDataSource');

      try {
        final messageModel = MessageModel.fromJson(data);
        final messageEntity = messageModel.toEntity();
        _messageUpdatedController.add(messageEntity);

        developer.log(
          'Message updated parsed successfully: ${messageEntity.id}',
          name: 'ChatDataSource',
        );
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing message:updated: $e',
          name: 'ChatDataSource',
        );
        developer.log('Raw data: $data', name: 'ChatDataSource');
        developer.log('Stack trace: $stackTrace', name: 'ChatDataSource');
      }
    });
  }

  /// Setup listeners for message read events
  void _setupMessageReadListeners() {
    _socketClient.on('message:read').listen((data) {
      developer.log('Message read event: $data', name: 'ChatDataSource');

      try {
        final readData = Map<String, dynamic>.from(data);
        _messageReadController.add(readData);

        developer.log(
          'Message read event received: messageId=${readData['messageId']}, userId=${readData['userId']}',
          name: 'ChatDataSource',
        );
      } catch (e, stackTrace) {
        developer.log('Error parsing message:read: $e', name: 'ChatDataSource');
        developer.log('Raw data: $data', name: 'ChatDataSource');
        developer.log('Stack trace: $stackTrace', name: 'ChatDataSource');
      }
    });
  }

  /// Setup listeners for typing events
  void _setupTypingListeners() {
    _socketClient.on('typing:start').listen((data) {
      developer.log('Typing start event: $data', name: 'ChatDataSource');
      _typingStartController.add(Map<String, dynamic>.from(data));
    });

    _socketClient.on('typing:stop').listen((data) {
      developer.log('Typing stop event: $data', name: 'ChatDataSource');
      _typingStopController.add(Map<String, dynamic>.from(data));
    });
  }

  /// Load conversations
  @override
  Future<ConversationsResponseModel> getConversations({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    developer.log(
      'Loading conversations for user: $userId, page: $page, limit: $limit',
      name: 'ChatDataSource',
    );

    // Wait for connection to be established
    try {
      await waitForConnection();
    } catch (e) {
      developer.log('Connection not ready: $e', name: 'ChatDataSource');
      throw Exception('Chat connection not ready: $e');
    }

    final completer = Completer<ConversationsResponseModel>();

    // Setup one-time listener for response
    late StreamSubscription subscription;
    subscription = _conversationsLoadedController.stream.listen((response) {
      if (response.pagination.currentPage == page &&
          response.pagination.itemsPerPage == limit) {
        subscription.cancel();
        completer.complete(response);
      }
    });

    // Emit the request
    _socketClient.emit('conversations:get', {
      'userId': userId,
      'page': page,
      'limit': limit,
    });

    // Set timeout
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(TimeoutException('Load conversations timeout'));
      }
    });

    return completer.future;
  }

  /// Join conversation
  @override
  Future<void> joinConversation({
    required String userId,
    required String conversationId,
  }) async {
    developer.log(
      'Joining conversation: $conversationId for user: $userId',
      name: 'ChatDataSource',
    );

    // Wait for connection to be established
    try {
      await waitForConnection();
    } catch (e) {
      developer.log(
        'Connection not ready for join conversation: $e',
        name: 'ChatDataSource',
      );
      throw Exception('Chat connection not ready: $e');
    }

    // Emit the join request and wait for response
    // Backend returns response directly, not via event
    try {
      _socketClient.emit('conversation:join', {
        'userId': userId,
        'conversationId': conversationId,
      });

      developer.log(
        'Join conversation request sent successfully',
        name: 'ChatDataSource',
      );

      // Since backend handles join synchronously and marks messages as read,
      // we can consider the join successful if no error is thrown
      return Future.value();
    } catch (e) {
      developer.log(
        'Error emitting join conversation: $e',
        name: 'ChatDataSource',
      );
      throw Exception('Failed to join conversation: $e');
    }
  }

  @override
  Future<void> leaveConversation({required String conversationId}) async {
    developer.log(
      'Leaving conversation: $conversationId',
      name: 'ChatDataSource',
    );

    // Wait for connection to be established
    try {
      await waitForConnection();
    } catch (e) {
      developer.log(
        'Connection not ready for leave conversation: $e',
        name: 'ChatDataSource',
      );
      throw Exception('Chat connection not ready: $e');
    }

    try {
      _socketClient.emit('conversation:leave', {
        'conversationId': conversationId,
      });

      developer.log(
        'Leave conversation request sent successfully',
        name: 'ChatDataSource',
      );

      return Future.value();
    } catch (e) {
      developer.log(
        'Error emitting leave conversation: $e',
        name: 'ChatDataSource',
      );
      throw Exception('Failed to leave conversation: $e');
    }
  }

  /// Get cached conversations data
  ConversationsResponseModel? getCachedConversations({
    int page = 1,
    int limit = 10,
  }) {
    final cacheKey = '${page}_$limit';
    return _conversationsCache[cacheKey];
  }

  /// Clear conversations cache
  void clearConversationsCache() {
    developer.log('Clearing conversations cache', name: 'ChatDataSource');
    _conversationsCache.clear();
  }

  /// Load messages in a conversation
  @override
  Future<MessageReponseModel> getConversationMessages({
    required String userId,
    required String conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    developer.log(
      'Loading messages for user: $userId, conversation: $conversationId, page: $page, limit: $limit',
      name: 'ChatDataSource',
    );

    // // Wait for connection to be established
    // try {
    //   await waitForConnection();
    // } catch (e) {
    //   developer.log('Connection not ready: $e', name: 'ChatDataSource');
    //   throw Exception('Chat connection not ready: $e');
    // }

    final completer = Completer<MessageReponseModel>();

    // Setup one-time listener for response
    late StreamSubscription subscription;
    subscription = _messagesLoadedController.stream.listen((response) {
      if (response.pagination.currentPage == page &&
          response.pagination.itemsPerPage == limit) {
        subscription.cancel();
        completer.complete(response);
      }
    });

    // Emit the request
    _socketClient.emit('messages:get', {
      'userId': userId,
      'conversationId': conversationId,
      'page': page,
      'limit': limit,
    });

    // Set timeout
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(TimeoutException('Load messages timeout'));
      }
    });

    return completer.future;
  }

  /// Load messages around a specific message ID
  @override
  Future<MessageReponseModel> getMessagesAroundId({
    required String userId,
    required String conversationId,
    required String messageId,
    int limit = 20,
  }) async {
    developer.log(
      'Loading messages around ID: $messageId for user: $userId, conversation: $conversationId, limit: $limit',
      name: 'ChatDataSource',
    );

    final completer = Completer<MessageReponseModel>();

    // Setup one-time listener for response
    late StreamSubscription subscription;
    subscription = _messagesLoadedController.stream.listen((response) {
      // Check if response contains the target message
      final hasTargetMessage = response.data.any((msg) => msg.id == messageId);
      if (hasTargetMessage) {
        subscription.cancel();
        completer.complete(response);
      }
    });

    // Emit the request
    _socketClient.emit('messages:getAroundId', {
      'userId': userId,
      'conversationId': conversationId,
      'messageId': messageId,
      'limit': limit,
    });

    // Set timeout
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(
          TimeoutException('Load messages around ID timeout'),
        );
      }
    });

    return completer.future;
  }

  /// Emit typing start event
  @override
  void emitTypingStart({
    required String userId,
    required String conversationId,
  }) {
    developer.log(
      'Emitting typing:start for conversation: $conversationId',
      name: 'ChatDataSource',
    );

    if (!_isConnected) {
      developer.log('Connection not ready for typing', name: 'ChatDataSource');
      return;
    }

    _socketClient.emit('typing:start', {
      'userId': userId,
      'conversationId': conversationId,
    });
  }

  /// Emit typing stop event
  @override
  void emitTypingStop({
    required String userId,
    required String conversationId,
  }) {
    developer.log(
      'Emitting typing:stop for conversation: $conversationId',
      name: 'ChatDataSource',
    );

    if (!_isConnected) {
      developer.log('Connection not ready for typing', name: 'ChatDataSource');
      return;
    }

    _socketClient.emit('typing:stop', {
      'userId': userId,
      'conversationId': conversationId,
    });
  }

  /// Send message
  @override
  void sendMessage({
    required String userId,
    required String conversationId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
  }) {
    developer.log(
      'Sending message to conversation: $conversationId',
      name: 'ChatDataSource',
    );

    if (!_isConnected) {
      developer.log(
        'Connection not ready for sending message',
        name: 'ChatDataSource',
      );
      return;
    }

    final messageData = <String, dynamic>{
      'userId': userId,
      'conversationId': conversationId,
    };

    if (text != null && text.isNotEmpty) {
      messageData['text'] = text;
    }

    if (attachments != null && attachments.isNotEmpty) {
      messageData['attachments'] = attachments;
    }

    if (replyTo != null && replyTo.isNotEmpty) {
      messageData['replyTo'] = replyTo;
    }

    _socketClient.emit('message:send', messageData);
  }

  @override
  void editMessage({
    required String userId,
    required String messageId,
    required String newText,
  }) {
    developer.log('Editing message: $messageId', name: 'ChatDataSource');
    if (!_isConnected) {
      developer.log(
        'Connection not ready for editing message',
        name: 'ChatDataSource',
      );
      return;
    }
    final editData = <String, dynamic>{
      'userId': userId,
      'messageId': messageId,
      'newText': newText,
    };
    _socketClient.emit('message:update', editData);
  }

  /// Get message edit logs
  @override
  Future<List<MessageEditLogEntity>> getMessageEditLogs({
    required String userId,
    required String messageId,
  }) async {
    developer.log(
      'Getting edit logs for message: $messageId',
      name: 'ChatDataSource',
    );

    // Wait for connection to be established
    try {
      await waitForConnection();
    } catch (e) {
      developer.log('Connection not ready: $e', name: 'ChatDataSource');
      throw Exception('Chat connection not ready: $e');
    }

    final completer = Completer<List<MessageEditLogEntity>>();

    // Setup one-time listener for response
    late StreamSubscription subscription;
    subscription = _socketClient.on('message:editLogs:loaded').listen((data) {
      if (data['messageId'] == messageId) {
        subscription.cancel();
        try {
          final editLogsJson = data['editLogs'] as List<dynamic>;
          final editLogs = editLogsJson
              .map(
                (log) =>
                    MessageEditLogModel.fromJson(log as Map<String, dynamic>),
              )
              .toList();
          completer.complete(editLogs);
        } catch (e) {
          completer.completeError(Exception('Failed to parse edit logs: $e'));
        }
      }
    });

    // Emit the request
    _socketClient.emit('message:editLogs:get', {
      'userId': userId,
      'messageId': messageId,
    });

    // Set timeout
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(TimeoutException('Get edit logs timeout'));
      }
    });

    return completer.future;
  }

  /// Mark messages as read
  @override
  void markAsRead({
    required String userId,
    required String conversationId,
    String? messageId,
  }) {
    developer.log(
      'Marking messages as read for conversation: $conversationId${messageId != null ? ', messageId: $messageId' : ''}',
      name: 'ChatDataSource',
    );

    if (!_isConnected) {
      developer.log(
        'Connection not ready for marking as read',
        name: 'ChatDataSource',
      );
      return;
    }

    final readData = <String, dynamic>{
      'userId': userId,
      'conversationId': conversationId,
    };

    if (messageId != null && messageId.isNotEmpty) {
      readData['messageId'] = messageId;
    }

    _socketClient.emit('message:read', readData);
  }

  /// Disconnect
  @override
  void disconnect() {
    _socketClient.disconnect();
  }

  /// Dispose all resources
  @override
  void dispose() {
    _socketClient.dispose();
    _conversationsLoadedController.close();
    _messagesLoadedController.close();
    _typingStartController.close();
    _typingStopController.close();
    _newMessageController.close();
    _messageUpdatedController.close();
    _messageReadController.close();
    // _conversationUpdateController.close();
    // _userOnlineController.close();
    _conversationsCache.clear();
  }
}
