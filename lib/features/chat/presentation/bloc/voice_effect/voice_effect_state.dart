import 'package:equatable/equatable.dart';

abstract class VoiceEffectState extends Equatable {
  const VoiceEffectState();

  @override
  List<Object?> get props => [];
}

class VoiceEffectInitial extends VoiceEffectState {
  const VoiceEffectInitial();
}

class VoiceEffectLoading extends VoiceEffectState {
  const VoiceEffectLoading();
}

class VoiceEffectSuccess extends VoiceEffectState {
  final String newFilePath;

  const VoiceEffectSuccess(this.newFilePath);

  @override
  List<Object?> get props => [newFilePath];
}

class VoiceEffectError extends VoiceEffectState {
  final String message;

  const VoiceEffectError(this.message);

  @override
  List<Object?> get props => [message];
}
