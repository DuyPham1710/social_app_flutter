// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['_id'] as String,
      caption: json['caption'] as String,
      user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      urls: (json['urls'] as List<dynamic>)
          .map((e) => PostUrlModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      layout: json['layout'] as String,
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
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'caption': instance.caption,
      'userId': instance.user,
      'urls': instance.urls,
      'layout': instance.layout,
      'privacy_type': _$PrivacyTypeEnumMap[instance.privacyType]!,
      'friends_except': instance.friendsExcept,
      'friends_detail': instance.friendsDetail,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PrivacyTypeEnumMap = {
  PrivacyType.public: 'public',
  PrivacyType.friends: 'friends',
  PrivacyType.friendsExcept: 'friends_except',
  PrivacyType.friendsDetail: 'friends_detail',
  PrivacyType.private: 'private',
};
