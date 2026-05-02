part of 'community_list_bloc.dart';

abstract class CommunityListEvent {
  const CommunityListEvent();
}

class CommunityListFetched extends CommunityListEvent {
  final int page;
  final int limit;
  final String? search;

  const CommunityListFetched({
    required this.page,
    required this.limit,
    this.search,
  });
}

class CommunityListSearched extends CommunityListEvent {
  final String query;

  const CommunityListSearched(this.query);
}

class MyCommunitiesFetched extends CommunityListEvent {
  const MyCommunitiesFetched();
}

class MyInvitesFetched extends CommunityListEvent {
  const MyInvitesFetched();
}

class PendingCommunitiesFetched extends CommunityListEvent {
  const PendingCommunitiesFetched();
}
