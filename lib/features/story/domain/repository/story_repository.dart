import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';

abstract class StoryRepository {
  Future<DataState<GroupedStoryListEntity>> getHomeStories({
    int page = 1,
    int limit = 10,
  });
}
