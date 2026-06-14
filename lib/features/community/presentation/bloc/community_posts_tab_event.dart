part of 'community_posts_tab_bloc.dart';

abstract class CommunityPostsTabEvent extends Equatable {
  CommunityPostsTabEvent();

  @override
  List<Object?> get props => [];
}

class CommunityPostsTabFetched extends CommunityPostsTabEvent {
  final String status; // 'all', 'pending', 'approved'

  CommunityPostsTabFetched({this.status = 'all'});

  @override
  List<Object?> get props => [status];
}

class CommunityPostsTabPageChanged extends CommunityPostsTabEvent {
  final int page;
  final String status;

  CommunityPostsTabPageChanged({
    required this.page,
    required this.status,
  });

  @override
  List<Object?> get props => [page, status];
}

class CommunityPostsTabStatusChanged extends CommunityPostsTabEvent {
  final String status; // 'all', 'pending', 'approved'

  CommunityPostsTabStatusChanged({required this.status});

  @override
  List<Object?> get props => [status];
}
