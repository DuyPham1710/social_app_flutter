import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class ReactPostEntity {
  final String id;
  final UserEntity user;
  final String postId;
  final EmojiType emoji;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? mutualFriendsCount;

  ReactPostEntity({
    required this.id,
    required this.user,
    required this.postId,
    required this.emoji,
    this.createdAt,
    this.updatedAt,
    this.mutualFriendsCount,
  });
}
