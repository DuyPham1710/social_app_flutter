import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';

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

class UpdateUserProfileEvent extends ProfileEvent {
  final UpdateUserEntity params;

  const UpdateUserProfileEvent(this.params);

  @override
  List<Object> get props => [params];
}

class DeleteFaceDataEvent extends ProfileEvent {
  const DeleteFaceDataEvent();
}
