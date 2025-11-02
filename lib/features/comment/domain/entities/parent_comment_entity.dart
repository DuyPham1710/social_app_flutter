import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class ParentCommentEntity {
  final String id;
  final String content;
  final DateTime? createdAt;
  final UserEntity? user;

  const ParentCommentEntity({
    required this.id,
    required this.content,
    this.createdAt,
    this.user,
  });
}
