import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

part 'react_post_model.freezed.dart';
part 'react_post_model.g.dart';

class EmojiConverter implements JsonConverter<EmojiType, Map<String, dynamic>> {
  const EmojiConverter();

  @override
  EmojiType fromJson(Map<String, dynamic> json) {
    return EmojiType.values.firstWhere(
      (e) => e.id == json['_id'],
      orElse: () => EmojiType.like,
    );
  }

  @override
  Map<String, dynamic> toJson(EmojiType emoji) => {
    '_id': emoji.id,
    'label': emoji.label,
    'icon': emoji.icon,
  };
}

@freezed
class ReactPostModel extends ReactPostEntity with _$ReactPostModel {
  const factory ReactPostModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'userId') required UserModel user,
    required String postId,
    @EmojiConverter() @JsonKey(name: 'emojiId') required EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReactPostModel;

  factory ReactPostModel.fromJson(Map<String, dynamic> json) =>
      _$ReactPostModelFromJson(json);
}
