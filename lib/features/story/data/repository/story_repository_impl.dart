import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/data/data_sources/remote/story_remote_data_source.dart';
import 'package:social_app_fe/features/story/data/models/grouped_story_list_model.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<GroupedStoryListModel>> getHomeStories({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getHomeStories(page, limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
