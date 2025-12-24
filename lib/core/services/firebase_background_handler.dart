import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app_fe/core/services/callkit_service.dart';

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
