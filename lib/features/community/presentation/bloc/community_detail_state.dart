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

class CommunityActionSuccess extends CommunityDetailState {
  final String message;
  final String? requestId; // For tracking which invite was responded to

  const CommunityActionSuccess(this.message, {this.requestId});
}

class CommunityDetailError extends CommunityDetailState {
  final String message;

  const CommunityDetailError(this.message);
}
