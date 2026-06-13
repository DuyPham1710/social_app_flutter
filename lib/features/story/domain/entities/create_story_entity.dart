import 'dart:io';
import 'dart:typed_data';

import 'package:social_app_fe/core/enums/media_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/story/domain/entities/deezer_music_entity.dart';

class CreateStoryEntity {
  final String? title;
  final String? mediaUrl;
  final MediaType mediaType;
  final DeezerMusicEntity? music;
  final PrivacyType privacyType;
  final List<String>? friendsExcept;
  final List<String>? friendsDetail;

  /// File ảnh/video gốc chọn từ điện thoại (chỉ dùng ở client để upload).
  final File? file;
  final Uint8List? fileBytes;
  final String? fileName;

  const CreateStoryEntity({
    this.title,
    this.mediaUrl,
    required this.mediaType,
    this.music,
    required this.privacyType,
    this.friendsExcept,
    this.friendsDetail,
    this.file,
    this.fileBytes,
    this.fileName,
  });
}


