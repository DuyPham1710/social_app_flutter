import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/grouped_story_list_entity.dart';
import '../../domain/usecases/get_home_stories_usecase.dart';

part 'home_stories_event.dart';
part 'home_stories_state.dart';

class HomeStoriesBloc extends Bloc<HomeStoriesEvent, HomeStoriesState> {
  final GetHomeStoriesUsecase getHomeStoriesUseCase;

  HomeStoriesBloc({required this.getHomeStoriesUseCase})
    : super(HomeStoriesInitial()) {
    on<LoadHomeStoriesEvent>(_onLoadHomeStories);
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
}
