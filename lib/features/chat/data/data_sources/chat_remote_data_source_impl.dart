import 'dart:async';
import 'dart:developer' as developer;
import '../../../../core/network/websocket/socket_client.dart';
import '../models/chat_models.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SocketClient _socketClient;

  // Stream controllers for real-time events
  final _conversationsLoadedController =
      StreamController<ConversationsResponseModel>.broadcast();
  // final _newMessageController = StreamController<MessageModel>.broadcast();
  // final _conversationUpdateController =
  //     StreamController<ConversationModel>.broadcast();
  // final _typingController = StreamController<Map<String, dynamic>>.broadcast();
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

  // @override
  // Stream<MessageModel> get onNewMessage => _newMessageController.stream;

  // @override
  // Stream<ConversationModel> get onConversationUpdate =>
  //     _conversationUpdateController.stream;

  // @override
  // Stream<Map<String, dynamic>> get onTyping => _typingController.stream;

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
    // _setupMessageListeners();
    // _setupTypingListeners();
  }
  
  /// Wait for connection to be established
  Future<void> waitForConnection({Duration timeout = const Duration(seconds: 10)}) async {
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
    // _socketClient.on('conversation:updated').listen((data) {
    //   developer.log('Conversation updated event', name: 'ChatDataSource');
    //   try {
    //     final conversation = ConversationModel.fromJson(data);
    //     _conversationUpdateController.add(conversation);
    //   } catch (e) {
    //     developer.log(
    //       'Error parsing conversation:updated: $e',
    //       name: 'ChatDataSource',
    //     );
    //   }
    // });
  }

  // /// Setup listeners for message events
  // void _setupMessageListeners() {
  //   // Listen for new messages
  //   _socketClient.on('message:new').listen((data) {
  //     developer.log('New message event', name: 'ChatDataSource');
  //     try {
  //       final message = MessageModel.fromJson(data);
  //       _newMessageController.add(message);
  //     } catch (e) {
  //       developer.log('Error parsing message:new: $e', name: 'ChatDataSource');
  //     }
  //   });
  // }

  // /// Setup listeners for typing events
  // void _setupTypingListeners() {
  //   _socketClient.on('typing:status').listen((data) {
  //     developer.log('Typing status event', name: 'ChatDataSource');
  //     _typingController.add(Map<String, dynamic>.from(data));
  //   });

  //   _socketClient.on('user:online').listen((data) {
  //     developer.log('User online event', name: 'ChatDataSource');
  //     _userOnlineController.add(Map<String, dynamic>.from(data));
  //   });
  // }

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
      developer.log(
        'Connection not ready: $e',
        name: 'ChatDataSource',
      );
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
    // _newMessageController.close();
    // _conversationUpdateController.close();
    // _typingController.close();
    // _userOnlineController.close();
    _conversationsCache.clear();
  }
}
