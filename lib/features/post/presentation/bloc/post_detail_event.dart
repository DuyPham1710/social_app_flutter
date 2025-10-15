import 'package:equatable/equatable.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object?> get props => [];
}

class InitializePostDetailEvent extends PostDetailEvent {
  final String postId;

  const InitializePostDetailEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class UpdatePostCommentCountEvent extends PostDetailEvent {
  final Map<String, int> commentCounts;

  const UpdatePostCommentCountEvent(this.commentCounts);

  @override
  List<Object?> get props => [commentCounts];
}
