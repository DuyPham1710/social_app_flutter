import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/comment/domain/entities/parent_comment_entity.dart';

class CommentEntity {
  final String id;
  final String content;
  final UserEntity user;
  final String postId;
  final ParentCommentEntity? parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommentEntity({
    required this.id,
    required this.content,
    required this.user,
    required this.postId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'CommentEntity(id: $id, content: $content, user: $user, postId: $postId, parentId: $parentId)';
  }
}
