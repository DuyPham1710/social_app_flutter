import 'package:equatable/equatable.dart';

abstract class OtherProfileEvent extends Equatable {
  const OtherProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadOtherUserProfileEvent extends OtherProfileEvent {
  final String userId;
  const LoadOtherUserProfileEvent({required this.userId});

}

class LoadOtherProfilePostsEvent extends OtherProfileEvent {
  final String userId;
  final int page;
  const LoadOtherProfilePostsEvent({required this.userId, this.page = 1});
}

class LoadMoreOtherProfilePostsEvent extends OtherProfileEvent {
  final String userId;
  const LoadMoreOtherProfilePostsEvent({required this.userId});

}

class UpdateOtherProfileCommentCountsEvent extends OtherProfileEvent {
  final Map<String, int> commentCounts;
  const UpdateOtherProfileCommentCountsEvent(this.commentCounts);
}

class ReloadRelationshipEvent extends OtherProfileEvent {
  final String userId;
  const ReloadRelationshipEvent(this.userId);
}


