import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';

class GroupedUserStoryEntity {
  final UserEntity user;
  final List<StoryEntity> stories;

  const GroupedUserStoryEntity({required this.user, required this.stories});
}

class GroupedStoryListEntity {
  final List<GroupedUserStoryEntity> users;
  final int page;
  final int limit;
  final int total;
  final bool hasNext;

  const GroupedStoryListEntity({
    required this.users,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
  });
}
