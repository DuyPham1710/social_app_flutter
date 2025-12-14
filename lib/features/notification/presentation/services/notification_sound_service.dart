import 'package:audioplayers/audioplayers.dart';

class NotificationSoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> play() async {
    try {
      await _player.play(
        AssetSource('sounds/nhac_chuong_thong_bao.mp3'),
        volume: 1.0,
      );
    } catch (_) {
      // ignore sound error
    }
  }
}
