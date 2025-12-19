// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'react_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactCommentModelImpl _$$ReactCommentModelImplFromJson(
  Map<String, dynamic> json,
) => _$ReactCommentModelImpl(
  id: json['_id'] as String,
  user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
  commentId: json['commentId'] as String,
  emoji: const CommentEmojiConverter().fromJson(
    json['emojiId'] as Map<String, dynamic>,
  ),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  mutualFriendsCount: (json['mutualFriendsCount'] as num?)?.toInt(),
  isFriend: json['isFriend'] as bool?,
);

Map<String, dynamic> _$$ReactCommentModelImplToJson(
  _$ReactCommentModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.user,
  'commentId': instance.commentId,
  'emojiId': const CommentEmojiConverter().toJson(instance.emoji),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'mutualFriendsCount': instance.mutualFriendsCount,
  'isFriend': instance.isFriend,
};
