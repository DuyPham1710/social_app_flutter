import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/enums/media_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/story/data/models/deezer_music_model.dart';
import 'package:social_app_fe/features/story/data/models/react_story_model.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel extends StoryEntity with _$StoryModel {
  const factory StoryModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'userId') required UserModel user,
    String? title,
    String? mediaUrl,
    required MediaType mediaType,
    DeezerMusicModel? music,
    @JsonKey(name: 'privacy_type')
    @Default(PrivacyType.public)
    PrivacyType privacyType,
    @JsonKey(name: 'friends_except') @Default([]) List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') @Default([]) List<String> friendsDetail,
    required DateTime expireAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<ReactStoryModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}
