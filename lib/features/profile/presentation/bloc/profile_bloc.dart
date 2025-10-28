import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_profile_posts_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfilePostsUseCase getProfilePostsUseCase;

  ProfileBloc({required this.getProfilePostsUseCase}) : super(ProfileInitial()) {
    on<LoadProfilePostsEvent>(_onLoadProfilePosts);
    on<LoadMoreProfilePostsEvent>(_onLoadMoreProfilePosts);
  }

  Future<void> _onLoadProfilePosts(
    LoadProfilePostsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final dataState = await getProfilePostsUseCase(
      params: GetProfilePostsParams(
        ownerId: event.ownerId,
        page: event.page,
        limit: event.limit,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      final postListEntity = dataState.data!;
      emit(ProfileLoaded(
        postListEntity.data,
        currentPage: postListEntity.page,
        limit: postListEntity.limit,
        hasNext: postListEntity.hasNext,
      ));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(ProfileError(dataState.error!, errorMessage: errorMessage));
    }
  }

  Future<void> _onLoadMoreProfilePosts(
    LoadMoreProfilePostsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProfileLoaded ||
        currentState.hasNext != true ||
        currentState.isLoadingMore) {
      return;
    }

    emit(ProfileLoaded(
      currentState.posts!,
      currentPage: currentState.currentPage,
      limit: currentState.limit,
      hasNext: currentState.hasNext,
      isLoadingMore: true,
    ));

    final nextPage = (currentState.currentPage ?? 1) + 1;
    final dataState = await getProfilePostsUseCase(
      params: GetProfilePostsParams(
        ownerId: event.ownerId,
        page: nextPage,
        limit: currentState.limit ?? 10,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      final postListEntity = dataState.data!;
      final updatedPosts = [...currentState.posts!, ...postListEntity.data];

      emit(ProfileLoaded(
        updatedPosts,
        currentPage: postListEntity.page,
        limit: postListEntity.limit,
        hasNext: postListEntity.hasNext,
        isLoadingMore: false,
      ));
    } else {
      emit(ProfileLoaded(
        currentState.posts!,
        currentPage: currentState.currentPage,
        limit: currentState.limit,
        hasNext: currentState.hasNext,
        isLoadingMore: false,
      ));
    }
  }
}
