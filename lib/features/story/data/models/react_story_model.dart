import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/story/domain/entities/react_story_entity.dart';

part 'react_story_model.freezed.dart';
part 'react_story_model.g.dart';

@freezed
class ReactStoryModel extends ReactStoryEntity with _$ReactStoryModel {
  const factory ReactStoryModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'userId') required UserModel user,
    @JsonKey(name: 'storyId') required String storyId,
    @EmojiConverter() @JsonKey(name: 'emojiId') required EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? mutualFriendsCount,
    bool? isFriend,
  }) = _ReactStoryModel;

  factory ReactStoryModel.fromJson(Map<String, dynamic> json) =>
      _$ReactStoryModelFromJson(json);
}

