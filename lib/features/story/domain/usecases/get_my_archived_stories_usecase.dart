import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';

class GetMyArchivedStoriesUsecase {
  final StoryRepository _repo;

  GetMyArchivedStoriesUsecase(this._repo);

  Future<DataState<GroupedStoryListEntity>> call({
    int page = 1,
    int limit = 20,
  }) {
    return _repo.getMyArchivedStories(page: page, limit: limit);
  }
}