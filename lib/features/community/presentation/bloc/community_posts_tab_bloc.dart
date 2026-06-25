import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_community_posts_usecase.dart';
import 'dart:async';

part 'community_posts_tab_event.dart';
part 'community_posts_tab_state.dart';

class CommunityPostsTabBloc
    extends Bloc<CommunityPostsTabEvent, CommunityPostsTabState> {
  final GetUserCommunityPostsUseCase _getUserCommunityPostsUseCase;
  final CommentRepository _commentRepository;
  late StreamSubscription _commentCountSubscription;

  late Map<String, int> commentCounts = {};
  String currentStatus = 'all';
  int currentPage = 1;
  List<PostEntity> currentPosts = [];

  CommunityPostsTabBloc({
    required GetUserCommunityPostsUseCase getUserCommunityPostsUseCase,
    required CommentRepository commentRepository,
  })  : _getUserCommunityPostsUseCase = getUserCommunityPostsUseCase,
        _commentRepository = commentRepository,
        super(CommunityPostsTabInitial()) {
    on<CommunityPostsTabFetched>(_onFetched);
    on<CommunityPostsTabPageChanged>(_onPageChanged);
    on<CommunityPostsTabStatusChanged>(_onStatusChanged);

    on<CommunityPostsTabCommentCountsUpdated>(_onCommentCountsUpdated);

    // Listen to comment count updates
    _commentCountSubscription = _commentRepository.commentCountStream.listen((
      counts,
    ) {
      if (!isClosed) {
        add(CommunityPostsTabCommentCountsUpdated(counts));
      }
    });
  }

  Future<void> _onFetched(
    CommunityPostsTabFetched event,
    Emitter<CommunityPostsTabState> emit,
  ) async {
    emit(CommunityPostsTabLoading());
    currentStatus = event.status;
    currentPage = 1;

    try {
      final dataState = await _getUserCommunityPostsUseCase(
        params: GetUserCommunityPostsParams(
          page: currentPage,
          limit: 10,
          status: event.status,
        ),
      );

      if (dataState is DataStateSuccess) {
        currentPosts = dataState.data!.data;

        // Join post rooms and load comment counts
        for (var post in currentPosts) {
          _commentRepository.joinPost(post.id);
          _commentRepository.loadComments(post.id);
        }

        emit(
          CommunityPostsTabLoaded(
            posts: currentPosts,
            page: dataState.data!.page ?? 1,
            limit: dataState.data!.limit ?? 10,
            total: dataState.data!.total ?? 0,
            hasNext: dataState.data!.hasNext ?? false,
            status: event.status,
            commentCounts: commentCounts,
          ),
        );
      } else {
        emit(
          CommunityPostsTabError(
            message: dataState.error?.message ?? 'Failed to load posts',
          ),
        );
      }
    } catch (e) {
      emit(CommunityPostsTabError(message: e.toString()));
    }
  }

  Future<void> _onPageChanged(
    CommunityPostsTabPageChanged event,
    Emitter<CommunityPostsTabState> emit,
  ) async {
    currentPage = event.page;
    await _onFetched(CommunityPostsTabFetched(status: event.status), emit);
  }

  Future<void> _onStatusChanged(
    CommunityPostsTabStatusChanged event,
    Emitter<CommunityPostsTabState> emit,
  ) async {
    currentStatus = event.status;
    await _onFetched(CommunityPostsTabFetched(status: event.status), emit);
  }

  void _onCommentCountsUpdated(
    CommunityPostsTabCommentCountsUpdated event,
    Emitter<CommunityPostsTabState> emit,
  ) {
    commentCounts = event.counts;
    if (state is CommunityPostsTabLoaded) {
      final currentState = state as CommunityPostsTabLoaded;
      emit(
        CommunityPostsTabLoaded(
          posts: currentState.posts,
          page: currentState.page,
          limit: currentState.limit,
          total: currentState.total,
          hasNext: currentState.hasNext,
          status: currentState.status,
          commentCounts: commentCounts,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    // Cancel comment count subscription
    _commentCountSubscription.cancel();
    // Leave all post rooms
    for (var post in currentPosts) {
      _commentRepository.leavePost(post.id);
    }
    return super.close();
  }
}
