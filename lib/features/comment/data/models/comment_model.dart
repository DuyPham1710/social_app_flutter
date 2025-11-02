import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/comment/data/models/parent_comment_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel extends CommentEntity with _$CommentModel {
  const factory CommentModel({
    @JsonKey(name: '_id') required String id,
    required String content,
    @JsonKey(name: 'userId') required UserModel user,
    required String postId,
    ParentCommentModel? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
