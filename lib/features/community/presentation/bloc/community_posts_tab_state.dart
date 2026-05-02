part of 'community_posts_tab_bloc.dart';

abstract class CommunityPostsTabState extends Equatable {
  const CommunityPostsTabState();

  @override
  List<Object?> get props => [];
}

class CommunityPostsTabInitial extends CommunityPostsTabState {
  const CommunityPostsTabInitial();
}

class CommunityPostsTabLoading extends CommunityPostsTabState {
  const CommunityPostsTabLoading();
}

class CommunityPostsTabLoaded extends CommunityPostsTabState {
  final List<PostEntity> posts;
  final int page;
  final int limit;
  final int total;
  final bool hasNext;
  final String status;
  final Map<String, int> commentCounts;

  const CommunityPostsTabLoaded({
    required this.posts,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
    required this.status,
    this.commentCounts = const {},
  });

  @override
  List<Object?> get props => [
    posts,
    page,
    limit,
    total,
    hasNext,
    status,
    commentCounts,
  ];
}

class CommunityPostsTabError extends CommunityPostsTabState {
  final String message;

  const CommunityPostsTabError({required this.message});

  @override
  List<Object?> get props => [message];
}
