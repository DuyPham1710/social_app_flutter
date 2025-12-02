import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment-log_loaded_entity.dart';

class TypingUser {
  final String userId;
  final String? username;

  const TypingUser({required this.userId, this.username});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypingUser &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

abstract class CommentState extends Equatable {
  final String? postId;
  final Set<TypingUser> typingUsers;

  const CommentState({this.postId, this.typingUsers = const {}});

  @override
  List<Object?> get props => [postId, typingUsers];
}

class CommentInitial extends CommentState {}

class CommentJoined extends CommentState {
  const CommentJoined({required String super.postId, super.typingUsers});
}

class CommentHistoryLoading extends CommentState {
  final String commentId;

  const CommentHistoryLoading({required this.commentId});

  @override
  List<Object?> get props => [commentId, ...super.props];
}

class CommentHistoryLoaded extends CommentState {
  final CommentLogsLoadedEntity commentHistory;

  const CommentHistoryLoaded({required this.commentHistory});

  @override
  List<Object?> get props => [commentHistory, ...super.props];
}

class CommentHistoryError extends CommentState {
  final String message;
  final String commentId;

  const CommentHistoryError({required this.message, required this.commentId});

  @override
  List<Object?> get props => [message, commentId, ...super.props];
}
