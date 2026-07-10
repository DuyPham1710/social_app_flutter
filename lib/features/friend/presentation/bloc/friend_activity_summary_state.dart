import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/friend/domain/entities/activity_summary_entity.dart';

abstract class FriendActivitySummaryState extends Equatable {
  const FriendActivitySummaryState();

  @override
  List<Object?> get props => [];
}

class FriendActivitySummaryInitial extends FriendActivitySummaryState {}

class FriendActivitySummaryLoading extends FriendActivitySummaryState {}

class FriendActivitySummaryLoaded extends FriendActivitySummaryState {
  final ActivitySummaryEntity summary;

  const FriendActivitySummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class FriendActivitySummaryError extends FriendActivitySummaryState {
  final String message;

  const FriendActivitySummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
