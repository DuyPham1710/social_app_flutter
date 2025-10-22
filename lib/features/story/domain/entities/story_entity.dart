import 'package:social_app_fe/core/base/privacy_base.dart';
import 'package:social_app_fe/core/enums/media_type.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/deezer_music_entity.dart';

class StoryEntity extends PrivacyBase {
  final String id;
  final UserEntity user;
  final String? title;
  final String? mediaUrl;
  final MediaType mediaType;
  final DeezerMusicEntity? music;
  final DateTime expireAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoryEntity({
    required this.id,
    required this.user,
    this.title,
    this.mediaUrl,
    required this.mediaType,
    this.music,
    required this.expireAt,
    this.createdAt,
    this.updatedAt,
    required super.privacyType,
    super.friendsExcept,
    super.friendsDetail,
  });

  @override
  String toString() {
    return 'StoryEntity(id: $id, user: $user, title: $title, mediaUrl: $mediaUrl, mediaType: $mediaType, music: $music, expiresAt: $expireAt, privacyType: $privacyType)';
  }
}
