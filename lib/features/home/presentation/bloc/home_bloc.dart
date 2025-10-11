import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/websocket/comment_socket_service.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_home_posts_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomePostsUseCase getHomePostsUseCase;
  final CommentSocketService commentSocketService;
  StreamSubscription? _commentCountSubscription;

  HomeBloc({
    required this.getHomePostsUseCase,
    required this.commentSocketService,
  }) : super(HomeInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<UpdateCommentCountsEvent>(_onUpdateCommentCounts);

    // Kết nối WebSocket khi khởi tạo HomeBloc
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    try {
      // Lấy userId từ token storage
      final userData = await TokenStorage.getUserData();
      final userId = userData?['id'];

      if (userId != null) {
        // Kết nối WebSocket
        commentSocketService.connect(userId);

        // Lắng nghe stream comment count updates
        _commentCountSubscription = commentSocketService.commentCountStream
            .listen((commentCounts) {
              add(UpdateCommentCountsEvent(commentCounts));
            });
      }
    } catch (e) {
      print('Error initializing WebSocket: $e');
    }
  }

  void _onUpdateCommentCounts(
    UpdateCommentCountsEvent event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(
        HomeLoaded(
          currentState.posts!,
          commentCounts: event.commentCounts,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
          hasNext: currentState.hasNext,
          isLoadingMore: currentState.isLoadingMore,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _commentCountSubscription?.cancel();
    return super.close();
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
      final postListEntity = dataState.data!;

      // Load comment counts cho tất cả posts
      for (final post in postListEntity.data) {
        commentSocketService.loadComments(post.id);
      }

      emit(
        HomeLoaded(
          postListEntity.data,
          commentCounts: {},
          currentPage: postListEntity.page,
          limit: postListEntity.limit,
          hasNext: postListEntity.hasNext,
        ),
      );
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(HomeError(dataState.error!, errorMessage: errorMessage));
      return;
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;

    // Chỉ load more nếu đang ở trạng thái HomeLoaded và hasNext = true
    if (currentState is! HomeLoaded ||
        currentState.hasNext != true ||
        currentState.isLoadingMore) {
      return;
    }

    // Emit state với isLoadingMore = true để hiển thị loading indicator
    emit(
      HomeLoaded(
        currentState.posts!,
        commentCounts: currentState.commentCounts,
        currentPage: currentState.currentPage,
        limit: currentState.limit,
        hasNext: currentState.hasNext,
        isLoadingMore: true,
      ),
    );

    final nextPage = (currentState.currentPage ?? 1) + 1;
    final dataState = await getHomePostsUseCase(
      params: GetHomePostsParams(
        page: nextPage,
        limit: currentState.limit ?? 10,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      final postListEntity = dataState.data!;
      // Append data mới vào danh sách hiện tại
      final updatedPosts = [...currentState.posts!, ...postListEntity.data];

      // Load comment counts cho posts mới
      for (final post in postListEntity.data) {
        commentSocketService.loadComments(post.id);
      }

      emit(
        HomeLoaded(
          updatedPosts,
          commentCounts: currentState.commentCounts,
          currentPage: postListEntity.page,
          limit: postListEntity.limit,
          hasNext: postListEntity.hasNext,
          isLoadingMore: false,
        ),
      );
    } else {
      // Nếu load more fail, giữ nguyên state cũ nhưng tắt loading
      emit(
        HomeLoaded(
          currentState.posts!,
          commentCounts: currentState.commentCounts,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
          hasNext: currentState.hasNext,
          isLoadingMore: false,
        ),
      );
    }
  }
}
