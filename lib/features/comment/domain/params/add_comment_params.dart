class AddCommentParams {
  final String postId;
  final String content;
  final String? parentId;
  final List<String>? taggedUserIds; 

  const AddCommentParams({
    required this.postId,
    required this.content,
    this.parentId,
    this.taggedUserIds,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'content': content,
    if (parentId != null) 'parentId': parentId,
    if (taggedUserIds != null && taggedUserIds!.isNotEmpty) 
      'taggedUserIds': taggedUserIds,
  };
}
