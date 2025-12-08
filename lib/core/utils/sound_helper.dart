import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  /// Play pop sound effect (messenger style)
  static Future<void> playPopSound() async {
    try {
      // Sử dụng âm thanh system hoặc file custom
      await _audioPlayer.play(AssetSource('sounds/sound_react.mp3'));
    } catch (e) {
      // Fallback to haptic feedback if sound fails
      HapticFeedback.mediumImpact();
    }
  }

  /// Play light click sound
  static Future<void> playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      HapticFeedback.lightImpact();
    }
  }

  /// Dispose audio player
  static Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
