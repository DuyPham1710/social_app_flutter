import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/story/data/models/story_model.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';

part 'grouped_story_list_model.freezed.dart';
part 'grouped_story_list_model.g.dart';

@freezed
class GroupedUserStoryModel extends GroupedUserStoryEntity
    with _$GroupedUserStoryModel {
  const factory GroupedUserStoryModel({
    required UserModel user,
    required List<StoryModel> stories,
  }) = _GroupedUserStoryModel;

  factory GroupedUserStoryModel.fromJson(Map<String, dynamic> json) =>
      _$GroupedUserStoryModelFromJson(json);
}

@freezed
class GroupedStoryListModel extends GroupedStoryListEntity
    with _$GroupedStoryListModel {
  const factory GroupedStoryListModel({
    required List<GroupedUserStoryModel> users,
    required int page,
    required int limit,
    required int total,
    required bool hasNext,
  }) = _GroupedStoryListModel;

  factory GroupedStoryListModel.fromJson(Map<String, dynamic> json) =>
      _$GroupedStoryListModelFromJson(json);
}
