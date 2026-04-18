part of 'community_admin_bloc.dart';

abstract class CommunityAdminState {
  const CommunityAdminState();
}

class CommunityAdminInitial extends CommunityAdminState {
  const CommunityAdminInitial();
}

class CommunityAdminLoading extends CommunityAdminState {
  const CommunityAdminLoading();
}

class PendingRequestsLoaded extends CommunityAdminState {
  final List<CommunityRequestModel> requests;

  const PendingRequestsLoaded(this.requests);
}

class PendingPostsLoaded extends CommunityAdminState {
  final List<CommunityPostModel> posts;
  final int page;
  final int limit;

  const PendingPostsLoaded({
    required this.posts,
    required this.page,
    required this.limit,
  });
}

class CommunityAdminActionSuccess extends CommunityAdminState {
  final String message;

  const CommunityAdminActionSuccess(this.message);
}

class CommunityAdminError extends CommunityAdminState {
  final String message;

  const CommunityAdminError(this.message);
}
