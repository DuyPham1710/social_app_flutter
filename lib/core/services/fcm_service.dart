import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/services/callkit_service.dart';
import 'package:social_app_fe/core/network/dio_client.dart';
import 'package:http/http.dart' as http;

/// FCM Service to handle Firebase Cloud Messaging
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final CallKitService _callKitService = CallKitService();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  RemoteMessage? _pendingInitialMessage;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _createNotificationChannel();
      }

      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('[FCM] User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('[FCM] User granted provisional permission');
      } else {
        debugPrint('[FCM] User declined or has not accepted permission');
        return;
      }

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('[FCM] Token: $_fcmToken');

      if (_fcmToken != null) {
        await _sendTokenToBackend(_fcmToken!);
      }

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('[FCM] Token refreshed: $newToken');
        _fcmToken = newToken;
        _sendTokenToBackend(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle when user taps notification (app in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from terminated state
      // Save it to handle later after navigation callback is registered
      _pendingInitialMessage = await _firebaseMessaging.getInitialMessage();
      if (_pendingInitialMessage != null) {
        debugPrint('[FCM] App opened from terminated state with notification');
        debugPrint('[FCM] Will handle navigation after callback is registered');
      }

      debugPrint('[FCM] Service initialized successfully');
    } catch (e) {
      debugPrint('[FCM] Error initializing: $e');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  /// Handle local notification tap
  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('[FCM] Local notification tapped: ${response.payload}');

    if (response.payload != null && response.payload!.isNotEmpty) {
      final parts = response.payload!.split('|');
      if (parts.length >= 2 && parts[0] == 'new_message') {
        final conversationId = parts[1];
        final senderId = parts.length >= 3 ? parts[2] : null;
        final senderName = parts.length >= 4 ? parts[3] : null;
        final senderAvatar = parts.length >= 5 ? parts[4] : null;
        final unreadCount = parts.length >= 6 ? int.tryParse(parts[5]) ?? 0 : 0;
        final firstUnreadMessageIndex = parts.length >= 7
            ? int.tryParse(parts[6]) ?? -1
            : -1;
        _navigateToConversation(
          conversationId,
          senderId,
          senderName,
          senderAvatar,
          unreadCount: unreadCount,
          firstUnreadMessageIndex: firstUnreadMessageIndex,
        );
      }
    }
  }

  /// Handle foreground messages (app is open)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('[FCM] Foreground message: ${message.messageId}');
    debugPrint('[FCM] Data: ${message.data}');

    if (message.data['type'] == 'incoming_call') {
      // Show CallKit UI even when app is in foreground
      debugPrint('[FCM] Incoming call in foreground, showing CallKit UI');

      final callData = {
        'callId': message.data['callId'] ?? '',
        'callerName': message.data['callerName'] ?? 'Unknown',
        'callerAvatar': message.data['callerAvatar'] ?? '',
        'callType': message.data['callType'] ?? 'video',
        'receiverId': message.data['receiverId'] ?? '',
        'callerId': message.data['callerId'] ?? '',
      };

      await _callKitService.showIncomingCall(callData);
    } else if (message.data['type'] == 'call_ended') {
      // Dismiss call UI when caller ends call
      debugPrint('[FCM] Call ended in foreground, dismissing CallKit UI');

      final callId = message.data['callId'] as String?;
      if (callId != null && callId.isNotEmpty) {
        await _callKitService.endCall(callId);
        debugPrint('[FCM] CallKit UI dismissed for call: $callId');
      } else {
        await _callKitService.endAllCalls();
        debugPrint('[FCM] All CallKit UIs dismissed');
      }
    } else if (message.data['type'] == 'new_message') {
      debugPrint('[FCM] New message in foreground');
      await _showLocalNotification(message);
    }
  }

  /// Handle when user taps notification
  Future<void> _handleNotificationTap(RemoteMessage message) async {
    debugPrint('[FCM] Notification tapped: ${message.messageId}');
    debugPrint('[FCM] Data: ${message.data}');

    final messageType = message.data['type'];

    if (messageType == 'new_message') {
      // Navigate to chat conversation
      final conversationId = message.data['conversationId'];
      final senderId = message.data['senderId'];
      final senderName = message.data['senderName'];
      final senderAvatar = message.data['senderAvatar'];
      final unreadCount = int.tryParse(message.data['unreadCount'] ?? '0') ?? 0;
      final firstUnreadMessageIndex =
          int.tryParse(message.data['firstUnreadMessageIndex'] ?? '-1') ?? -1;

      if (conversationId != null && conversationId.isNotEmpty) {
        debugPrint('[FCM] Navigatingg to conversation: $conversationId');
        await _navigateToConversation(
          conversationId,
          senderId,
          senderName,
          senderAvatar,
          unreadCount: unreadCount,
          firstUnreadMessageIndex: firstUnreadMessageIndex,
        );
      }
    }
    // For incoming_call, navigation is handled by CallKitService
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final accessToken = await TokenStorage.getAccessToken();

      if (accessToken == null) {
        debugPrint('[FCM] No access token, skipping send to backend');
        return;
      }

      await DioClient.instance.post(
        '/user/fcm-token',
        data: {'fcmToken': token},
      );

      debugPrint('[FCM] Token sent to backend successfully');
    } catch (e) {
      debugPrint('[FCM] Error sending token to backend: $e');
    }
  }

  /// Manually update FCM token (call after login/register)
  Future<void> updateFcmToken() async {
    try {
      final token = _fcmToken ?? await _firebaseMessaging.getToken();
      if (token != null) {
        _fcmToken = token;
        await _sendTokenToBackend(token);
        debugPrint('[FCM] Manual token update completed');
      } else {
        debugPrint('[FCM] No FCM token available for manual update');
      }
    } catch (e) {
      debugPrint('[FCM] Error in manual token update: $e');
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('[FCM] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[FCM] Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('[FCM] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[FCM] Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      debugPrint('[FCM] Token deleted');
    } catch (e) {
      debugPrint('[FCM] Error deleting token: $e');
    }
  }

  /// Clear FCM token when logout (send empty token to backend)
  Future<void> clearFcmToken() async {
    try {
      final accessToken = await TokenStorage.getAccessToken();

      if (accessToken == null) {
        debugPrint('[FCM] No access token, skipping clear token');
        return;
      }

      // Send empty token to backend
      await DioClient.instance.post('/user/fcm-token', data: {'fcmToken': ''});

      debugPrint('[FCM] Token cleared on backend');

      // Delete token from Firebase
      await deleteToken();
    } catch (e) {
      debugPrint('[FCM] Error clearing FCM token: $e');
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    // Channel for incoming calls
    const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
      'incoming_call', // id (must match AndroidManifest.xml)
      'Incoming Call', // name
      description: 'Notification channel for incoming calls',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    // Channel for chat messages
    const AndroidNotificationChannel messageChannel =
        AndroidNotificationChannel(
          'chat_messages', // id
          'Chat Messages', // name
          description: 'Notification channel for chat messages',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(callChannel);
    await androidPlugin?.createNotificationChannel(messageChannel);

    debugPrint('[FCM] Notification channels created');
  }

  /// Show local notification for new message
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final senderName = message.data['senderName'] ?? 'Someone';
      final messageText = message.data['messageText'] ?? 'New message';
      final conversationId = message.data['conversationId'] ?? '';
      final senderId = message.data['senderId'] ?? '';
      final senderAvatar = message.data['senderAvatar'] ?? '';
      final unreadCount = int.tryParse(message.data['unreadCount'] ?? '0') ?? 0;
      final firstUnreadMessageIndex =
          int.tryParse(message.data['firstUnreadMessageIndex'] ?? '-1') ?? -1;

      // Download avatar image for large icon
      Uint8List? avatarBytes;

      ByteArrayAndroidBitmap? largeBitmap;

      ByteArrayAndroidIcon? personIcon;

      if (senderAvatar.isNotEmpty) {
        try {
          // Download image from URL
          final http.Response response = await http.get(
            Uri.parse(senderAvatar),
          );
          if (response.statusCode == 200) {
            // Convert to Android bitmap for large icon
            avatarBytes = response.bodyBytes;

            largeBitmap = ByteArrayAndroidBitmap(avatarBytes);
            personIcon = ByteArrayAndroidIcon(avatarBytes);
          }
        } catch (e) {
          debugPrint('[FCM] Error loading avatar: $e');
        }
      }

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'chat_messages',
            'Chat Messages',
            channelDescription: 'Notification channel for chat messages',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            largeIcon: largeBitmap,
            styleInformation: MessagingStyleInformation(
              Person(name: 'Me', key: 'me'),
              conversationTitle: senderName,
              groupConversation: false,
              messages: [
                Message(
                  messageText,
                  DateTime.now(),
                  Person(name: senderName, key: senderId, icon: personIcon),
                ),
              ],
            ),
          );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      final notificationId = conversationId.hashCode;

      await _localNotifications.show(
        notificationId,
        senderName,
        messageText,
        notificationDetails,
        payload:
            'new_message|$conversationId|$senderId|$senderName|$senderAvatar|$unreadCount|$firstUnreadMessageIndex',
      );

      debugPrint('[FCM] Local notification shown for message with avatar');
    } catch (e) {
      debugPrint('[FCM] Error showing local notification: $e');
    }
  }

  /// Handle pending initial message (called after navigation callback is registered)
  Future<void> handlePendingNavigation() async {
    if (_pendingInitialMessage != null) {
      debugPrint('[FCM] Handling pending initial message');
      await _handleNotificationTap(_pendingInitialMessage!);
      _pendingInitialMessage = null;
    }
  }

  /// Navigate to conversation screen (Chat_detail_page)
  Future<void> _navigateToConversation(
    String conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar, {
    int unreadCount = 0,
    int firstUnreadMessageIndex = -1,
  }) async {
    try {
      debugPrint(
        '[FCM] Navigate to conversation: $conversationId (unreadCount: $unreadCount, firstUnreadIndex: $firstUnreadMessageIndex)',
      );

      await NotificationNavigationHelper.navigateToConversation(
        conversationId,
        senderId,
        senderName,
        senderAvatar,
        unreadCount: unreadCount,
        firstUnreadMessageIndex: firstUnreadMessageIndex,
      );
    } catch (e) {
      debugPrint('[FCM] Error navigating to conversation: $e');
    }
  }
}

/// Helper class for navigation from notifications
class NotificationNavigationHelper {
  static Function(
    String conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar, {
    int unreadCount,
    int firstUnreadMessageIndex,
  })?
  _navigateToConversationCallback;

  /// Register navigation callback
  static void registerNavigationCallback(
    Function(
      String conversationId,
      String? senderId,
      String? senderName,
      String? senderAvatar, {
      int unreadCount,
      int firstUnreadMessageIndex,
    })
    callback,
  ) {
    _navigateToConversationCallback = callback;
  }

  /// Navigate to conversation
  static Future<void> navigateToConversation(
    String conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar, {
    int unreadCount = 0,
    int firstUnreadMessageIndex = -1,
  }) async {
    if (_navigateToConversationCallback != null) {
      _navigateToConversationCallback!(
        conversationId,
        senderId,
        senderName,
        senderAvatar,
        unreadCount: unreadCount,
        firstUnreadMessageIndex: firstUnreadMessageIndex,
      );
    } else {
      debugPrint(
        '[NotificationNavigationHelper] No navigation callback registered',
      );
    }
  }
}
