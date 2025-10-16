import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/comment/domain/usecases/clear_comments_cache_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comments_loaded_data_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comments_loaded_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_state.dart';

class CommentDetailsBloc
    extends Bloc<CommentDetailsEvent, CommentDetailsState> {
  final GetCommentsLoadedDataUseCase getCommentsLoadedDataUseCase;
  final ListenCommentsLoadedUseCase listenCommentsLoadedUseCase;
  final ClearCommentsCacheUseCase clearCommentsCacheUseCase;
  StreamSubscription? _commentsLoadedSubscription;
  String? _currentPostId;

  CommentDetailsBloc({
    required this.getCommentsLoadedDataUseCase,
    required this.listenCommentsLoadedUseCase,
    required this.clearCommentsCacheUseCase,
  }) : super(CommentDetailsInitial()) {
    on<LoadCommentDetailsEvent>(_onLoadCommentDetails);
    on<RefreshCommentDetailsEvent>(_onRefreshCommentDetails);
    on<StartListeningCommentsEvent>(_onStartListeningComments);
    on<StopListeningCommentsEvent>(_onStopListeningComments);
    on<CommentsUpdatedEvent>(_onCommentsUpdated);
    on<ClearCommentCacheEvent>(_onClearCommentCache);
  }

  Future<void> _onClearCommentCache(
    ClearCommentCacheEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    await clearCommentsCacheUseCase(
      params: ClearCommentsCacheParams(event.postId),
    );
    print("Cleared comment cache for postId: ${event.postId}");
  }

  Future<void> _onLoadCommentDetails(
    LoadCommentDetailsEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    emit(CommentDetailsLoading());
    _currentPostId = event.postId;

    // Start listening for real-time updates
    add(StartListeningCommentsEvent(event.postId));

    // Load từ server để ensure data mới nhất
    await _loadCommentsFromServer(event.postId, emit);
  }

  Future<void> _onRefreshCommentDetails(
    RefreshCommentDetailsEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    // Refresh load từ server để có data mới nhất
    await _loadCommentsFromServer(event.postId, emit);
  }

  void _onStartListeningComments(
    StartListeningCommentsEvent event,
    Emitter<CommentDetailsState> emit,
  ) {
    // Cancel previous subscription if any
    _commentsLoadedSubscription?.cancel();

    // Start listening to comments loaded stream
    _commentsLoadedSubscription =
        listenCommentsLoadedUseCase(params: const NoParams()).listen((
          commentsData,
        ) {
          // Only emit if it's for the current post
          if (commentsData.postId == event.postId) {
            add(CommentsUpdatedEvent(commentsData));
          }
        });
  }

  void _onStopListeningComments(
    StopListeningCommentsEvent event,
    Emitter<CommentDetailsState> emit,
  ) {
    _commentsLoadedSubscription?.cancel();
    _commentsLoadedSubscription = null;
    _currentPostId = null;
  }

  void _onCommentsUpdated(
    CommentsUpdatedEvent event,
    Emitter<CommentDetailsState> emit,
  ) {
    // Update UI với comments mới
    emit(CommentDetailsLoaded(event.commentsData));
  }

  Future<void> _loadCommentDetails(
    String postId,
    Emitter<CommentDetailsState> emit,
  ) async {
    final dataState = await getCommentsLoadedDataUseCase(
      params: GetCommentsLoadedDataParams(postId),
    );
    print('>>>DataState received: ${dataState.data}');
    if (dataState is DataStateSuccess) {
      if (dataState.data == null) {
        // Chưa có data, hiển thị empty state
        emit(CommentDetailsEmpty(postId));
      } else {
        // Có data, hiển thị comments
        emit(CommentDetailsLoaded(dataState.data!));
      }
    } else if (dataState is DataStateError) {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(CommentDetailsError(dataState.error!, errorMessage: errorMessage));
    }
  }

  /// Load comments from server để đảm bảo data mới nhất
  Future<void> _loadCommentsFromServer(
    String postId,
    Emitter<CommentDetailsState> emit,
  ) async {
    await clearCommentsCacheUseCase(params: ClearCommentsCacheParams(postId));

    // Đợi 500ms để server có thời gian emit data mới
    await Future.delayed(const Duration(milliseconds: 500));

    // Load từ cache sau khi server đã update
    await _loadCommentDetails(postId, emit);
  }

  @override
  Future<void> close() {
    _commentsLoadedSubscription?.cancel();
    return super.close();
  }
}
