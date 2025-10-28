// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationshipStatusModelImpl _$$RelationshipStatusModelImplFromJson(
  Map<String, dynamic> json,
) => _$RelationshipStatusModelImpl(
  status: json['status'] as String,
  requestId: json['requestId'] as String?,
  canSendRequest: json['canSendRequest'] as bool?,
  canCancelRequest: json['canCancelRequest'] as bool?,
  canAcceptRequest: json['canAcceptRequest'] as bool?,
  canRejectRequest: json['canRejectRequest'] as bool?,
);

Map<String, dynamic> _$$RelationshipStatusModelImplToJson(
  _$RelationshipStatusModelImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  if (instance.requestId case final value?) 'requestId': value,
  if (instance.canSendRequest case final value?) 'canSendRequest': value,
  if (instance.canCancelRequest case final value?) 'canCancelRequest': value,
  if (instance.canAcceptRequest case final value?) 'canAcceptRequest': value,
  if (instance.canRejectRequest case final value?) 'canRejectRequest': value,
};
