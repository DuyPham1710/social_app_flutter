import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/react_comment_entity.dart';

part 'react_comment_model.freezed.dart';
part 'react_comment_model.g.dart';

class CommentEmojiConverter
    implements JsonConverter<EmojiType, Map<String, dynamic>> {
  const CommentEmojiConverter();

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
class ReactCommentModel extends ReactCommentEntity with _$ReactCommentModel {
  const factory ReactCommentModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'userId') required UserModel user,
    required String commentId,
    @CommentEmojiConverter() @JsonKey(name: 'emojiId') required EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? mutualFriendsCount,
    bool? isFriend,
  }) = _ReactCommentModel;

  factory ReactCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ReactCommentModelFromJson(json);
}


