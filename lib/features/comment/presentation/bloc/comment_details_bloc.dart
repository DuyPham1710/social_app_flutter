import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comments_loaded_data_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comments_loaded_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_state.dart';

class CommentDetailsBloc
    extends Bloc<CommentDetailsEvent, CommentDetailsState> {
  final GetCommentsLoadedDataUseCase getCommentsLoadedDataUseCase;
  final ListenCommentsLoadedUseCase listenCommentsLoadedUseCase;
  StreamSubscription? _commentsLoadedSubscription;
  String? _currentPostId;

  CommentDetailsBloc({
    required this.getCommentsLoadedDataUseCase,
    required this.listenCommentsLoadedUseCase,
  }) : super(CommentDetailsInitial()) {
    on<LoadCommentDetailsEvent>(_onLoadCommentDetails);
    on<RefreshCommentDetailsEvent>(_onRefreshCommentDetails);
    on<StartListeningCommentsEvent>(_onStartListeningComments);
    on<StopListeningCommentsEvent>(_onStopListeningComments);
    on<CommentsUpdatedEvent>(_onCommentsUpdated);
  }

  Future<void> _onLoadCommentDetails(
    LoadCommentDetailsEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    emit(CommentDetailsLoading());
    _currentPostId = event.postId;

    // Start listening for real-time updates
    add(StartListeningCommentsEvent(event.postId));

    await _loadCommentDetails(event.postId, emit);
  }

  Future<void> _onRefreshCommentDetails(
    RefreshCommentDetailsEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    // Refresh không show loading để UX tốt hơn
    await _loadCommentDetails(event.postId, emit);
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

  @override
  Future<void> close() {
    _commentsLoadedSubscription?.cancel();
    return super.close();
  }
}
