// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'react_story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactStoryModelImpl _$$ReactStoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ReactStoryModelImpl(
  id: json['_id'] as String,
  user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
  storyId: json['storyId'] as String,
  emoji: const EmojiConverter().fromJson(
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

Map<String, dynamic> _$$ReactStoryModelImplToJson(
  _$ReactStoryModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.user,
  'storyId': instance.storyId,
  'emojiId': const EmojiConverter().toJson(instance.emoji),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'mutualFriendsCount': instance.mutualFriendsCount,
  'isFriend': instance.isFriend,
};
