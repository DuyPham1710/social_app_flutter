import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/story/domain/entities/deezer_music_entity.dart';

part 'deezer_music_model.freezed.dart';
part 'deezer_music_model.g.dart';

@freezed
class DeezerArtistModel extends DeezerArtistEntity with _$DeezerArtistModel {
  const factory DeezerArtistModel({
    required int id,
    required String name,
    required String picture,
  }) = _DeezerArtistModel;

  factory DeezerArtistModel.fromJson(Map<String, dynamic> json) =>
      _$DeezerArtistModelFromJson(json);
}

@freezed
class DeezerAlbumModel extends DeezerAlbumEntity with _$DeezerAlbumModel {
  const factory DeezerAlbumModel({
    required int id,
    required String title,
    required String cover,
  }) = _DeezerAlbumModel;

  factory DeezerAlbumModel.fromJson(Map<String, dynamic> json) =>
      _$DeezerAlbumModelFromJson(json);
}

@freezed
class DeezerMusicModel extends DeezerMusicEntity with _$DeezerMusicModel {
  const factory DeezerMusicModel({
    required int id,
    required String title,
    required String preview,
    required DeezerArtistModel artist,
    required DeezerAlbumModel album,
  }) = _DeezerMusicModel;

  factory DeezerMusicModel.fromJson(Map<String, dynamic> json) =>
      _$DeezerMusicModelFromJson(json);
}
