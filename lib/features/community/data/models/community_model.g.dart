// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityModelImpl _$$CommunityModelImplFromJson(Map<String, dynamic> json) =>
    _$CommunityModelImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      coverImage: json['coverImage'] as String?,
      memberCount: (json['memberCount'] as num).toInt(),
      createdAt: _parseDateTime(json['createdAt']),
      createdBy: _extractAdminId(json['adminId']),
      status: json['privacy'] as String?,
      type: json['type'] as String?,
      myRole: json['myRole'] as String?,
      memberStatus: json['memberStatus'] as String?,
    );

Map<String, dynamic> _$$CommunityModelImplToJson(
  _$CommunityModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'avatar': instance.avatar,
  'coverImage': instance.coverImage,
  'memberCount': instance.memberCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'adminId': instance.createdBy,
  'privacy': instance.status,
  'type': instance.type,
  'myRole': instance.myRole,
  'memberStatus': instance.memberStatus,
};
