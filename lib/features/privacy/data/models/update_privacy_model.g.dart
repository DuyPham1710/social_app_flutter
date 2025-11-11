// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_privacy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdatePrivacyModelImpl _$$UpdatePrivacyModelImplFromJson(
  Map<String, dynamic> json,
) => _$UpdatePrivacyModelImpl(
  defaultPrivacy: $enumDecode(_$PrivacyTypeEnumMap, json['defaultPrivacy']),
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
);

Map<String, dynamic> _$$UpdatePrivacyModelImplToJson(
  _$UpdatePrivacyModelImpl instance,
) => <String, dynamic>{
  'defaultPrivacy': _$PrivacyTypeEnumMap[instance.defaultPrivacy]!,
  'friends_except': instance.friendsExcept,
  'friends_detail': instance.friendsDetail,
};

const _$PrivacyTypeEnumMap = {
  PrivacyType.public: 'public',
  PrivacyType.friends: 'friends',
  PrivacyType.friendsExcept: 'friends_except',
  PrivacyType.friendsDetail: 'friends_detail',
  PrivacyType.private: 'private',
};
