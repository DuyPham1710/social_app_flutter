// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment-log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentLogModelImpl _$$CommentLogModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommentLogModelImpl(
  id: json['_id'] as String,
  commentId: json['commentId'] as String,
  oldContent: json['oldContent'] as String,
  newContent: json['newContent'] as String,
  editedBy: UserModel.fromJson(json['editedBy'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CommentLogModelImplToJson(
  _$CommentLogModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'commentId': instance.commentId,
  'oldContent': instance.oldContent,
  'newContent': instance.newContent,
  'editedBy': instance.editedBy,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
