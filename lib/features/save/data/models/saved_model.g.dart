// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedModelImpl _$$SavedModelImplFromJson(Map<String, dynamic> json) =>
    _$SavedModelImpl(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      targetId: json['targetId'] as String,
      type: json['type'] as String,
      content: json['content'] as String? ?? '',
      collection: json['collection'] as String? ?? 'default',
      note: json['note'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String?,
      authorAvatar: json['authorAvatar'] as String?,
    );

Map<String, dynamic> _$$SavedModelImplToJson(_$SavedModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'targetId': instance.targetId,
      'type': instance.type,
      'content': instance.content,
      'collection': instance.collection,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatar': instance.authorAvatar,
    };
