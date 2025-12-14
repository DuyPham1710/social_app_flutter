import 'dart:async';
import 'dart:developer' as developer;
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/video_call/data/models/video_call_models.dart';
import 'package:social_app_fe/features/video_call/domain/entities/call_response_entity.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';

class VideoCallRemoteDataSource {
  final SocketClient _socketClient;

  // Stream controllers for real-time events
  final _incomingCallController =
      StreamController<IncomingCallEntity>.broadcast();
  final _callAcceptedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _callRejectedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _callEndedController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Connection state tracking
  bool _isConnected = false;
  Completer<void>? _connectionCompleter;

  VideoCallRemoteDataSource(this._socketClient);

  // Getters for streams
  Stream<IncomingCallEntity> get onIncomingCall =>
      _incomingCallController.stream;
  Stream<Map<String, dynamic>> get onCallAccepted =>
      _callAcceptedController.stream;
  Stream<Map<String, dynamic>> get onCallRejected =>
      _callRejectedController.stream;
  Stream<Map<String, dynamic>> get onCallEnded => _callEndedController.stream;

  /// Connect to video-call namespace
  void connect(String userId, String username) {
    _isConnected = false;
    _connectionCompleter = Completer<void>();

    _socketClient.connect(
      namespace: 'video-call',
      userId: userId,
      username: username,
    );

    _setupConnectionListeners();
    _setupCallListeners();
  }

  /// Wait for connection to be established
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
    _socketClient.on('connected').listen((data) {
      developer.log(
        'Connected to video-call namespace: ${data['message']}',
        name: 'VideoCallDataSource',
      );
    });

    _socketClient.on('register:ack').listen((data) {
      developer.log(
        'Registered to video-call namespace: ${data['userId']}',
        name: 'VideoCallDataSource',
      );

      _isConnected = true;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }
    });

    _socketClient.on('error').listen((data) {
      developer.log(
        'Video call error: ${data['message']}',
        name: 'VideoCallDataSource',
      );
    });
  }

  /// Setup listeners for call events
  void _setupCallListeners() {
    // Listen for incoming calls
    _socketClient.on('call:incoming').listen((data) {
      developer.log('Incoming call event: $data', name: 'VideoCallDataSource');
      try {
        final incomingCall = IncomingCallModel.fromJson(data);
        _incomingCallController.add(incomingCall.toEntity());
      } catch (e) {
        developer.log(
          'Error parsing call:incoming: $e',
          name: 'VideoCallDataSource',
        );
      }
    });

    // Listen for call created (caller receives this with token)
    _socketClient.on('call:created').listen((data) {
      developer.log('Call created event: $data', name: 'VideoCallDataSource');
    });

    // Listen for call accepted
    _socketClient.on('call:accepted').listen((data) {
      developer.log('Call accepted event: $data', name: 'VideoCallDataSource');
      _callAcceptedController.add(Map<String, dynamic>.from(data));
    });

    // Listen for call rejected
    _socketClient.on('call:rejected').listen((data) {
      developer.log('Call rejected event: $data', name: 'VideoCallDataSource');
      _callRejectedController.add(Map<String, dynamic>.from(data));
    });

    // Listen for call ended
    _socketClient.on('call:ended').listen((data) {
      developer.log('Call ended event: $data', name: 'VideoCallDataSource');
      _callEndedController.add(Map<String, dynamic>.from(data));
    });
  }

  /// Create a call (1-1)
  Future<CallResponseEntity> createCall({
    required String userId,
    required String receiverId,
    required String callType,
    String? conversationId,
  }) async {
    developer.log(
      'Creating call: userId=$userId, receiverId=$receiverId, callType=$callType',
      name: 'VideoCallDataSource',
    );

    // IMPORTANT: Wait for connection before proceeding
    try {
      await waitForConnection();
    } catch (e) {
      developer.log(
        'Connection not ready: $e',
        name: 'VideoCallDataSource',
      );
      throw Exception('Video call connection not ready: $e');
    }

    final completer = Completer<CallResponseEntity>();

    // Listen for call:created event (one-time)
    late StreamSubscription subscription;
    subscription = _socketClient.on('call:created').listen((data) {
      developer.log(
        'Received call:created event: $data',
        name: 'VideoCallDataSource',
      );
      subscription.cancel();
      try {
        final response = CallResponseModel.fromJson(data);
        completer.complete(response.toEntity());
      } catch (e) {
        developer.log(
          'Failed to parse call response: $e',
          name: 'VideoCallDataSource',
        );
        completer.completeError(Exception('Failed to parse call response: $e'));
      }
    });

    // Small delay to ensure listener is registered
    await Future.delayed(const Duration(milliseconds: 100));

    // Emit call:invite
    _socketClient.emit('call:invite', {
      'userId': userId,
      'receiverId': receiverId,
      'callType': callType,
      if (conversationId != null) 'conversationId': conversationId,
    });

    // Set timeout (increase from 10s to 15s for better reliability)
    Timer(const Duration(seconds: 15), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        developer.log(
          'Create call timeout - no response from server',
          name: 'VideoCallDataSource',
        );
        completer.completeError(
          TimeoutException('Create call timeout - no response from server'),
        );
      }
    });

    return completer.future;
  }

  /// Accept a call
  Future<CallTokenEntity> acceptCall({
    required String userId,
    required String callId,
  }) async {
    developer.log('Accepting call: $callId', name: 'VideoCallDataSource');

    await waitForConnection();

    final completer = Completer<CallTokenEntity>();

    // Listen for call:accepted event (one-time)
    late StreamSubscription subscription;
    subscription = _socketClient.on('call:accepted').listen((data) {
      subscription.cancel();
      try {
        final token = data['token'] as String;
        final appId = data['appId'] as String;
        final channelId = data['channelId'] as String;
        final callId = data['callId'] as String;

        completer.complete(
          CallTokenEntity(
            token: token,
            appId: appId,
            channelId: channelId,
            callId: callId,
          ),
        );
      } catch (e) {
        completer.completeError(Exception('Failed to parse call token: $e'));
      }
    });

    // Emit call:accept
    _socketClient.emit('call:accept', {'userId': userId, 'callId': callId});

    // Set timeout
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(TimeoutException('Accept call timeout'));
      }
    });

    return completer.future;
  }

  /// Reject a call
  void rejectCall({required String userId, required String callId}) {
    developer.log('Rejecting call: $callId', name: 'VideoCallDataSource');

    if (!_isConnected) {
      developer.log(
        'Not connected, cannot reject call',
        name: 'VideoCallDataSource',
      );
      return;
    }

    _socketClient.emit('call:reject', {'userId': userId, 'callId': callId});
  }

  /// End a call
  void endCall({
    required String userId,
    required String callId,
    int? duration,
    String? callStatus,
  }) {
    developer.log(
      'Ending call: $callId, duration: $duration, status: $callStatus',
      name: 'VideoCallDataSource',
    );

    if (!_isConnected) {
      developer.log(
        'Not connected, cannot end call',
        name: 'VideoCallDataSource',
      );
      return;
    }

    _socketClient.emit('call:end', {
      'userId': userId,
      'callId': callId,
      if (duration != null) 'duration': duration,
      if (callStatus != null) 'callStatus': callStatus,
    });
  }

  /// Disconnect
  void disconnect() {
    _socketClient.disconnect();
    _isConnected = false;
  }

  /// Dispose all resources
  void dispose() {
    _socketClient.dispose();
    _incomingCallController.close();
    _callAcceptedController.close();
    _callRejectedController.close();
    _callEndedController.close();
  }
}
