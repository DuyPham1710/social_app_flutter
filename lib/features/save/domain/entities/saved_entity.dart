class SavedEntity {
  final String id;
  final String userId;
  final String targetId;
  final String type;
  final String content;
  final String collection;
  final String note;
  final DateTime? createdAt;
  
  // Dynamic fields populated by backend
  final String? authorId;
  final String? authorName;
  final String? authorAvatar;

  const SavedEntity({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.type,
    this.content = '',
    this.collection = 'default',
    this.note = '',
    this.createdAt,
    this.authorId,
    this.authorName,
    this.authorAvatar,
  });
}
