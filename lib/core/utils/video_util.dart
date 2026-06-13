import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class VideoUtil {
  static bool isVideo(dynamic imageData) {
    if (imageData is AssetEntity) {
      return imageData.type == AssetType.video;
    } else if (imageData is File) {
      final extension = imageData.path.split('.').last.toLowerCase();
      return ['mp4', 'mov', 'avi', 'mkv', 'm4v', '3gp'].contains(extension);
    } else if (imageData is String) {
      final extension = imageData.split('.').last.toLowerCase();
      return ['mp4', 'mov', 'avi', 'mkv', 'm4v', '3gp'].contains(extension);
    } else if (imageData.runtimeType.toString() == 'PlatformFile') {
      try {
        final extension = imageData.extension?.toLowerCase();
        return ['mp4', 'mov', 'avi', 'mkv', 'm4v', '3gp'].contains(extension);
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
