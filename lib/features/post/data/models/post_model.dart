import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/data/models/post_url_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel extends PostEntity with _$PostModel {
  const factory PostModel({
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
    @JsonKey(name: 'friends_except') @Default([]) List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') @Default([]) List<String> friendsDetail,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
