part of 'community_list_bloc.dart';

abstract class CommunityListEvent {
  CommunityListEvent();
}

class CommunityListFetched extends CommunityListEvent {
  final int page;
  final int limit;
  final String? search;

  CommunityListFetched({
    required this.page,
    required this.limit,
    this.search,
  });
}

class CommunityListSearched extends CommunityListEvent {
  final String query;

  CommunityListSearched(this.query);
}

class MyCommunitiesFetched extends CommunityListEvent {
  MyCommunitiesFetched();
}

class MyInvitesFetched extends CommunityListEvent {
  MyInvitesFetched();
}

class PendingCommunitiesFetched extends CommunityListEvent {
  PendingCommunitiesFetched();
}

class CancelPendingCommunityRequested extends CommunityListEvent {
  final String communityId;

  CancelPendingCommunityRequested(this.communityId);
}
