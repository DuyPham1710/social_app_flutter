part of 'community_detail_bloc.dart';

abstract class CommunityDetailState {
  CommunityDetailState();
}

class CommunityDetailInitial extends CommunityDetailState {
  CommunityDetailInitial();
}

class CommunityDetailLoading extends CommunityDetailState {
  CommunityDetailLoading();
}

class CommunityDetailLoaded extends CommunityDetailState {
  final CommunityModel community;
  final String memberStatus; // 'member', 'invited', 'pending', 'none'
  final String? userRole; // 'admin', 'member', null

  CommunityDetailLoaded({
    required this.community,
    required this.memberStatus,
    this.userRole,
  });
}

class CommunityActionSuccess extends CommunityDetailState {
  final String message;
  final String? requestId; // For tracking which invite was responded to
  final String? communityId; // For filtering in item card listeners

  CommunityActionSuccess(
    this.message, {
    this.requestId,
    this.communityId,
  });
}

class CommunityDetailError extends CommunityDetailState {
  final String message;
  final String? communityId; // For filtering in item card listeners

  CommunityDetailError(this.message, {this.communityId});
}
