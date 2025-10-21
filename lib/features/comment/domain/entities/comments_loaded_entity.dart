import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';

class CommentsLoadedEntity {
  final String postId;
  final List<CommentEntity> comments;
  final int count;
  final DateTime timestamp;

  const CommentsLoadedEntity({
    required this.postId,
    required this.comments,
    required this.count,
    required this.timestamp,
  });

  bool get hasComments => comments.isNotEmpty;
  bool get isEmpty => comments.isEmpty;
}
