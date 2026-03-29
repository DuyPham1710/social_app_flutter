import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/save/data/models/saved_list_model.dart';
import 'package:social_app_fe/features/save/domain/entities/saved_entity.dart';

abstract class SaveRepository {
  /// Lưu bài post (hoặc reel, comment)
  Future<DataState<SavedEntity>> savePost({
    required String targetId,
    required String type,
    String? content,
    String? collection,
    String? note,
  });

  /// Bỏ lưu
  Future<DataState<void>> unsavePost({required String savedId});

  /// Kiểm tra đã lưu chưa
  Future<DataState<bool>> checkSaved({
    required String targetId,
    required String type,
  });

  /// Lấy danh sách đã lưu của user
  Future<DataState<SavedListModel>> getSavedByUser({
    String? type,
    String? collection,
    int? page,
    int? limit,
  });
}
