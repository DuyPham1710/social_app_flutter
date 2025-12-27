import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:social_app_fe/core/services/fcm_service.dart';

/// Service to handle Firebase Cloud Messaging for app notifications
/// (not chat messages - those are handled by FcmService)
class NotificationFcmService {
  static final NotificationFcmService _instance =
      NotificationFcmService._internal();
  factory NotificationFcmService() => _instance;
  NotificationFcmService._internal();

  // Track if user is currently on notification page
  static bool _isOnNotificationPage = false;

  static void setOnNotificationPage(bool isOn) {
    _isOnNotificationPage = isOn;
    debugPrint('[NotificationFCM] User on notification page: $isOn');
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  RemoteMessage? _pendingInitialMessage;

  /// Initialize notification FCM service
  Future<void> initialize() async {
    try {
      debugPrint('[NotificationFCM] Initializing...');

      // Set foreground notification presentation options (iOS)
      // This prevents automatic notification display, we handle it manually
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: false, // Don't show alert
        badge: false, // Don't update badge
        sound: false, // Don't play sound
      );

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _createNotificationChannel();
      }

      // Listen to foreground messages for app notifications
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle when user taps notification (app in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from terminated state
      _pendingInitialMessage = await _firebaseMessaging.getInitialMessage();
      if (_pendingInitialMessage != null) {
        debugPrint(
          '[NotificationFCM] App opened from terminated state with notification',
        );
        debugPrint(
          '[NotificationFCM] Will handle navigation after callback is registered',
        );
      }

      debugPrint('[NotificationFCM] Service initialized successfully');
    } catch (e) {
      debugPrint('[NotificationFCM] Error initializing: $e');
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
    debugPrint(
      '[NotificationFCM] Local notification tapped: ${response.payload}',
    );

    if (response.payload != null && response.payload!.isNotEmpty) {
      // Check if this is a chat message notification
      final parts = response.payload!.split('|');
      if (parts.isNotEmpty && parts[0] == 'new_message') {
        FcmService().onLocalNotificationTap(response);
      } else {
        // Handle app notifications
        handleNotificationTap(response.payload!);
      }
    }
  }

  /// Public method to handle notification tap (can be called from FcmService)
  void handleNotificationTap(String payload) {
    final parts = payload.split('|');
    if (parts.isNotEmpty) {
      final type = parts[0];
      final targetId = parts.length >= 2 ? parts[1] : null;
      final senderId = parts.length >= 3 ? parts[2] : null;
      final notificationId = parts.length >= 4 ? parts[3] : null;

      if (_isAppNotificationType(type)) {
        _navigateBasedOnType(
          type,
          targetId: targetId,
          senderId: senderId,
          notificationId: notificationId,
        );
      }
    }
  }

  /// Handle foreground messages (app is open)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('[NotificationFCM] Foreground message: ${message.messageId}');
    debugPrint('[NotificationFCM] Data: ${message.data}');

    final messageType = message.data['type'];

    // Only handle app notification types (not chat or call)
    if (_isAppNotificationType(messageType)) {
      // Don't show notification if user is already on notification page
      if (_isOnNotificationPage) {
        debugPrint(
          '[NotificationFCM] User is on notification page, skipping notification',
        );
        return;
      }

      debugPrint(
        '[NotificationFCM] Showing local notification for: $messageType',
      );
      await _showLocalNotification(message);
    }
  }

  /// Handle when user taps notification
  Future<void> _handleNotificationTap(RemoteMessage message) async {
    debugPrint('[NotificationFCM] Notification tapped: ${message.messageId}');
    debugPrint('[NotificationFCM] Data: ${message.data}');

    final messageType = message.data['type'];
    final targetId = message.data['targetId'];
    final senderId = message.data['senderId'];
    final notificationId = message.data['notificationId'];

    if (_isAppNotificationType(messageType)) {
      await _navigateBasedOnType(
        messageType,
        targetId: targetId,
        senderId: senderId,
        notificationId: notificationId,
      );
    }
  }

  /// Check if message type is an app notification (not chat/call)
  bool _isAppNotificationType(String? type) {
    if (type == null) return false;

    return type == 'FRIEND_REQUEST' ||
        type == 'POST_COMMENT' ||
        type == 'POST_REACTION' ||
        type == 'MENTION' ||
        type == 'STORY_REACTION' ||
        type == 'COMMENT_REACTION';
  }

