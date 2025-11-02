class DeleteCommentParams {
  final String commentId;
  final String postId;

  const DeleteCommentParams({required this.commentId, required this.postId});

  Map<String, dynamic> toJson() => {'commentId': commentId, 'postId': postId};
}
