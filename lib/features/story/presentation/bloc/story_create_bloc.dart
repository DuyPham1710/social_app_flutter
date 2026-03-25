import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/domain/usecases/create_story_usecase.dart';
import 'story_create_event.dart';
import 'story_create_state.dart';

class StoryCreateBloc extends Bloc<StoryCreateEvent, StoryCreateState> {
  final CreateStoryUsecase _createStoryUsecase;

  StoryCreateBloc(this._createStoryUsecase) : super(StoryCreateInitial()) {
    on<CreateStoryRequested>(_onCreateStoryRequested);
  }

  Future<void> _onCreateStoryRequested(
    CreateStoryRequested event,
    Emitter<StoryCreateState> emit,
  ) async {
    emit(StoryCreating());

    try {
      final dataState = await _createStoryUsecase(params: event.story);

      if (dataState is DataStateSuccess<void>) {
        emit(StoryCreated());
      } else if (dataState is DataStateError) {
        // Lấy message từ response body của BE (ví dụ: BadRequestException)
        final errorMessage = dataState.error?.response?.data?['message']
            ?? dataState.error?.message
            ?? 'Có lỗi xảy ra khi tạo story';
        emit(StoryCreateError(message: errorMessage is List ? errorMessage.join(', ') : errorMessage.toString()));
      } else {
        emit(const StoryCreateError(message: 'Có lỗi không xác định xảy ra'));
      }
    } catch (e) {
      emit(
        StoryCreateError(
          message: 'Có lỗi xảy ra khi tạo story: $e',
        ),
      );
    }
  }
}


