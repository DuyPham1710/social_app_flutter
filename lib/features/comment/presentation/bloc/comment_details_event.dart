import 'package:equatable/equatable.dart';

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
