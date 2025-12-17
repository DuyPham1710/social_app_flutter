import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class ReactCommentEntity {
  final String id;
  final UserEntity user;
  final String commentId;
  final EmojiType emoji;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? mutualFriendsCount;
  final bool? isFriend;

  ReactCommentEntity({
    required this.id,
    required this.user,
    required this.commentId,
    required this.emoji,
    this.createdAt,
    this.updatedAt,
    this.mutualFriendsCount,
    this.isFriend,
  });
}


