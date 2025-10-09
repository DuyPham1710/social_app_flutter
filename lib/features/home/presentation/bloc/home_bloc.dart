import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_home_posts_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomePostsUseCase getHomePostsUseCase;

  HomeBloc({required this.getHomePostsUseCase}) : super(HomeInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final dataState = await getHomePostsUseCase(
      params: GetHomePostsParams(page: event.page, limit: event.limit),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(HomeLoaded(dataState.data!));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(HomeError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }
}
