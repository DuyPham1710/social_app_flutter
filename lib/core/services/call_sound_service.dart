import 'package:audioplayers/audioplayers.dart';

/// Service to manage call sounds (ringtone and incoming call)
class CallSoundService {
  static final CallSoundService _instance = CallSoundService._internal();
  factory CallSoundService() => _instance;
  CallSoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  /// Play ringtone for caller (loop until stopped)
  Future<void> playRingtone() async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/ringtone_call.mp3'));
    } catch (e) {
      print('[CallSoundService] Error playing ringtone: $e');
      _isPlaying = false;
    }
  }

  /// Play incoming call sound for receiver (loop until stopped)
  Future<void> playIncomingCall() async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/incoming_call.mp3'));
    } catch (e) {
      print('[CallSoundService] Error playing incoming call: $e');
      _isPlaying = false;
    }
  }

  /// Stop any playing sound
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      print('[CallSoundService] Error stopping sound: $e');
    }
  }

  /// Dispose audio player
  Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
      _isPlaying = false;
    } catch (e) {
      print('[CallSoundService] Error disposing audio player: $e');
    }
  }

  /// Check if sound is currently playing
  bool get isPlaying => _isPlaying;
}

