// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParentCommentModelImpl _$$ParentCommentModelImplFromJson(
  Map<String, dynamic> json,
) => _$ParentCommentModelImpl(
  id: json['_id'] as String,
  content: json['content'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  user: json['userId'] == null
      ? null
      : UserModel.fromJson(json['userId'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ParentCommentModelImplToJson(
  _$ParentCommentModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'content': instance.content,
  'createdAt': instance.createdAt?.toIso8601String(),
  'userId': instance.user,
};
