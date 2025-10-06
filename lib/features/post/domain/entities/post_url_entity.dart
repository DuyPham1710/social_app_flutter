class PostUrlEntity {
  final String id;
  final String url;
  final String? title;
  final int order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostUrlEntity({
    required this.id,
    required this.url,
    this.title,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() => 'PostUrlEntity(id: $id, url: $url, order: $order)';
}
