// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_invite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityInviteModelImpl _$$CommunityInviteModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommunityInviteModelImpl(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  communityId: CommunityInfoModel.fromJson(
    json['communityId'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$CommunityInviteModelImplToJson(
  _$CommunityInviteModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.userId,
  'communityId': instance.communityId,
  'type': instance.type,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$CommunityInfoModelImpl _$$CommunityInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommunityInfoModelImpl(
  id: json['_id'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$CommunityInfoModelImplToJson(
  _$CommunityInfoModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'description': instance.description,
};
