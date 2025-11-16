import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_by_userid_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'other_profile_event.dart';
import 'other_profile_state.dart';

class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  final GetOtherUserProfileUseCase getOtherUserProfileUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final GetFriendsByUserIdUseCase getFriendsByUserIdUseCase;
  final GetFriendRelationshipUseCase getFriendRelationshipUseCase;
  final ListenCommentCountUseCase listenCommentCountUseCase;
  final LoadCommentsUseCase loadCommentsUseCase;

  StreamSubscription? _commentCountSubscription;

  OtherProfileBloc({
    required this.getOtherUserProfileUseCase,
    required this.getUserPostsUseCase,
    required this.getFriendRelationshipUseCase,
    required this.getFriendsByUserIdUseCase,
    required this.listenCommentCountUseCase,
    required this.loadCommentsUseCase,
  }) : super(OtherProfileInitial()) {
    on<LoadOtherUserProfileEvent>(_onLoadOtherUserProfile);
    on<LoadOtherProfileFriendsEvent>(_onLoadOtherProfileFriends);
    on<LoadOtherProfilePostsEvent>(_onLoadOtherProfilePosts);
    on<LoadMoreOtherProfilePostsEvent>(_onLoadMoreOtherProfilePosts);
    on<UpdateOtherProfileCommentCountsEvent>(_onUpdateCommentCounts);
    on<ReloadRelationshipEvent>(_onReloadRelationship);

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

    print(">>>>>>>>>>>>>>>>>>>>>RELATIONSHIP: ${relationshipResult.data}");
    print("STATUS: ${relationshipResult.data?.status}");
    if (userResult is DataStateSuccess && userResult.data != null) {
      emit(
        OtherProfileLoaded(
          [],
          user: userResult.data,
          relationship: relationshipResult.data,
        ),
      );

      add(LoadOtherProfileFriendsEvent(event.userId));
      add(LoadOtherProfilePostsEvent(userId: event.userId));
    }
  }

  Future<void> _onLoadOtherProfilePosts(
    LoadOtherProfilePostsEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
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
          user: state.user,
          relationship: state.relationship,
          currentPage: result.data!.page,
          hasNext: result.data!.hasNext,
        ),
      );
    }
  }

  Future<void> _onReloadRelationship(
    ReloadRelationshipEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
    if (state is! OtherProfileLoaded) return;

    final relation = await getFriendRelationshipUseCase(params: event.userId);

    emit((state as OtherProfileLoaded).copyWith(relationship: relation.data));
  }

  Future<void> _onLoadMoreOtherProfilePosts(
    LoadMoreOtherProfilePostsEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
    final current = state;

    if (current is! OtherProfileLoaded ||
        current.hasNext != true ||
        current.isLoadingMore == true)
      return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = (current.currentPage ?? 1) + 1;

    final result = await getUserPostsUseCase(
      params: GetUserPostsParams(
        userId: event.userId,
        page: nextPage,
        limit: 5,
      ),
    );

    if (result is DataStateSuccess) {
      emit(
        current.copyWith(
          posts: [...current.posts!, ...result.data!.data],
          currentPage: result.data!.page,
          hasNext: result.data!.hasNext,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onLoadOtherProfileFriends(
    LoadOtherProfileFriendsEvent event,
    Emitter<OtherProfileState> emit,
  ) async {
    final result = await getFriendsByUserIdUseCase(event.userId);

    if (state is OtherProfileLoaded) {
      final current = state as OtherProfileLoaded;

      if (result is DataStateSuccess) {
        emit(current.copyWith(friends: result.data));
      } else {
        emit(current.copyWith(friends: []));
      }
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
