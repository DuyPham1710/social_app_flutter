import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/parent_comment_entity.dart';

part 'parent_comment_model.freezed.dart';
part 'parent_comment_model.g.dart';

@freezed
class ParentCommentModel extends ParentCommentEntity with _$ParentCommentModel {
  const factory ParentCommentModel({
    @JsonKey(name: '_id') required String id,
    required String content,
    DateTime? createdAt,
    @JsonKey(name: 'userId') UserModel? user,
  }) = _ParentCommentModel;

  factory ParentCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ParentCommentModelFromJson(json);
}
