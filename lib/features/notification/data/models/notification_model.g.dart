// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['_id'] as String,
  type: json['type'] as String,
  message: json['message'] as String,
  content: json['content'] as String?,
  isRead: json['isRead'] as bool,
  createdAt: _dateTimeFromJson(json['createdAt']),
  sender: json['sender'] == null
      ? null
      : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
  community: _communityFromJson(json['community']),
  targetId: json['targetId'] as String?,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'type': instance.type,
  'message': instance.message,
  'content': instance.content,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt?.toIso8601String(),
  'sender': instance.sender,
  'community': _communityToJson(instance.community),
  'targetId': instance.targetId,
};
