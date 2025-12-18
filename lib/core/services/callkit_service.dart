import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

/// CallKit Service to handle native incoming call UI
class CallKitService {
  static final CallKitService _instance = CallKitService._internal();
  factory CallKitService() => _instance;
  CallKitService._internal();

  final _uuid = const Uuid();
  StreamSubscription<CallEvent?>? _callEventSubscription;

  // Callbacks for call actions
  Function(Map<String, dynamic> callData)? onCallAccepted;
  Function(Map<String, dynamic> callData)? onCallRejected;
  Function(Map<String, dynamic> callData)? onCallEnded;

  /// Initialize CallKit service and listen to events
  Future<void> initialize() async {
    try {
      // Listen to CallKit events
      _callEventSubscription = FlutterCallkitIncoming.onEvent.listen(
        _handleCallKitEvent,
      );

      debugPrint('[CallKit] Service initialized successfully');
    } catch (e) {
      debugPrint('[CallKit] Error initializing: $e');
    }
  }

  /// Handle CallKit events
  void _handleCallKitEvent(CallEvent? event) {
    if (event == null) {
      debugPrint('[CallKit] Received null event');
      return;
    }

    debugPrint('[CallKit] Event: ${event.event}');

    switch (event.event) {
      case Event.actionCallAccept:
        // User accepted the call
        debugPrint('[CallKit] Call accepted: ${event.body}');
        if (onCallAccepted != null && event.body != null) {
          final rawExtra = event.body!['extra'] as Map?;
          if (rawExtra != null) {
            // Sử dụng Map.from để chuyển đổi kiểu an toàn
            final extraData = Map<String, dynamic>.from(rawExtra);
            onCallAccepted!(extraData);
          }
        }

      case Event.actionCallDecline:
        // User declined the call
        debugPrint('[CallKit] Call declined: ${event.body}');
        if (onCallRejected != null && event.body != null) {
          final rawExtra = event.body!['extra'] as Map?;
          if (rawExtra != null) {
            final extraData = Map<String, dynamic>.from(rawExtra);
            onCallRejected!(extraData);
          }
        }

      case Event.actionCallEnded:
        // Call ended by user
        debugPrint('[CallKit] Call ended: ${event.body}');
        if (onCallEnded != null && event.body != null) {
          final rawExtra = event.body!['extra'] as Map?;
          if (rawExtra != null) {
            final extraData = Map<String, dynamic>.from(rawExtra);
            onCallEnded!(extraData);
          }
        }

      case Event.actionCallTimeout:
        // Call timed out
        debugPrint('[CallKit] Call timeout: ${event.body}');
        if (onCallEnded != null && event.body != null) {
          final rawExtra = event.body!['extra'] as Map?;
          if (rawExtra != null) {
            final extraData = Map<String, dynamic>.from(rawExtra);
            onCallEnded!(extraData);
          }
        }

      default:
        debugPrint('[CallKit] Unhandled event: ${event.event}');
    }
  }

  /// Show incoming call UI
  Future<void> showIncomingCall(Map<String, dynamic> callData) async {
    try {
      final callId = callData['callId'] ?? _uuid.v4();
      final callerName = callData['callerName'] ?? 'Unknown';
      final callerAvatar = callData['callerAvatar'] ?? '';
      final callType = callData['callType'] ?? 'video';

      final params = CallKitParams(
        id: callId,
        nameCaller: callerName,
        appName: 'Social App',
        avatar: callerAvatar,
        handle: callType == 'video' ? 'Video Call' : 'Audio Call',
        type: callType == 'video' ? 1 : 0, // 0: audio, 1: video
        duration: 30000, // 30 seconds timeout
        textAccept: 'Accept',
        textDecline: 'Decline',
        missedCallNotification: const NotificationParams(
          showNotification: true,
          isShowCallback: true,
          subtitle: 'Missed call',
          callbackText: 'Call back',
        ),
        extra: callData, // Pass all call data for later use
        headers: <String, dynamic>{'platform': 'flutter'},
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: '',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call",
        ),
        ios: const IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
          supportsDTMF: true,
          supportsHolding: true,
          supportsGrouping: false,
          supportsUngrouping: false,
          ringtonePath: 'system_ringtone_default',
        ),
      );

      await FlutterCallkitIncoming.showCallkitIncoming(params);
      debugPrint('[CallKit] Showing incoming call: $callId');
    } catch (e) {
      debugPrint('[CallKit] Error showing incoming call: $e');
    }
  }

  /// Start an outgoing call
  Future<void> startCall(Map<String, dynamic> callData) async {
    try {
      final callId = callData['callId'] ?? _uuid.v4();
      final receiverName = callData['receiverName'] ?? 'Unknown';
      final callType = callData['callType'] ?? 'video';

      final params = CallKitParams(
        id: callId,
        nameCaller: receiverName,
        appName: 'Social App',
        handle: callType == 'video' ? 'Video Call' : 'Audio Call',
        type: callType == 'video' ? 1 : 0,
        extra: callData,
        android: const AndroidParams(
          isCustomNotification: true,
          backgroundColor: '#0955fa',
        ),
        ios: const IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
        ),
      );

      await FlutterCallkitIncoming.startCall(params);
      debugPrint('[CallKit] Started outgoing call: $callId');
    } catch (e) {
      debugPrint('[CallKit] Error starting call: $e');
    }
  }

  /// End a specific call
  Future<void> endCall(String callId) async {
    try {
      await FlutterCallkitIncoming.endCall(callId);
      debugPrint('[CallKit] Ended call: $callId');
    } catch (e) {
      debugPrint('[CallKit] Error ending call: $e');
    }
  }

  /// End all active calls
  Future<void> endAllCalls() async {
    try {
      await FlutterCallkitIncoming.endAllCalls();
      debugPrint('[CallKit] Ended all calls');
    } catch (e) {
      debugPrint('[CallKit] Error ending all calls: $e');
    }
  }

  /// Get active calls
  Future<List<dynamic>> getActiveCalls() async {
    try {
      final calls = await FlutterCallkitIncoming.activeCalls();
      debugPrint('[CallKit] Active calls: $calls');
      return calls;
    } catch (e) {
      debugPrint('[CallKit] Error getting active calls: $e');
      return [];
    }
  }

  /// Dispose service
  void dispose() {
    _callEventSubscription?.cancel();
    debugPrint('[CallKit] Service disposed');
  }
}
