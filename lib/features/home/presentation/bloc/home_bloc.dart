import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/comment/domain/usecases/connect_comment_socket_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_home_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_post_detail_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/react_post_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool _isWebSocketInitialized = false;
  bool _isChatConnected = false;
  final GetHomePostsUseCase getHomePostsUseCase;
  final ConnectCommentSocketUseCase connectCommentSocketUseCase;
  final ListenCommentCountUseCase listenCommentCountUseCase;
  final LoadCommentsUseCase loadCommentsUseCase;
  final ReactPostUsecase reactPostUseCase;
  final GetPostDetailUsecase getPostDetailUsecase;
  final ConnectChatUseCase connectChatUseCase;
  final DisconnectChatUsecase disconnectChatUseCase;
  StreamSubscription? _commentCountSubscription;

  HomeBloc({
    required this.getHomePostsUseCase,
    required this.connectCommentSocketUseCase,
    required this.listenCommentCountUseCase,
    required this.loadCommentsUseCase,
    required this.reactPostUseCase,
    required this.getPostDetailUsecase,
    required this.connectChatUseCase,
    required this.disconnectChatUseCase,
  }) : super(HomeInitial()) {
    on<InitializeWebSocketEvent>(_onInitializeWebSocket);
    on<WebSocketInitializedEvent>(_onWebSocketInitialized);
    on<LoadPostsEvent>(_onLoadPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<UpdateCommentCountsEvent>(_onUpdateCommentCounts);
    on<ReactPostEvent>(_onReactPost);
    on<GetPostDetailEvent>(_onGetPostDetail);
    on<ConnectChatEvent>(_onConnectChat);
    on<DisconnectChatEvent>(_onDisconnectChat);
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
        // Kết nối Comment WebSocket qua UseCase
        connectCommentSocketUseCase(
          params: ConnectCommentSocketParams(userId, username),
        );

        // Kết nối Chat WebSocket
        add(const ConnectChatEvent());

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

  void _onReactPost(ReactPostEvent event, Emitter<HomeState> emit) async {
    final dataState = await reactPostUseCase(
      params: ReactPostParams(postId: event.postId, emoji: event.emojiId),
    );
    if (dataState is DataStateSuccess && dataState.data != null) {
      // Reload posts để cập nhật react count và react info
      //add(const LoadPostsEvent(page: 1, limit: 2));
      print('Reacted to post successfully with data: ${dataState.data!.id}  ');
      add(GetPostDetailEvent(postId: event.postId));
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(HomeError(dataState.error!, errorMessage: errorMessage));
    }
  }

  void _onGetPostDetail(
    GetPostDetailEvent event,
    Emitter<HomeState> emit,
  ) async {
    final dataState = await getPostDetailUsecase(
      params: GetPostDetailParams(postId: event.postId),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      final updatedPost = dataState.data!;
      final currentState = state;

      if (currentState is HomeLoaded) {
        // Tìm và cập nhật post trong danh sách
        final updatedPosts = currentState.posts!.map((post) {
          if (post.id == event.postId) {
            return updatedPost; // Thay thế bằng post đã được update từ backend
          }
          return post;
        }).toList();

        emit(
          HomeLoaded(
            updatedPosts,
            commentCounts: currentState.commentCounts,
            currentPage: currentState.currentPage,
            limit: currentState.limit,
            hasNext: currentState.hasNext,
            isLoadingMore: currentState.isLoadingMore,
          ),
        );

        print('Updated post ${event.postId} with new react data');
      }
    } else {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      print('Error getting post detail: $errorMessage');
      // Không emit error để không làm gián đoạn UI, chỉ log
    }
  }

  void _onConnectChat(ConnectChatEvent event, Emitter<HomeState> emit) async {
    if (_isChatConnected) {
      print('Chat already connected in HomeBloc');
      return;
    }

    try {
      // Lấy userId từ token storage
      final userData = await TokenStorage.getUserData();
      final userId = userData?['id'];
      final username = userData?['username'];

      if (userId != null) {
        print(
          'Connecting to chat from HomeBloc with userId: $userId, username: $username',
        );

        // Connect to chat namespace and wait for connection
        await connectChatUseCase(
          params: ConnectChatSocketParams(userId, username ?? 'Unknown'),
        );
        _isChatConnected = true;

        print('Chat connected successfully from HomeBloc');
      }
    } catch (e) {
      print('Error connecting to chat from HomeBloc: $e');
    }
  }

  void _onDisconnectChat(
    DisconnectChatEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (!_isChatConnected) {
      print('Chat already disconnected in HomeBloc');
      return;
    }

    try {
      print('Disconnecting from chat in HomeBloc...');
      await disconnectChatUseCase();
      _isChatConnected = false;
      print('Chat disconnected successfully from HomeBloc');
    } catch (e) {
      print('Error disconnecting from chat in HomeBloc: $e');
    }
  }

  @override
  Future<void> close() {
    _commentCountSubscription?.cancel();
    // Disconnect chat when HomeBloc is disposed
    if (_isChatConnected) {
      disconnectChatUseCase();
    }
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
