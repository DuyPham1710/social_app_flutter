// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivacyModelImpl _$$PrivacyModelImplFromJson(Map<String, dynamic> json) =>
    _$PrivacyModelImpl(
      user: json['userId'] == null
          ? null
          : UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      defaultPrivacy: $enumDecode(_$PrivacyTypeEnumMap, json['defaultPrivacy']),
      friendsExcept:
          (json['friends_except'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      friendsDetail:
          (json['friends_detail'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PrivacyModelImplToJson(_$PrivacyModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.user,
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
