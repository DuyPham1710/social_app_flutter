import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/story/domain/entities/create_story_entity.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';

class CreateStoryUsecase
    implements UseCase<DataState<void>, CreateStoryEntity> {
  final StoryRepository _repository;

  CreateStoryUsecase(this._repository);

  @override
  Future<DataState<void>> call({CreateStoryEntity? params}) {
    return _repository.createStory(story: params!);
  }
}


