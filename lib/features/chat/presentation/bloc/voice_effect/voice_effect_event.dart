import 'package:equatable/equatable.dart';

abstract class VoiceEffectEvent extends Equatable {
  const VoiceEffectEvent();

  @override
  List<Object?> get props => [];
}

class ApplyVoiceEffectEvent extends VoiceEffectEvent {
  final String filePath;
  final String voicePreset;

  const ApplyVoiceEffectEvent({
    required this.filePath,
    required this.voicePreset,
  });

  @override
  List<Object?> get props => [filePath, voicePreset];
}
