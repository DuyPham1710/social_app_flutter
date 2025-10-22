// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryModelImpl _$$StoryModelImplFromJson(Map<String, dynamic> json) =>
    _$StoryModelImpl(
      id: json['_id'] as String,
      user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      title: json['title'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      music: json['music'] == null
          ? null
          : DeezerMusicModel.fromJson(json['music'] as Map<String, dynamic>),
      privacyType:
          $enumDecodeNullable(_$PrivacyTypeEnumMap, json['privacy_type']) ??
          PrivacyType.public,
      friendsExcept:
          (json['friends_except'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      friendsDetail:
          (json['friends_detail'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      expireAt: DateTime.parse(json['expireAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StoryModelImplToJson(_$StoryModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.user,
      'title': instance.title,
      'mediaUrl': instance.mediaUrl,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'music': instance.music,
      'privacy_type': _$PrivacyTypeEnumMap[instance.privacyType]!,
      'friends_except': instance.friendsExcept,
      'friends_detail': instance.friendsDetail,
      'expireAt': instance.expireAt.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.text: 'text',
};

const _$PrivacyTypeEnumMap = {
  PrivacyType.public: 'public',
  PrivacyType.friends: 'friends',
  PrivacyType.friendsExcept: 'friends_except',
  PrivacyType.friendsDetail: 'friends_detail',
  PrivacyType.private: 'private',
};
