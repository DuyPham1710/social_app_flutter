part of 'community_detail_bloc.dart';

abstract class CommunityDetailState {
  const CommunityDetailState();
}

class CommunityDetailInitial extends CommunityDetailState {
  const CommunityDetailInitial();
}

class CommunityDetailLoading extends CommunityDetailState {
  const CommunityDetailLoading();
}

class CommunityDetailLoaded extends CommunityDetailState {
  final CommunityModel community;
  final String memberStatus; // 'member', 'invited', 'pending', 'none'
  final String? userRole; // 'admin', 'member', null

  const CommunityDetailLoaded({
    required this.community,
    required this.memberStatus,
    this.userRole,
  });
}

class CommunityPostsLoaded extends CommunityDetailState {
  final List<CommunityPostModel> posts;
  final int page;
  final int limit;

  const CommunityPostsLoaded({
    required this.posts,
    required this.page,
    required this.limit,
  });
}

class CommunityActionSuccess extends CommunityDetailState {
  final String message;

  const CommunityActionSuccess(this.message);
}

class CommunityDetailError extends CommunityDetailState {
  final String message;

  const CommunityDetailError(this.message);
}
