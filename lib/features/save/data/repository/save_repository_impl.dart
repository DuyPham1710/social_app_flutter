import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/save/data/data_sources/remote/save_remote_data_source.dart';
import 'package:social_app_fe/features/save/data/models/saved_list_model.dart';
import 'package:social_app_fe/features/save/domain/entities/saved_entity.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';

class SaveRepositoryImpl implements SaveRepository {
  final SaveRemoteDataSource remoteDataSource;

  SaveRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<SavedEntity>> savePost({
    required String targetId,
    required String type,
    String? content,
    String? collection,
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{
        'targetId': targetId,
        'type': type,
      };
      if (content != null) body['content'] = content;
      if (collection != null) body['collection'] = collection;
      if (note != null) body['note'] = note;

      final response = await remoteDataSource.savePost(body);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> unsavePost({required String savedId}) async {
    try {
      await remoteDataSource.unsavePost(savedId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<bool>> checkSaved({
    required String targetId,
    required String type,
  }) async {
    try {
      final result = await remoteDataSource.checkSaved(targetId, type);
      return DataStateSuccess(result);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<SavedListModel>> getSavedByUser({
    String? type,
    String? collection,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.getSavedByUser(
        type: type,
        collection: collection,
        page: page,
        limit: limit,
      );
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
