import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';

class GetHomeStoriesUsecase
    implements
        UseCase<DataState<GroupedStoryListEntity>, GetHomeStoriesParams> {
  final StoryRepository _repository;

  GetHomeStoriesUsecase(this._repository);

  @override
  Future<DataState<GroupedStoryListEntity>> call({
    GetHomeStoriesParams? params,
  }) {
    final page = params?.page ?? 1;
    final limit = params?.limit ?? 10;
    return _repository.getHomeStories(page: page, limit: limit);
  }
}

class GetHomeStoriesParams {
  final int page;
  final int limit;

  const GetHomeStoriesParams({this.page = 1, this.limit = 10});
}
