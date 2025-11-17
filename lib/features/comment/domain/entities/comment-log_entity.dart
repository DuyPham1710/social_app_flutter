import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class CommentLogEntity {
  final String id;
  final String commentId;
  final String oldContent;
  final String newContent;
  final UserEntity editedBy;
  final DateTime? createdAt;

  const CommentLogEntity({
    required this.id,
    required this.commentId,
    required this.oldContent,
    required this.newContent,
    required this.editedBy,
    this.createdAt,
  });

  @override
  String toString() {
    return 'CommentLogEntity(id: $id, commentId: $commentId, oldContent: $oldContent, newContent: $newContent, editedBy: $editedBy)';
  }
}
