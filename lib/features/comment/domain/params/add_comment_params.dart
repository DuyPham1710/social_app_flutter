class AddCommentParams {
  final String postId;
  final String content;
  final String? parentId; // optional, dùng cho reply

  const AddCommentParams({
    required this.postId,
    required this.content,
    this.parentId,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'content': content,
    if (parentId != null) 'parentId': parentId,
  };
}
