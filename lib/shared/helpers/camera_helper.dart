import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraHelper {
  static Future<bool> requestCameraPermissions() async {
    // Request camera permission
    final cameraPermission = await Permission.camera.request();

    // Request microphone permission for video recording
    final microphonePermission = await Permission.microphone.request();

    return cameraPermission.isGranted && microphonePermission.isGranted;
  }

  static Future<List<CameraDescription>> getAvailableCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      print('Error getting available cameras: $e');
      return [];
    }
  }
}
