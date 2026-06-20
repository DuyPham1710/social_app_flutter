// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['_id'] as String,
      caption: json['caption'] as String?,
      location: json['location'] as String?,
      user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      urls: (json['urls'] as List<dynamic>)
          .map((e) => PostUrlModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      layout: json['layout'] as String,
      reacts:
          (json['reacts'] as List<dynamic>?)
              ?.map((e) => ReactPostModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isReact: _$JsonConverterFromJson<Map<String, dynamic>, EmojiType>(
        json['isReact'],
        const EmojiConverter().fromJson,
      ),
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
      taggedUsers: (json['taggedUsers'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      visibleOnProfileUserIds:
          (json['visibleOnProfileUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      community: _parseCommunity(json['communityId']),
      communityStatus: json['communityStatus'] as String?,
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'caption': instance.caption,
      'location': instance.location,
      'userId': instance.user,
      'urls': instance.urls,
      'layout': instance.layout,
      'reacts': instance.reacts,
      'isReact': _$JsonConverterToJson<Map<String, dynamic>, EmojiType>(
        instance.isReact,
        const EmojiConverter().toJson,
      ),
      'privacy_type': _$PrivacyTypeEnumMap[instance.privacyType]!,
      'friends_except': instance.friendsExcept,
      'friends_detail': instance.friendsDetail,
      'taggedUsers': instance.taggedUsers,
      'visibleOnProfileUserIds': instance.visibleOnProfileUserIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'communityId': _serializeCommunity(instance.community),
      'communityStatus': instance.communityStatus,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$PrivacyTypeEnumMap = {
  PrivacyType.public: 'public',
  PrivacyType.friends: 'friends',
  PrivacyType.friendsExcept: 'friends_except',
  PrivacyType.friendsDetail: 'friends_detail',
  PrivacyType.private: 'private',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
