import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_app_fe/core/services/callkit_service.dart';
import 'package:http/http.dart' as http;
import 'package:social_app_fe/core/helpers/notification_helper.dart';

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

/// Top-level function for Firebase background message handler
/// MUST be top-level function, not a class method
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();

  debugPrint('[FCM Background] Message received: ${message.messageId}');
  debugPrint('[FCM Background] Data: ${message.data}');
  debugPrint('[FCM Background] Notification: ${message.notification?.title}');

  // Handle incoming call
  if (message.data['type'] == 'incoming_call') {
    await _handleBackgroundIncomingCall(message.data);
  }
  // Handle call ended
  else if (message.data['type'] == 'call_ended') {
    await _handleBackgroundCallEnded(message.data);
  }
  // Handle new message
  else if (message.data['type'] == 'new_message') {
    await _handleBackgroundNewMessage(message.data);
  }
  // Handle app notifications (POST_COMMENT, FRIEND_REQUEST, etc.)
  else if (_isAppNotificationType(message.data['type'])) {
    await _handleBackgroundAppNotification(message);
  }
}

/// Check if message type is an app notification
bool _isAppNotificationType(String? type) {
  if (type == null) return false;
  return type == 'FRIEND_REQUEST' ||
      type == 'FRIEND_ACCEPT' ||
      type == 'NEW_POST' ||
      type == 'POST_COMMENT' ||
      type == 'POST_REACTION' ||
      type == 'MENTION' ||
      type == 'STORY_REACTION' ||
      type == 'COMMENT_REACTION' ||
      type == 'POST_REPORT_REVIEWED' ||
      type == 'TAG_POST' ||
      type == 'FACE_DETECTED' ||
      type == 'FACE_TAG_SUGGEST' ||
      type == 'COMMUNITY_PUBLIC_JOIN' ||
      type == 'COMMUNITY_JOIN_REQUEST' ||
      type == 'COMMUNITY_INVITE' ||
      type == 'COMMUNITY_JOIN_APPROVED' ||
      type == 'COMMUNITY_JOIN_REJECTED' ||
      type == 'COMMUNITY_POST_APPROVED' ||
      type == 'COMMUNITY_POST_REJECTED' ||
      type == 'COMMUNITY_POST_PENDING';
}

/// Parse mention format @[Name](userId) to plain text @Name
String _parseMentions(String text) {
  final RegExp mentionRegex = RegExp(r'@\[([^\]]+)\]\(([^)]+)\)');
  return text.replaceAllMapped(mentionRegex, (match) {
    final name = match.group(1) ?? '';
    return '@$name';
  });
}

/// Handle incoming call in background/terminated state
Future<void> _handleBackgroundIncomingCall(Map<String, dynamic> data) async {
  try {
    debugPrint('[FCM Background] Handling incoming call: ${data['callId']}');

    // Show native call UI using CallKit
    final callKitService = CallKitService();
    await callKitService.showIncomingCall(data);

    debugPrint('[FCM Background] Native call UI shown');
  } catch (e) {
    debugPrint('[FCM Background] Error handling incoming call: $e');
  }
}

/// Handle call ended in background/terminated state
Future<void> _handleBackgroundCallEnded(Map<String, dynamic> data) async {
  try {
    debugPrint('[FCM Background] Handling call ended: ${data['callId']}');

    // Dismiss native call UI
    final callKitService = CallKitService();

    final callId = data['callId'] as String?;
    if (callId != null && callId.isNotEmpty) {
      await callKitService.endCall(callId);
      debugPrint('[FCM Background] CallKit UI dismissed for call: $callId');
    } else {
      await callKitService.endAllCalls();
      debugPrint('[FCM Background] All CallKit UIs dismissed');
    }
  } catch (e) {
    debugPrint('[FCM Background] Error handling call ended: $e');
  }
}

/// Handle new message in background/terminated state
Future<void> _handleBackgroundNewMessage(Map<String, dynamic> data) async {
  try {
    debugPrint('[FCM Background] Handling new message: ${data['messageId']}');
    debugPrint('[FCM Background] Conversation: ${data['conversationId']}');

    // The notification will be automatically shown by FCM
    // When user taps it, the app will open and handle navigation in FCM service
  } catch (e) {
    debugPrint('[FCM Background] Error handling new message: $e');
  }
}

/// Handle app notification in background/terminated state
Future<void> _handleBackgroundAppNotification(RemoteMessage message) async {
  try {
    final type = message.data['type'] ?? '';
    final senderName = message.data['senderName'] ?? 'Someone';
    final rawMessage = message.data['message'] ?? 'New notification';
    final content = message.data['content'] ?? '';
    final targetId = message.data['targetId'] ?? '';
    final senderId = message.data['senderId'] ?? '';
    final senderAvatar = message.data['senderAvatar'] ?? '';
    final notificationId = message.data['notificationId'] ?? '';
    final l10n = await NotificationHelper.getAppLocalizations();
    final notificationMessage = NotificationHelper.buildNotificationMessage(
      type,
      senderName,
      rawMessage,
      content,
      l10n,
    );

    debugPrint('[FCM Background] Handling app notification: $type');
    debugPrint('[FCM Background] Original message: $rawMessage');
    debugPrint('[FCM Background] Parsed message: $notificationMessage');

    // Download avatar image for large icon
    Uint8List? avatarBytes;
    ByteArrayAndroidBitmap? largeBitmap;

    if (senderAvatar.isNotEmpty) {
      try {
        final http.Response response = await http.get(Uri.parse(senderAvatar));
        if (response.statusCode == 200) {
          avatarBytes = response.bodyBytes;
          largeBitmap = ByteArrayAndroidBitmap(avatarBytes);
        }
      } catch (e) {
        debugPrint('[FCM Background] Error loading avatar: $e');
      }
    }

    // Get appropriate icon and title based on type using l10n
    final notificationInfo = NotificationHelper.getNotificationInfo(type, l10n);

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

    debugPrint('[FCM Background] Local notification shown for type: $type');
  } catch (e) {
    debugPrint('[FCM Background] Error handling app notification: $e');
  }
}

