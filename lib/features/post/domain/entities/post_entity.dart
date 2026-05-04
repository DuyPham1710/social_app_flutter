import 'package:social_app_fe/core/base/privacy_base.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_url_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/community/domain/entities/community_entity.dart';

class PostEntity extends PrivacyBase {
  final String id;
  final String? caption;
  final UserEntity user;
  final List<PostUrlEntity> urls;
  final String layout;
  final List<ReactPostEntity>? reacts;
  final EmojiType? isReact;
  final List<UserEntity>? taggedUsers;
  final List<String>? visibleOnProfileUserIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CommunityEntity? community;
  final String? communityStatus;

  const PostEntity({
    required this.id,
    this.caption,
    required this.user,
    required this.urls,
    required this.layout,
    this.reacts,
    this.isReact,
    this.taggedUsers,
    this.visibleOnProfileUserIds,
    required super.privacyType,
    super.friendsExcept,
    super.friendsDetail,
    this.createdAt,
    this.updatedAt,
    this.community,
    this.communityStatus,
  });

  @override
  String toString() {
    return 'PostEntity(id: $id, caption: $caption, user: $user, urls: $urls, layout: $layout, privacyType: $privacyType, taggedUsers: $taggedUsers, visibleOnProfileUserIds: $visibleOnProfileUserIds, community: $community)';
  }
}
