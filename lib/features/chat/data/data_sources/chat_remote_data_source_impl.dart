import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_app_fe/features/chat/data/models/message_reponse_model.dart';
import 'package:social_app_fe/features/chat/data/models/message-edit-log_model.dart';
import 'package:social_app_fe/features/chat/data/models/message_translation_model.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';

import '../../../../core/network/websocket/socket_client.dart';
import '../models/chat_models.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SocketClient _socketClient;
  final Dio _dio;

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
  final _conversationCreatedController =
      StreamController<ConversationModel>.broadcast();
  // final _userOnlineController =
  //     StreamController<Map<String, dynamic>>.broadcast();

  // Cache for conversations data
  final Map<String, ConversationsResponseModel> _conversationsCache = {};

  // Connection state tracking
  bool _isConnected = false;
  Completer<void>? _connectionCompleter;

  // Track current conversation for automatic rejoin on reconnect
  String? _currentJoinedConversationId;
  String? _currentUserId;

  ChatRemoteDataSourceImpl(this._socketClient, this._dio);

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

  @override
  Stream<ConversationModel> get onConversationCreated =>
      _conversationCreatedController.stream;

  // @override
  // Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;

  /// Connect to chat namespace
  @override
  void connect(String userId, String username) {
    _currentUserId = userId;

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
    _setupConversationCreatedListeners();
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

      // Rejoin conversation if needed (e.g. after background reconnect)
      if (_currentJoinedConversationId != null && _currentUserId != null) {
        developer.log(
          'Rejoining conversation: $_currentJoinedConversationId after reconnect',
          name: 'ChatDataSource',
        );
        _socketClient.emit('conversation:join', {
          'userId': _currentUserId,
          'conversationId': _currentJoinedConversationId,
        });
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

  /// Setup listeners for conversation created events
  void _setupConversationCreatedListeners() {
    _socketClient.on('conversation:created').listen((data) {
      developer.log('Conversation created event', name: 'ChatDataSource');
      try {
        final conversationData = data as Map<String, dynamic>;
        final conversation = ConversationModel.fromJson(
          conversationData['conversation'] as Map<String, dynamic>,
        );
        _conversationCreatedController.add(conversation);
        developer.log(
          'Conversation created: ${conversation.id}',
          name: 'ChatDataSource',
        );
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing conversation:created: $e',
          name: 'ChatDataSource',
        );
        developer.log('Raw data: $data', name: 'ChatDataSource');
        developer.log('Stack trace: $stackTrace', name: 'ChatDataSource');
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

  /// Create conversation
  @override
  Future<ConversationModel> createConversation({
    required String userId,
    required List<String> participantIds,
    bool isGroup = false,
    String? name,
    String? avatar,
  }) async {
    developer.log(
      'Creating conversation for user: $userId with participants: $participantIds',
      name: 'ChatDataSource',
    );

    // Wait for connection to be established
    try {
      await waitForConnection();
    } catch (e) {
      developer.log('Connection not ready: $e', name: 'ChatDataSource');
      throw Exception('Chat connection not ready: $e');
    }

    final completer = Completer<ConversationModel>();

    // Setup one-time listener for conversation:created event
    // Backend sẽ emit conversation:created cho tất cả participants (bao gồm cả người tạo)
    // LƯU Ý: Backend chỉ emit event khi conversation MỚI được tạo
    // Nếu conversation đã tồn tại, backend chỉ return response trực tiếp (không emit event)
    // Vì socket.io client trong Dart không hỗ trợ acknowledgment, chúng ta chỉ có thể
    // nhận conversation qua event conversation:created
    late StreamSubscription subscription;
    subscription = _conversationCreatedController.stream.listen((conversation) {
      // Kiểm tra xem conversation này có chứa userId và participantIds không
      final participantIdsInConversation = conversation.participants
          .map((p) => p.userId)
          .toSet();
      final expectedParticipants = {userId, ...participantIds}.toSet();

      // Chỉ complete nếu conversation match với request
      if (participantIdsInConversation.containsAll(expectedParticipants) &&
          expectedParticipants.containsAll(participantIdsInConversation)) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(conversation);
        }
      }
    });

    // Emit the create request
    _socketClient.emit('conversation:create', {
      'userId': userId,
      'participantIds': participantIds,
      'isGroup': isGroup,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
    });

    // Set timeout - nếu không nhận được event trong 10 giây, có thể:
    // 1. Conversation đã tồn tại (backend không emit event)
    // 2. Network error
    // 3. Backend error
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(
          TimeoutException(
            'Create conversation timeout. Conversation may already exist or network error occurred.',
          ),
        );
      }
    });

    // Wait for conversation:created event
    try {
      return await completer.future;
    } catch (e) {
      subscription.cancel();
      if (e is TimeoutException) {
        throw TimeoutException(
          'Create conversation timeout. If conversation already exists, backend should emit conversation:created event.',
        );
      }
      rethrow;
    }
  }

  /// Join conversation
  @override
  Future<void> joinConversation({
    required String userId,
    required String conversationId,
  }) async {
    _currentUserId = userId;
    _currentJoinedConversationId = conversationId;

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
  Future<void> leaveConversation({
    required String conversationId,
    required String userId,
  }) async {
    if (_currentJoinedConversationId == conversationId) {
      _currentJoinedConversationId = null;
    }

    developer.log(
      'Leaving conversation: $conversationId (userId: $userId)',
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
        'userId': userId,
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

  /// Update conversation
  @override
  void updateConversation({
    required String userId,
    required String conversationId,
    String? name,
    String? avatar,
    String? createdBy,
    List<String>? participantIds,
  }) {
    developer.log(
      'Updating conversation: $conversationId',
      name: 'ChatDataSource',
    );

    if (!_isConnected) {
      developer.log(
        'Connection not ready for updating conversation',
        name: 'ChatDataSource',
      );
      throw Exception('Connection not ready');
    }

    final updateData = <String, dynamic>{
      'userId': userId,
      'conversationId': conversationId,
    };

    if (name != null) {
      updateData['name'] = name;
    }

    if (avatar != null) {
      updateData['avatar'] = avatar;
    }

    if (createdBy != null) {
      updateData['createdBy'] = createdBy;
    }

    if (participantIds != null && participantIds.isNotEmpty) {
      updateData['participantIds'] = participantIds;
    }

    _socketClient.emit('conversation:update', updateData);

    developer.log(
      'Update conversation request sent successfully',
      name: 'ChatDataSource',
    );
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

  /// Send message (WebSocket)
  @override
  void sendMessage({
    required String userId,
    required String conversationId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
    Map<String, dynamic>? metadata,
    String? storyId,
  }) {
    developer.log(
      'Sending message to conversation: $conversationId, storyId: $storyId',
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

    if (metadata != null && metadata.isNotEmpty) {
      messageData['metadata'] = metadata;
    }

    if (storyId != null && storyId.isNotEmpty) {
      messageData['storyId'] = storyId;
    }

    _socketClient.emit('message:send', messageData);
  }

  /// Upload files and return attachments URLs (HTTP with MultipartFile)
  @override
  Future<List<Map<String, dynamic>>> sendMessageWithFiles({
    required String conversationId,
    String? text,
    List<String>? filePaths,
    String? replyTo,
  }) async {
    developer.log(
      'Uploading files via HTTP for conversation: $conversationId',
      name: 'ChatDataSource',
    );

    try {
      // Create FormData
      final formData = FormData();

      // Add conversationId
      formData.fields.add(MapEntry('conversationId', conversationId));

      // Add text if provided
      if (text != null && text.isNotEmpty) {
        formData.fields.add(MapEntry('text', text));
      }

      // Add replyTo if provided
      if (replyTo != null && replyTo.isNotEmpty) {
        formData.fields.add(MapEntry('replyTo', replyTo));
      }

      // Add files if provided
      if (filePaths != null && filePaths.isNotEmpty) {
        for (var filePath in filePaths) {
          final fileName = filePath.split('/').last;
          formData.files.add(
            MapEntry(
              'files',
              await MultipartFile.fromFile(filePath, filename: fileName),
            ),
          );
        }
      }

      // Send POST request
      final response = await _dio.post('/chat/send-message', data: formData);

      developer.log(
        'Files uploaded successfully: ${response.data}',
        name: 'ChatDataSource',
      );

      // Extract attachments từ response
      final attachments = (response.data['attachments'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      return attachments;
    } catch (e) {
      developer.log('Error uploading files: $e', name: 'ChatDataSource');
      throw Exception('Failed to upload files: $e');
    }
  }

  @override
  Future<String> applyVoiceEffect({
    required String filePath,
    required String voicePreset,
  }) async {
    developer.log(
      'Applying voice effect from API for file: $filePath',
      name: 'ChatDataSource',
    );

    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'voicePreset': voicePreset,
      });

      final response = await _dio.post(
        '/chat/voice-effect',
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFilePath = '${tempDir.path}/voice_effect_$timestamp.wav';
      final file = File(newFilePath);
      await file.writeAsBytes(response.data);

      return newFilePath;
    } on DioException catch (e) {
      developer.log(
        'Voice effect dio error: ${e.message}',
        name: 'ChatDataSource',
      );
      if (e.response?.statusCode == 400) {
        throw Exception('Preset giọng không hợp lệ.');
      } else if (e.response?.statusCode == 503) {
        throw Exception('Dịch vụ AI chưa sẵn sàng. Vui lòng thử lại sau.');
      }
      throw Exception('Không thể chuyển giọng. Vui lòng thử lại.');
    } catch (e) {
      developer.log('Error applying voice effect: $e', name: 'ChatDataSource');
      throw Exception('Lỗi hệ thống khi chuyển giọng: $e');
    }
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

  @override
  void reactMessage({
    required String userId,
    required String conversationId,
    required String messageId,
    required String emojiId,
  }) {
    developer.log(
      'Reacting to message: $messageId with emoji: $emojiId',
      name: 'ChatDataSource',
    );
    if (!_isConnected) {
      developer.log(
        'Connection not ready for reacting to message',
        name: 'ChatDataSource',
      );
      return;
    }
    final reactData = <String, dynamic>{
      'userId': userId,
      'conversationId': conversationId,
      'messageId': messageId,
      'emojiId': emojiId,
    };
    _socketClient.emit('message:react', reactData);
  }

  @override
  void deleteMessage({
    required String userId,
    required String messageId,
    required bool deleteForEveryone,
  }) {
    developer.log(
      'Deleting message: $messageId, deleteForEveryone: $deleteForEveryone',
      name: 'ChatDataSource',
    );
    if (!_isConnected) {
      developer.log(
        'Connection not ready for deleting message',
        name: 'ChatDataSource',
      );
      return;
    }
    final deleteData = <String, dynamic>{
      'userId': userId,
      'messageId': messageId,
      'deleteForEveryone': deleteForEveryone,
    };
    _socketClient.emit('message:delete', deleteData);
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

  @override
  Future<MessageTranslationEntity> translateMessage({
    required String messageId,
    required String targetLang,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/message/$messageId/translate',
        queryParameters: {'targetLang': targetLang},
      );
      if (response.data != null) {
        return MessageTranslationModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception('Invalid translation response');
    } catch (e) {
      throw Exception('Failed to translate message: $e');
    }
  }

  @override
  Future<String> getSummaryUnread({
    required String conversationId,
    required List<String> messages,
    required String lang,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/conversation/$conversationId/summary-unread',
        data: {'messages': messages, 'lang': lang},
      );
      if (response.data != null && response.data['summary'] != null) {
        return response.data['summary'] as String;
      }
      return 'Không thể tải bản tóm tắt.';
    } catch (e) {
      throw Exception('Failed to get unread summary: $e');
    }
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
    _conversationUpdateController.close();
    _conversationCreatedController.close();
    // _userOnlineController.close();
    _conversationsCache.clear();
  }
}