  /// Parse mention format @[Name](userId) to plain text @Name
  String _parseMentions(String text) {
    debugPrint('[NotificationFCM] Parsing mentions - Original: $text');
    final RegExp mentionRegex = RegExp(r'@\[([^\]]+)\]\(([^)]+)\)');
    final parsed = text.replaceAllMapped(mentionRegex, (match) {
      final name = match.group(1) ?? '';
      debugPrint(
        '[NotificationFCM] Found mention: ${match.group(0)} -> @$name',
      );
      return '@$name';
    });
    debugPrint('[NotificationFCM] Parsing mentions - Result: $parsed');
    return parsed;
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'app_notifications', // id (different from chat_messages)
      'App Notifications', // name
      description: 'Notification channel for app notifications',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        'notification_sound',
      ), // Custom sound
      enableVibration: true,
      showBadge: true,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);

    debugPrint('[NotificationFCM] Notification channel created');
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final type = message.data['type'] ?? '';
      final senderName = message.data['senderName'] ?? 'Someone';
      final rawMessage = message.data['message'] ?? 'New notification';
      final notificationMessage = _parseMentions(rawMessage); // Parse mentions
      final targetId = message.data['targetId'] ?? '';
      final senderId = message.data['senderId'] ?? '';
      final senderAvatar = message.data['senderAvatar'] ?? '';
      final notificationId = message.data['notificationId'] ?? '';

      // Download avatar image for large icon
      Uint8List? avatarBytes;
      ByteArrayAndroidBitmap? largeBitmap;

      if (senderAvatar.isNotEmpty) {
        try {
          final http.Response response = await http.get(
            Uri.parse(senderAvatar),
          );
          if (response.statusCode == 200) {
            avatarBytes = response.bodyBytes;
            largeBitmap = ByteArrayAndroidBitmap(avatarBytes);
          }
        } catch (e) {
          debugPrint('[NotificationFCM] Error loading avatar: $e');
        }
      }

      // Get appropriate icon and title based on type
      final notificationInfo = _getNotificationInfo(type);

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'app_notifications',
            'App Notifications',
            channelDescription: 'Notification channel for app notifications',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            largeIcon: largeBitmap,
            icon: notificationInfo['icon'],
            styleInformation: BigTextStyleInformation(
              notificationMessage,
              contentTitle: senderName,
              summaryText: notificationInfo['title'],
            ),
          );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      final localNotificationId = notificationId.hashCode;

      await _localNotifications.show(
        localNotificationId,
        senderName,
        notificationMessage,
        notificationDetails,
        payload: '$type|$targetId|$senderId|$notificationId',
      );

      debugPrint('[NotificationFCM] Local notification shown for type: $type');
    } catch (e) {
      debugPrint('[NotificationFCM] Error showing local notification: $e');
    }
  }

  /// Get notification icon and title based on type
  Map<String, String> _getNotificationInfo(String type) {
    switch (type) {
      case 'FRIEND_REQUEST':
        return {'icon': '@mipmap/ic_launcher', 'title': 'Friend Request'};
      case 'POST_COMMENT':
        return {'icon': '@mipmap/ic_launcher', 'title': 'New Comment'};
      case 'POST_REACTION':
        return {'icon': '@mipmap/ic_launcher', 'title': 'Post Reaction'};
      case 'MENTION':
        return {'icon': '@mipmap/ic_launcher', 'title': 'Mentioned You'};
      case 'STORY_REACTION':
        return {'icon': '@mipmap/ic_launcher', 'title': 'Story Reaction'};
      case 'COMMENT_REACTION':
        return {'icon': '@mipmap/ic_launcher', 'title': 'Comment Reaction'};
      default:
        return {'icon': '@mipmap/ic_launcher', 'title': 'Notification'};
    }
  }

  /// Handle pending initial message
  Future<void> handlePendingNavigation() async {
    if (_pendingInitialMessage != null) {
      final messageType = _pendingInitialMessage!.data['type'];

      // Only handle app notification types
      if (_isAppNotificationType(messageType)) {
        debugPrint(
          '[NotificationFCM] Handling pending initial message: $messageType',
        );
        await _handleNotificationTap(_pendingInitialMessage!);
      } else {
        debugPrint(
          '[NotificationFCM] Pending message is not app notification type: $messageType, skipping',
        );
      }
      _pendingInitialMessage = null;
    }
  }

  /// Navigate based on notification type
  Future<void> _navigateBasedOnType(
    String type, {
    String? targetId,
    String? senderId,
    String? notificationId,
  }) async {
    try {
      debugPrint(
        '[NotificationFCM] Navigating for type: $type, targetId: $targetId',
      );

      await AppNotificationNavigationHelper.navigateBasedOnType(
        type,
        targetId: targetId,
        senderId: senderId,
        notificationId: notificationId,
      );
    } catch (e) {
      debugPrint('[NotificationFCM] Error navigating: $e');
    }
  }
}

/// Helper class for navigation from app notifications
class AppNotificationNavigationHelper {
  static Function(
    String type, {
    String? targetId,
    String? senderId,
    String? notificationId,
  })?
  _navigateCallback;

  /// Register navigation callback
  static void registerNavigationCallback(
    Function(
      String type, {
      String? targetId,
      String? senderId,
      String? notificationId,
    })
    callback,
  ) {
    _navigateCallback = callback;
    debugPrint(
      '[AppNotificationNavigationHelper] Navigation callback registered',
    );
  }

  /// Navigate based on notification type
  static Future<void> navigateBasedOnType(
    String type, {
    String? targetId,
    String? senderId,
    String? notificationId,
  }) async {
    if (_navigateCallback != null) {
      _navigateCallback!(
        type,
        targetId: targetId,
        senderId: senderId,
        notificationId: notificationId,
      );
    } else {
      debugPrint(
        '[AppNotificationNavigationHelper] No navigation callback registered',
      );
    }
  }
}
