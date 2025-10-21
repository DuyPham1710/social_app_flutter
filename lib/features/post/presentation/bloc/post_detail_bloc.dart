import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/join_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/leave_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_event.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final JoinPostUseCase joinPostUseCase;
  final LeavePostUseCase leavePostUseCase;
  final ListenCommentCountUseCase listenCommentCountUseCase;
  final LoadCommentsUseCase loadCommentsUseCase;

  StreamSubscription? _commentCountSubscription;
  String? _currentPostId;

  PostDetailBloc({
    required this.joinPostUseCase,
    required this.leavePostUseCase,
    required this.listenCommentCountUseCase,
    required this.loadCommentsUseCase,
  }) : super(PostDetailInitial()) {
    on<InitializePostDetailEvent>(_onInitializePostDetail);
    on<UpdatePostCommentCountEvent>(_onUpdatePostCommentCount);
  }

  Future<void> _onInitializePostDetail(
    InitializePostDetailEvent event,
    Emitter<PostDetailState> emit,
  ) async {
    _currentPostId = event.postId;

    // Join post để nhận updates
    joinPostUseCase(params: JoinPostParams(event.postId));

    // Load comment count ban đầu
    loadCommentsUseCase(params: LoadCommentsParams(event.postId));

    // Lắng nghe stream comment count updates
    _commentCountSubscription =
        listenCommentCountUseCase(params: const NoParams()).listen((
          commentCounts,
        ) {
          add(UpdatePostCommentCountEvent(commentCounts));
        });

    emit(const PostDetailLoaded(commentCount: 0));
  }

  void _onUpdatePostCommentCount(
    UpdatePostCommentCountEvent event,
    Emitter<PostDetailState> emit,
  ) {
    if (_currentPostId != null) {
      final commentCount = event.commentCounts[_currentPostId] ?? 0;
      emit(PostDetailLoaded(commentCount: commentCount));
    }
  }

  @override
  Future<void> close() {
    if (_currentPostId != null) {
      leavePostUseCase(params: LeavePostParams(_currentPostId!));
    }
    _commentCountSubscription?.cancel();
    return super.close();
  }
}
