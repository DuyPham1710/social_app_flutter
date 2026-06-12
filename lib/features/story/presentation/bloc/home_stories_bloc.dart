import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/grouped_story_list_entity.dart';
import '../../domain/usecases/get_home_stories_usecase.dart';
import '../../domain/usecases/react_story_usecase.dart';

part 'home_stories_event.dart';
part 'home_stories_state.dart';

class HomeStoriesBloc extends Bloc<HomeStoriesEvent, HomeStoriesState> {
  final GetHomeStoriesUsecase getHomeStoriesUseCase;
  final CreateOrUpdateReactStoryUsecase createOrUpdateReactStoryUsecase;
  final GetStoryReactsUsecase getStoryReactsUsecase;
  final CheckUserReactStoryUsecase checkUserReactStoryUsecase;
  final UpdateReactStoryUsecase updateReactStoryUsecase;
  final DeleteReactStoryUsecase deleteReactStoryUsecase;

  HomeStoriesBloc({
    required this.getHomeStoriesUseCase,
    required this.createOrUpdateReactStoryUsecase,
    required this.getStoryReactsUsecase,
    required this.checkUserReactStoryUsecase,
    required this.updateReactStoryUsecase,
    required this.deleteReactStoryUsecase,
  }) : super(HomeStoriesInitial()) {
    on<LoadHomeStoriesEvent>(_onLoadHomeStories);
    on<ReactStoryEvent>(_onReactStory);
    on<GetStoryReactsEvent>(_onGetStoryReacts);
    on<CheckUserReactStoryEvent>(_onCheckUserReactStory);
    on<UpdateReactStoryEvent>(_onUpdateReactStory);
    on<DeleteReactStoryEvent>(_onDeleteReactStory);
  }

  Future<void> _onLoadHomeStories(
    LoadHomeStoriesEvent event,
    Emitter<HomeStoriesState> emit,
  ) async {
    emit(HomeStoriesLoading());
    final dataState = await getHomeStoriesUseCase(
      params: GetHomeStoriesParams(page: event.page, limit: event.limit),
    );
    if (dataState.data != null) {
      emit(HomeStoriesLoaded(dataState.data!));
    } else {
      emit(HomeStoriesError("Không thể tải stories"));
    }
  }

  Future<void> _onReactStory(
    ReactStoryEvent event,
    Emitter<HomeStoriesState> emit,
  ) async {
    final dataState = await createOrUpdateReactStoryUsecase(
      params: ReactStoryParams(storyId: event.storyId, emojiId: event.emojiId),
    );
    // dataState.data có thể null khi xóa react (toggle off), nhưng vẫn là thành công
    // Kiểm tra error để biết có lỗi không
    if (dataState.error == null) {
      emit(ReactStorySuccess(event.storyId));
      // Reload stories để cập nhật react count
      add(const LoadHomeStoriesEvent(page: 1, limit: 10));
    } else {
      emit(HomeStoriesError("Không thể react story"));
    }
  }

  Future<void> _onGetStoryReacts(
    GetStoryReactsEvent event,
    Emitter<HomeStoriesState> emit,
  ) async {
    final dataState = await getStoryReactsUsecase(
      params: GetStoryReactsParams(storyId: event.storyId),
    );
    if (dataState.data != null) {
      emit(StoryReactsLoaded(storyId: event.storyId, reacts: dataState.data!));
    } else {
      emit(HomeStoriesError("Không thể tải reacts của story"));
    }
  }

  Future<void> _onCheckUserReactStory(
    CheckUserReactStoryEvent event,
    Emitter<HomeStoriesState> emit,
  ) async {
    final dataState = await checkUserReactStoryUsecase(
      params: CheckUserReactStoryParams(storyId: event.storyId),
    );
    if (dataState.data != null) {
      emit(
        UserReactStoryChecked(
          storyId: event.storyId,
          userReact: dataState.data,
        ),
      );
    } else {
      emit(HomeStoriesError("Không thể kiểm tra react của user"));
    }
  }

  Future<void> _onUpdateReactStory(
    UpdateReactStoryEvent event,
    Emitter<HomeStoriesState> emit,
  ) async {
    final dataState = await updateReactStoryUsecase(
      params: ReactStoryParams(storyId: event.storyId, emojiId: event.emojiId),
    );
    if (dataState.data != null) {
      emit(ReactStorySuccess(event.storyId));
      // Reload stories để cập nhật react
      add(const LoadHomeStoriesEvent(page: 1, limit: 10));
    } else {
      emit(HomeStoriesError("Không thể cập nhật react"));
    }
  }

  Future<void> _onDeleteReactStory(
    DeleteReactStoryEvent event,
    Emitter<HomeStoriesState> emit,
  ) async {
    final dataState = await deleteReactStoryUsecase(
      params: DeleteReactStoryParams(storyId: event.storyId),
    );
    if (dataState.error == null) {
      emit(ReactStorySuccess(event.storyId));
      // Reload stories để cập nhật react count
      add(const LoadHomeStoriesEvent(page: 1, limit: 10));
    } else {
      emit(HomeStoriesError("Không thể xóa react"));
    }
  }
}
