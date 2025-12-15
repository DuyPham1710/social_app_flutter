import 'package:social_app_fe/core/enums/media_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/story/domain/entities/create_story_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/deezer_music_entity.dart';

class CreateStoryModel {
  final String? title;
  final String? mediaUrl;
  final MediaType mediaType;
  final DeezerMusicEntity? music;
  final PrivacyType privacyType;
  final List<String>? friendsExcept;
  final List<String>? friendsDetail;

  const CreateStoryModel({
    this.title,
    this.mediaUrl,
    required this.mediaType,
    this.music,
    required this.privacyType,
    this.friendsExcept,
    this.friendsDetail,
  });

  factory CreateStoryModel.fromEntity(CreateStoryEntity entity) {
    return CreateStoryModel(
      title: entity.title,
      mediaUrl: entity.mediaUrl,
      mediaType: entity.mediaType,
      music: entity.music,
      privacyType: entity.privacyType,
      friendsExcept: entity.friendsExcept,
      friendsDetail: entity.friendsDetail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      'mediaType': mediaType.name,
      if (music != null)
        'music': {
          'id': music!.id,
          'title': music!.title,
          'preview': music!.preview,
          'artist': {
            'id': music!.artist.id,
            'name': music!.artist.name,
            'picture': music!.artist.picture,
          },
          'album': {
            'id': music!.album.id,
            'title': music!.album.title,
            'cover': music!.album.cover,
          },
        },
      'privacy_type': _mapPrivacyTypeToString(privacyType),
      if (friendsExcept != null && friendsExcept!.isNotEmpty)
        'friends_except': friendsExcept,
      if (friendsDetail != null && friendsDetail!.isNotEmpty)
        'friends_detail': friendsDetail,
    };
  }

  String _mapPrivacyTypeToString(PrivacyType type) {
    switch (type) {
      case PrivacyType.public:
        return 'public';
      case PrivacyType.friends:
        return 'friends';
      case PrivacyType.friendsExcept:
        return 'friends_except';
      case PrivacyType.friendsDetail:
        return 'friends_detail';
      case PrivacyType.private:
        return 'private';
    }
  }
}


