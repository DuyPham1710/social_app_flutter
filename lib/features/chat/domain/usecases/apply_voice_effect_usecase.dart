import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/repository/chat_repository.dart';

class ApplyVoiceEffectUseCase
    implements UseCase<DataState<String>, ApplyVoiceEffectParams> {
  final ChatRepository _chatRepository;

  ApplyVoiceEffectUseCase(this._chatRepository);

  @override
  Future<DataState<String>> call({ApplyVoiceEffectParams? params}) {
    if (params == null) {
      throw ArgumentError('ApplyVoiceEffectParams cannot be null');
    }
    return _chatRepository.applyVoiceEffect(
      filePath: params.filePath,
      voicePreset: params.voicePreset,
    );
  }
}

class ApplyVoiceEffectParams {
  final String filePath;
  final String voicePreset;

  ApplyVoiceEffectParams({required this.filePath, required this.voicePreset});
}
