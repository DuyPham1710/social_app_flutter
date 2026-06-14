part of 'community_admin_bloc.dart';

abstract class CommunityAdminState {
  CommunityAdminState();
}

class CommunityAdminInitial extends CommunityAdminState {
  CommunityAdminInitial();
}

class CommunityAdminLoading extends CommunityAdminState {
  CommunityAdminLoading();
}

class PendingRequestsLoaded extends CommunityAdminState {
  final List<CommunityRequestModel> requests;

  PendingRequestsLoaded(this.requests);
}

class PendingPostsLoaded extends CommunityAdminState {
  final List<CommunityPostModel> posts;
  final int page;
  final int limit;

  PendingPostsLoaded({
    required this.posts,
    required this.page,
    required this.limit,
  });
}

class CommunityAdminActionSuccess extends CommunityAdminState {
  final String message;

  CommunityAdminActionSuccess(this.message);
}

class CommunityAdminError extends CommunityAdminState {
  final String message;

  CommunityAdminError(this.message);
}
