part of 'community_list_bloc.dart';

abstract class CommunityListState {
  const CommunityListState();
}

class CommunityListInitial extends CommunityListState {
  const CommunityListInitial();
}

class CommunityListLoading extends CommunityListState {
  const CommunityListLoading();
}

class CommunityListLoaded extends CommunityListState {
  final List<CommunityModel> communities;
  final int page;
  final int limit;
  final int total;
  final bool hasNext;
  final String? searchQuery;

  const CommunityListLoaded({
    required this.communities,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
    this.searchQuery,
  });
}

class MyCommunitiesLoaded extends CommunityListState {
  final List<CommunityModel> communities;

  const MyCommunitiesLoaded(this.communities);
}

class MyInvitesLoaded extends CommunityListState {
  final List<CommunityInviteModel> invites;

  const MyInvitesLoaded(this.invites);
}

class PendingCommunitiesLoaded extends CommunityListState {
  final List<CommunityModel> communities;

  const PendingCommunitiesLoaded(this.communities);
}

class CommunityListError extends CommunityListState {
  final String message;

  const CommunityListError(this.message);
}
