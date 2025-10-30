import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/comment/domain/usecases/connect_comment_socket_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_home_posts_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool _isWebSocketInitialized = false;
  final GetHomePostsUseCase getHomePostsUseCase;
  final ConnectCommentSocketUseCase connectCommentSocketUseCase;
  final ListenCommentCountUseCase listenCommentCountUseCase;
  final LoadCommentsUseCase loadCommentsUseCase;
  StreamSubscription? _commentCountSubscription;

  HomeBloc({
    required this.getHomePostsUseCase,
    required this.connectCommentSocketUseCase,
    required this.listenCommentCountUseCase,
    required this.loadCommentsUseCase,
  }) : super(HomeInitial()) {
    print('>>> HomeBloc CREATED');
    on<InitializeWebSocketEvent>(_onInitializeWebSocket);
    on<WebSocketInitializedEvent>(_onWebSocketInitialized);
    on<LoadPostsEvent>(_onLoadPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<UpdateCommentCountsEvent>(_onUpdateCommentCounts);

    // Kết nối WebSocket khi khởi tạo HomeBloc
    // _initializeWebSocket();
  }

  void _onInitializeWebSocket(
    InitializeWebSocketEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (!_isWebSocketInitialized) {
      emit(HomeInitializing()); // Emit trạng thái đang khởi tạo
      await _initializeWebSocket();
      _isWebSocketInitialized = true;

      // Sau khi WebSocket khởi tạo xong, emit event để load posts
      add(const WebSocketInitializedEvent());
    }
  }

  void _onWebSocketInitialized(
    WebSocketInitializedEvent event,
    Emitter<HomeState> emit,
  ) {
    // WebSocket đã sẵn sàng, bây giờ load posts
    add(const LoadPostsEvent(page: 1, limit: 2));
  }

  Future<void> _initializeWebSocket() async {
    try {
      // Lấy userId từ token storage
      final userData = await TokenStorage.getUserData();
      final userId = userData?['id'];
      final username = userData?['username'];

      if (userId != null) {
        // Kết nối WebSocket qua UseCase
        connectCommentSocketUseCase(
          params: ConnectCommentSocketParams(userId, username),
        );

        // Lắng nghe stream comment count updates qua UseCase
        _commentCountSubscription =
            listenCommentCountUseCase(params: const NoParams()).listen((
              commentCounts,
            ) {
              // Khi nhận được cập nhật, thêm sự kiện để cập nhật state
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

      // Load comment counts cho tất cả posts qua UseCase
      for (final post in postListEntity.data) {
        loadCommentsUseCase(params: LoadCommentsParams(post.id));
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

      // Load comment counts cho posts mới qua UseCase
      for (final post in postListEntity.data) {
        loadCommentsUseCase(params: LoadCommentsParams(post.id));
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
