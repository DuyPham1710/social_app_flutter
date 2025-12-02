import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment-log_entity.dart';

part 'comment-log_model.freezed.dart';
part 'comment-log_model.g.dart';

@freezed
class CommentLogModel extends CommentLogEntity with _$CommentLogModel {
  const factory CommentLogModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'commentId') required String commentId,
    required String oldContent,
    required String newContent,
    required UserModel editedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CommentLogModel;

  factory CommentLogModel.fromJson(Map<String, dynamic> json) =>
      _$CommentLogModelFromJson(json);
}
