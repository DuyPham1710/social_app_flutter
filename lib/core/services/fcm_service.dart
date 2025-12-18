import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/services/callkit_service.dart';
import 'package:social_app_fe/core/network/dio_client.dart';

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

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    try {
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
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      debugPrint('[FCM] Service initialized successfully');
    } catch (e) {
      debugPrint('[FCM] Error initializing: $e');
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
      // Dismiss call UI
      await _callKitService.endAllCalls();
    }
  }

  /// Handle when user taps notification
  Future<void> _handleNotificationTap(RemoteMessage message) async {
    debugPrint('[FCM] Notification tapped: ${message.messageId}');
    debugPrint('[FCM] Data: ${message.data}');

    // Navigate to appropriate screen based on data
    // This will be handled by CallKitService
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

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'incoming_call', // id (must match AndroidManifest.xml)
      'Incoming Call', // name
      description: 'Notification channel for incoming calls',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    debugPrint('[FCM] Notification channel created: ${channel.id}');
  }
}
