import 'package:social_app_fe/features/comment/domain/entities/comment-log_entity.dart';

class CommentLogsLoadedEntity {
  final String commentId;
  final List<CommentLogEntity> history;
  final int count;
  final DateTime timestamp;

  const CommentLogsLoadedEntity({
    required this.commentId,
    required this.history,
    required this.count,
    required this.timestamp,
  });

  bool get hasComments => history.isNotEmpty;
  bool get isEmpty => history.isEmpty;
}
