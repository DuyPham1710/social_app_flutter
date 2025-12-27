import 'package:social_app_fe/core/base/privacy_base.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_url_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

class PostEntity extends PrivacyBase {
  final String id;
  final String? caption;
  final UserEntity user;
  final List<PostUrlEntity> urls;
  final String layout;
  final List<ReactPostEntity>? reacts;
  final EmojiType? isReact;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostEntity({
    required this.id,
    this.caption,
    required this.user,
    required this.urls,
    required this.layout,
    this.reacts,
    this.isReact,
    required super.privacyType,
    super.friendsExcept,
    super.friendsDetail,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'PostEntity(id: $id, caption: $caption, user: $user, urls: $urls, layout: $layout, privacyType: $privacyType)';
  }
}
