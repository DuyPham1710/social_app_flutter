import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_mapper.dart';
import 'package:social_app_fe/features/comment/data/models/comment_model.dart';
import 'package:social_app_fe/features/comment/data/models/comments_loaded_model.dart';
import 'package:social_app_fe/features/comment/data/models/react_comment_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';
import 'package:social_app_fe/features/comment/domain/usecases/clear_comments_cache_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comments_loaded_data_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comments_loaded_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/react_comment_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_state.dart';

class CommentDetailsBloc
    extends Bloc<CommentDetailsEvent, CommentDetailsState> {
  final GetCommentsLoadedDataUseCase getCommentsLoadedDataUseCase;
  final ListenCommentsLoadedUseCase listenCommentsLoadedUseCase;
  final ClearCommentsCacheUseCase clearCommentsCacheUseCase;
  final ReactCommentUsecase reactCommentUseCase;
  StreamSubscription? _commentsLoadedSubscription;
  String? _currentPostId;

  CommentDetailsBloc({
    required this.getCommentsLoadedDataUseCase,
    required this.listenCommentsLoadedUseCase,
    required this.clearCommentsCacheUseCase,
    required this.reactCommentUseCase,
  }) : super(CommentDetailsInitial()) {
    on<LoadCommentDetailsEvent>(_onLoadCommentDetails);
    on<RefreshCommentDetailsEvent>(_onRefreshCommentDetails);
    on<StartListeningCommentsEvent>(_onStartListeningComments);
    on<StopListeningCommentsEvent>(_onStopListeningComments);
    on<CommentsUpdatedEvent>(_onCommentsUpdated);
    on<ClearCommentCacheEvent>(_onClearCommentCache);
    on<ReactCommentEvent>(_onReactComment);
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
    await Future.delayed(const Duration(milliseconds: 700));

    // Load từ cache sau khi server đã update
    await _loadCommentDetails(postId, emit);
  }

  Future<void> _onReactComment(
    ReactCommentEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is CommentDetailsLoaded) {

      final currentEntities = currentState.commentsData?.comments;
      if (currentEntities == null) return;

      final index = currentEntities.indexWhere((c) => c.id == event.commentId);
      if (index == -1) return;

      final commentEntity = currentEntities[index];


      CommentModel commentModel;
      if (commentEntity is CommentModel) {
        commentModel = commentEntity;
      } else {
        return; // Or handle error
      }

      // 3. Handle Reacts logic using Freezed Models
      final currentReacts = List<ReactCommentModel>.from(
        commentModel.reacts ?? [],
      );
      final reactIndex = currentReacts.indexWhere(
        (r) => r.user.userId == event.currentUserId,
      );

      if (reactIndex == -1) {
        // Use the User mapper here!
        final userModel = commentModel.user is UserModel
            ? commentModel.user as UserModel
            : commentModel.user.toModel();

        final currentUserFake = userModel.copyWith(
          userId: event.currentUserId,
          fullName: 'Bạn',
          avatarUrl: event.currentUserAvatar,
        );

        currentReacts.add(
          ReactCommentModel(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            user: currentUserFake,
            commentId: event.commentId,
            emoji: event.emoji,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        final currentReact = currentReacts[reactIndex];
        if (currentReact.emoji == event.emoji) {
          currentReacts.removeAt(reactIndex);
        } else {
          currentReacts[reactIndex] = currentReact.copyWith(
            emoji: event.emoji,
            updatedAt: DateTime.now(),
          );
        }
      }

      // 4. Update the CommentModel
      final updatedCommentModel = commentModel.copyWith(reacts: currentReacts);
      final updatedList = List<CommentEntity>.from(currentEntities);
      updatedList[index] =
          updatedCommentModel; // Polymorphism: Model is an Entity
      CommentsLoadedEntity updatedData;
      if (currentState.commentsData is CommentsLoadedModel) {
        updatedData = (currentState.commentsData as CommentsLoadedModel)
            .copyWith(
              comments: updatedList
                  .cast<
                    CommentModel
                  >(), // Ensure type safety if list expects Models
            );
      } else {

        updatedData = (currentState.commentsData as CommentsLoadedModel)
            .copyWith(comments: updatedList.cast<CommentModel>());
      }

      emit(CommentDetailsLoaded(updatedData));

      try {
        await reactCommentUseCase(
          params: ReactCommentParams(
            commentId: event.commentId,
            emoji: event.emoji.id,
          ),
        );
      } catch (e) {
        print("Lỗi react: $e");
      }
    }
  }

  @override
  Future<void> close() {
    _commentsLoadedSubscription?.cancel();
    return super.close();
  }
}
