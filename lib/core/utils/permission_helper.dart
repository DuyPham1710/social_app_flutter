import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Helper class for handling app permissions
class PermissionHelper {
  PermissionHelper._();

  /// Check and request call permissions based on call type
  /// Returns true if all required permissions are granted
  static Future<bool> checkCallPermissions(String callType) async {
    if (callType == 'video') {
      // Video call requires both camera and microphone
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (!cameraStatus.isGranted || !micStatus.isGranted) {
        debugPrint('[PermissionHelper] Camera or microphone permission denied');
        return false;
      }
      return true;
    } else {
      // Audio call only requires microphone
      final micStatus = await Permission.microphone.request();

      if (!micStatus.isGranted) {
        debugPrint('[PermissionHelper] Microphone permission denied');
        return false;
      }
      return true;
    }
  }

  /// Show permission denied error with option to open settings
  static void showPermissionDeniedError(
    BuildContext context,
    String callType, {
    VoidCallback? onSettingsTap,
  }) {
    final message = callType == 'video'
        ? 'Cần quyền camera và microphone để thực hiện cuộc gọi video'
        : 'Cần quyền microphone để thực hiện cuộc gọi';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Cài đặt',
          textColor: Colors.white,
          onPressed: () {
            onSettingsTap?.call();
            openAppSettings();
          },
        ),
      ),
    );
  }

  /// Check if permissions are already granted (without requesting)
  static Future<bool> hasCallPermissions(String callType) async {
    if (callType == 'video') {
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;
      return cameraStatus.isGranted && micStatus.isGranted;
    } else {
      final micStatus = await Permission.microphone.status;
      return micStatus.isGranted;
    }
  }

  /// Request specific permission
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check if permission is permanently denied
  static Future<bool> isPermissionPermanentlyDenied(
    Permission permission,
  ) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
}
