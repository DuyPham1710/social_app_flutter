import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/story/domain/entities/react_story_entity.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';

/// Usecase để tạo hoặc cập nhật react cho story (trả về null nếu xóa react)
class CreateOrUpdateReactStoryUsecase
    implements UseCase<DataState<ReactStoryEntity?>, ReactStoryParams> {
  final StoryRepository _repository;

  CreateOrUpdateReactStoryUsecase(this._repository);

  @override
  Future<DataState<ReactStoryEntity?>> call({ReactStoryParams? params}) {
    return _repository.createOrUpdateReactStory(
      storyId: params!.storyId,
      emojiId: params.emojiId,
    );
  }
}

/// Usecase để lấy danh sách react của story
class GetStoryReactsUsecase
    implements
        UseCase<DataState<List<ReactStoryEntity>>, GetStoryReactsParams> {
  final StoryRepository _repository;

  GetStoryReactsUsecase(this._repository);

  @override
  Future<DataState<List<ReactStoryEntity>>> call({
    GetStoryReactsParams? params,
  }) {
    return _repository.getStoryReacts(storyId: params!.storyId);
  }
}

/// Usecase để kiểm tra user hiện tại có react story không
class CheckUserReactStoryUsecase
    implements
        UseCase<DataState<Map<String, dynamic>?>, CheckUserReactStoryParams> {
  final StoryRepository _repository;

  CheckUserReactStoryUsecase(this._repository);

  @override
  Future<DataState<Map<String, dynamic>?>> call({
    CheckUserReactStoryParams? params,
  }) {
    return _repository.checkUserReactStory(storyId: params!.storyId);
  }
}

/// Usecase để cập nhật react của story
class UpdateReactStoryUsecase
    implements UseCase<DataState<ReactStoryEntity>, ReactStoryParams> {
  final StoryRepository _repository;

  UpdateReactStoryUsecase(this._repository);

  @override
  Future<DataState<ReactStoryEntity>> call({ReactStoryParams? params}) {
    return _repository.updateReactStory(
      storyId: params!.storyId,
      emojiId: params.emojiId,
    );
  }
}

/// Usecase để xóa react của story
class DeleteReactStoryUsecase
    implements UseCase<DataState<void>, DeleteReactStoryParams> {
  final StoryRepository _repository;

  DeleteReactStoryUsecase(this._repository);

  @override
  Future<DataState<void>> call({DeleteReactStoryParams? params}) {
    return _repository.deleteReactStory(storyId: params!.storyId);
  }
}

/// Params cho react story
class ReactStoryParams {
  final String storyId;
  final String emojiId;

  const ReactStoryParams({required this.storyId, required this.emojiId});
}

/// Params cho get story reacts
class GetStoryReactsParams {
  final String storyId;

  const GetStoryReactsParams({required this.storyId});
}

/// Params cho check user react story
class CheckUserReactStoryParams {
  final String storyId;

  const CheckUserReactStoryParams({required this.storyId});
}

/// Params cho delete react story
class DeleteReactStoryParams {
  final String storyId;

  const DeleteReactStoryParams({required this.storyId});
}
