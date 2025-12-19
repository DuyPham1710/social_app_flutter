import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/domain/entities/create_story_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';

abstract class StoryRepository {
  Future<DataState<GroupedStoryListEntity>> getHomeStories({
    int page = 1,
    int limit = 10,
  });

  /// Tạo story, không cần trả về dữ liệu chi tiết, chỉ cần biết thành công/thất bại.
  Future<DataState<void>> createStory({
    required CreateStoryEntity story,
  });

  /// Cập nhật quyền riêng tư của story
  Future<DataState<void>> updateStoryPrivacy({
    required String storyId,
    required PrivacyType privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
  });

  /// Xóa story
  Future<DataState<void>> deleteStory({
    required String storyId,
  });
}
