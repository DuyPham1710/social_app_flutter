import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/data/models/post_url_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';

part 'community_post_model.freezed.dart';
part 'community_post_model.g.dart';

@freezed
class CommunityPostModel with _$CommunityPostModel {
  const factory CommunityPostModel({
    @JsonKey(name: '_id') required String id,
    String? caption,
    @JsonKey(name: 'userId') required UserModel user,
    required List<PostUrlModel> urls,
    required String layout,
    @Default([]) List<ReactPostModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
    @JsonKey(name: 'privacy_type')
    @Default(PrivacyType.public)
    PrivacyType privacyType,
    @JsonKey(name: 'communityStatus')
    String? communityStatus, // 'pending', 'approved', 'rejected'
    @JsonKey(name: 'communityId') required String communityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CommunityPostModel;

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostModelFromJson(json);
}
