import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/usecases/apply_voice_effect_usecase.dart';

import 'voice_effect_event.dart';
import 'voice_effect_state.dart';

class VoiceEffectBloc extends Bloc<VoiceEffectEvent, VoiceEffectState> {
  final ApplyVoiceEffectUseCase _applyVoiceEffectUseCase;

  VoiceEffectBloc(this._applyVoiceEffectUseCase)
    : super(const VoiceEffectInitial()) {
    on<ApplyVoiceEffectEvent>(_onApplyVoiceEffect);
  }

  Future<void> _onApplyVoiceEffect(
    ApplyVoiceEffectEvent event,
    Emitter<VoiceEffectState> emit,
  ) async {
    emit(const VoiceEffectLoading());

    try {
      final dataState = await _applyVoiceEffectUseCase(
        params: ApplyVoiceEffectParams(
          filePath: event.filePath,
          voicePreset: event.voicePreset,
        ),
      );

      if (dataState is DataStateSuccess && dataState.data != null) {
        emit(VoiceEffectSuccess(dataState.data!));
      } else if (dataState is DataStateError) {
        emit(
          VoiceEffectError(
            dataState.error?.message?.replaceAll('Exception: ', '') ??
                'Không thể chuyển giọng. Vui lòng thử lại.',
          ),
        );
      }
    } catch (e) {
      emit(VoiceEffectError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
