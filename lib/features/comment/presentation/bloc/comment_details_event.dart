import 'package:equatable/equatable.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';

abstract class CommentDetailsEvent extends Equatable {
  const CommentDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCommentDetailsEvent extends CommentDetailsEvent {
  final String postId;

  const LoadCommentDetailsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class RefreshCommentDetailsEvent extends CommentDetailsEvent {
  final String postId;

  const RefreshCommentDetailsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class StartListeningCommentsEvent extends CommentDetailsEvent {
  final String postId;

  const StartListeningCommentsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class StopListeningCommentsEvent extends CommentDetailsEvent {
  const StopListeningCommentsEvent();
}

class CommentsUpdatedEvent extends CommentDetailsEvent {
  final CommentsLoadedEntity commentsData;

  const CommentsUpdatedEvent(this.commentsData);

  @override
  List<Object?> get props => [commentsData];
}

class ClearCommentCacheEvent extends CommentDetailsEvent {
  final String postId;

  const ClearCommentCacheEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ReactCommentEvent extends CommentDetailsEvent {
  final String commentId;
  final EmojiType emoji;
  final String currentUserId; 

  const ReactCommentEvent({
    required this.commentId,
    required this.emoji,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [commentId, emoji, currentUserId];
}
