import 'package:social_app_fe/features/comment/domain/params/add_comment_params.dart';

class UpdateCommentParams extends AddCommentParams {
  final String commentId;

  const UpdateCommentParams({
    required this.commentId,
    required super.postId,
    required super.content,
    super.parentId,
  });

  @override
  Map<String, dynamic> toJson() => {
    'commentId': commentId,
    'postId': postId,
    'content': content,
    if (parentId != null) 'parentId': parentId,
  };
}
