import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends HomeEvent {
  final int page;
  final int limit;

  const LoadPostsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class LoadMorePostsEvent extends HomeEvent {
  const LoadMorePostsEvent();
}

class UpdateCommentCountsEvent extends HomeEvent {
  final Map<String, int> commentCounts;

  const UpdateCommentCountsEvent(this.commentCounts);

  @override
  List<Object?> get props => [commentCounts];
}

class InitializeWebSocketEvent extends HomeEvent {
  const InitializeWebSocketEvent();
}

class WebSocketInitializedEvent extends HomeEvent {
  const WebSocketInitializedEvent();
}

class ReactPostEvent extends HomeEvent {
  final String postId;
  final String emojiId;
  const ReactPostEvent({required this.postId, required this.emojiId});

  @override
  List<Object?> get props => [postId, emojiId];
}
