import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfilePostsEvent extends ProfileEvent {
  final int page;
  final int limit;

  const LoadProfilePostsEvent({this.page = 1, this.limit = 2});

  @override
  List<Object?> get props => [page, limit];
}
class LoadMoreProfilePostsEvent extends ProfileEvent {
  const LoadMoreProfilePostsEvent();
}

class UpdateProfileCommentCountsEvent extends ProfileEvent {
  final Map<String, int> commentCounts;

  const UpdateProfileCommentCountsEvent(this.commentCounts);

  @override
  List<Object?> get props => [commentCounts];
}

class LoadUserProfileEvent extends ProfileEvent {
  const LoadUserProfileEvent();
}
