import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class ReactStoryEntity {
  final String id;
  final UserEntity user;
  final String storyId;
  final EmojiType emoji;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? mutualFriendsCount;
  final bool? isFriend;

  ReactStoryEntity({
    required this.id,
    required this.user,
    required this.storyId,
    required this.emoji,
    this.createdAt,
    this.updatedAt,
    this.mutualFriendsCount,
    this.isFriend,
  });
}

