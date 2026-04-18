// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePostModelImpl _$$CreatePostModelImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePostModelImpl(
  caption: json['caption'] as String?,
  titles: (json['titles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  orders: (json['orders'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  layout: $enumDecodeNullable(_$LayoutTypeEnumMap, json['layout']),
  privacyType: $enumDecodeNullable(_$PrivacyTypeEnumMap, json['privacyType']),
  friendsExcept: (json['friendsExcept'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  friendsDetail: (json['friendsDetail'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  communityId: json['communityId'] as String?,
);

Map<String, dynamic> _$$CreatePostModelImplToJson(
  _$CreatePostModelImpl instance,
) => <String, dynamic>{
  'caption': instance.caption,
  'titles': instance.titles,
  'orders': instance.orders,
  'layout': _$LayoutTypeEnumMap[instance.layout],
  'privacyType': _$PrivacyTypeEnumMap[instance.privacyType],
  'friendsExcept': instance.friendsExcept,
  'friendsDetail': instance.friendsDetail,
  'communityId': instance.communityId,
};

const _$LayoutTypeEnumMap = {
  LayoutType.classic: 'classic',
  LayoutType.column: 'column',
  LayoutType.frame: 'frame',
};

const _$PrivacyTypeEnumMap = {
  PrivacyType.public: 'public',
  PrivacyType.friends: 'friends',
  PrivacyType.friendsExcept: 'friends_except',
  PrivacyType.friendsDetail: 'friends_detail',
  PrivacyType.private: 'private',
};
