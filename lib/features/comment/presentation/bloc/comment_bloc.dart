import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/params/add_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/usecases/add_comment_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/emit_typing_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/join_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/leave_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_typing_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final JoinPostUseCase _joinPostUseCase;
  final LeavePostUseCase _leavePostUseCase;
  final EmitTypingUseCase _emitTypingUseCase;
  final ListenTypingUseCase _listenTypingUseCase;
  final AddCommentUseCase _addCommentUseCase;
  Timer? _typingDebounce;
  StreamSubscription? _typingSubscription;

  CommentBloc({
    required JoinPostUseCase joinPostUseCase,
    required LeavePostUseCase leavePostUseCase,
    required EmitTypingUseCase emitTypingUseCase,
    required ListenTypingUseCase listenTypingUseCase,
    required AddCommentUseCase addCommentUseCase,
  }) : _joinPostUseCase = joinPostUseCase,
       _leavePostUseCase = leavePostUseCase,
       _emitTypingUseCase = emitTypingUseCase,
       _listenTypingUseCase = listenTypingUseCase,
       _addCommentUseCase = addCommentUseCase,
       super(CommentInitial()) {
    on<JoinPostEvent>(_onJoinPost);
    on<LeavePostEvent>(_onLeavePost);
    on<UserTypingEvent>(_onUserTyping);
    on<UpdateTypingUsersEvent>(_onUpdateTypingUsers);
    on<AddCommentEvent>(_onAddComment);
  }

  void _onAddComment(AddCommentEvent event, Emitter<CommentState> emit) {
    _addCommentUseCase(
      params: AddCommentParams(
        postId: event.postId,
        content: event.content,
        parentId: event.parentId,
      ),
    );
  }

  void _onJoinPost(JoinPostEvent event, Emitter<CommentState> emit) {
    _joinPostUseCase(params: JoinPostParams(event.postId));

    // Listen typing events từ use case khi join post
    _typingSubscription = _listenTypingUseCase(params: const NoParams()).listen(
      (typingEvent) {
        if (typingEvent.postId == event.postId) {
          add(
            UpdateTypingUsersEvent(
              userId: typingEvent.userId,
              username: typingEvent.username,
              isTyping: typingEvent.isTyping,
            ),
          );
        }
      },
    );

    // Emit state với postId
    emit(CommentJoined(postId: event.postId));
  }

  void _onLeavePost(LeavePostEvent event, Emitter<CommentState> emit) {
    _leavePostUseCase(params: LeavePostParams(event.postId));

    // Cancel typing subscription khi leave post
    _typingSubscription?.cancel();
    _typingSubscription = null;

    // Reset state
    emit(CommentInitial());
  }

  void _onUserTyping(UserTypingEvent event, Emitter<CommentState> emit) {
    // Cancel previous debounce timer
    _typingDebounce?.cancel();

    // Emit typing = true immediately
    if (event.isTyping) {
      _emitTypingUseCase(
        params: EmitTypingParams(postId: event.postId, isTyping: true),
      );

      // Đặt timer 5 giây - sau 5 giây sẽ tự động gửi "ngừng typing"
      _typingDebounce = Timer(const Duration(seconds: 5), () {
        _emitTypingUseCase(
          params: EmitTypingParams(postId: event.postId, isTyping: false),
        );
      });
    } else {
      // User stopped typing manually
      _emitTypingUseCase(
        params: EmitTypingParams(postId: event.postId, isTyping: false),
      );
    }
  }

  void _onUpdateTypingUsers(
    UpdateTypingUsersEvent event,
    Emitter<CommentState> emit,
  ) {
    final currentState = state;

    if (currentState is CommentJoined) {
      final updatedTypingUsers = Set<TypingUser>.from(currentState.typingUsers);

      if (event.isTyping) {
        // Add user to typing list
        updatedTypingUsers.add(
          TypingUser(userId: event.userId, username: event.username),
        );
      } else {
        // Remove user from typing list
        updatedTypingUsers.removeWhere((user) => user.userId == event.userId);
      }

      emit(
        CommentJoined(
          postId: currentState.postId!,
          typingUsers: updatedTypingUsers,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _typingDebounce?.cancel();
    _typingSubscription?.cancel();
    return super.close();
  }
}
