import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

class PostListEntity {
  final List<PostEntity> data;
  final int? page;
  final int? limit;
  final int? total;
  final bool? hasNext;

  const PostListEntity({
    required this.data,
    this.page,
    this.limit,
    this.total,
    this.hasNext,
  });
}
