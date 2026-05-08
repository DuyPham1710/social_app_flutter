// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityRequestModelImpl _$$CommunityRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommunityRequestModelImpl(
  id: json['_id'] as String,
  user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
  type: json['type'] as String,
  status: json['status'] as String,
  sender: json['senderId'] == null
      ? null
      : UserModel.fromJson(json['senderId'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$CommunityRequestModelImplToJson(
  _$CommunityRequestModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.user,
  'type': instance.type,
  'status': instance.status,
  'senderId': instance.sender,
  'createdAt': instance.createdAt?.toIso8601String(),
};
