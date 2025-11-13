import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'other_profile_event.dart';
import 'other_profile_state.dart';

class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  final GetOtherUserProfileUseCase getOtherUserProfileUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final GetFriendRelationshipUseCase getFriendRelationshipUseCase;
  final ListenCommentCountUseCase listenCommentCountUseCase;
  final LoadCommentsUseCase loadCommentsUseCase;

  StreamSubscription? _commentCountSubscription;

  OtherProfileBloc({
    required this.getOtherUserProfileUseCase,
    required this.getUserPostsUseCase,
    required this.getFriendRelationshipUseCase,
    required this.listenCommentCountUseCase,
    required this.loadCommentsUseCase,
  }) : super(OtherProfileInitial()) {
    on<LoadOtherUserProfileEvent>(_onLoadOtherUserProfile);
    on<LoadOtherProfilePostsEvent>(_onLoadOtherProfilePosts);
    on<LoadMoreOtherProfilePostsEvent>(_onLoadMoreOtherProfilePosts);
    on<UpdateOtherProfileCommentCountsEvent>(_onUpdateCommentCounts);

    _commentCountSubscription =
        listenCommentCountUseCase(params: const NoParams()).listen((counts) {
          add(UpdateOtherProfileCommentCountsEvent(counts));
        });
  }

  Future<void> _onLoadOtherUserProfile(
    LoadOtherUserProfileEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
    emit(OtherProfileLoading());

    final userResult = await getOtherUserProfileUseCase(params: event.userId);

    final relationshipResult = await getFriendRelationshipUseCase(
      params: event.userId,
    );

    if (userResult is DataStateSuccess && userResult.data != null) {
      emit(
        OtherProfileLoaded(
          [],
          user: userResult.data,
          relationship: relationshipResult.data,
        ),
      );

      add(LoadOtherProfilePostsEvent(userId: event.userId));
    }
    //else {
    //   emit(OtherProfileError(
    //       ErrorUtils.getErrorMessage(userResult.error ?? Exception('Lỗi'))));
    // }
  }

  Future<void> _onLoadOtherProfilePosts(
    LoadOtherProfilePostsEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
    final current = state;

    final result = await getUserPostsUseCase(
      params: GetUserPostsParams(
        userId: event.userId,
        page: event.page,
        limit: 5,
      ),
    );

    if (result is DataStateSuccess && result.data != null) {
      final posts = result.data!.data;
      for (final post in posts) {
        loadCommentsUseCase(params: LoadCommentsParams(post.id));
      }

      emit(
        OtherProfileLoaded(
          posts,
          user: current.user,
          relationship: (current is OtherProfileLoaded)
              ? current.relationship
              : null,
        ),
      );
    } else {
      emit(OtherProfileError(ErrorUtils.getErrorMessage(result.error!)));
    }
  }

  Future<void> _onLoadMoreOtherProfilePosts(
    LoadMoreOtherProfilePostsEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
    final current = state;
    if (current is! OtherProfileLoaded || current.hasNext != true) return;

    final nextPage = (current.currentPage ?? 1) + 1;

    final result = await getUserPostsUseCase(
      params: GetUserPostsParams(
        userId: event.userId,
        page: nextPage,
        limit: 5,
      ),
    );

    if (result is DataStateSuccess && result.data != null) {
      emit(
        current.copyWith(
          posts: [...current.posts!, ...result.data!.data],
          currentPage: result.data!.page,
          hasNext: result.data!.hasNext,
        ),
      );
    }
  }

  void _onUpdateCommentCounts(
    UpdateOtherProfileCommentCountsEvent event,
    Emitter<OtherProfileState> emit,
  ) {
    final current = state;
    if (current is OtherProfileLoaded) {
      emit(current.copyWith(commentCounts: event.commentCounts));
    }
  }

  @override
  Future<void> close() {
    _commentCountSubscription?.cancel();
    return super.close();
  }
}
