// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deezer_music_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeezerArtistModelImpl _$$DeezerArtistModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeezerArtistModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  picture: json['picture'] as String,
);

Map<String, dynamic> _$$DeezerArtistModelImplToJson(
  _$DeezerArtistModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'picture': instance.picture,
};

_$DeezerAlbumModelImpl _$$DeezerAlbumModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeezerAlbumModelImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  cover: json['cover'] as String,
);

Map<String, dynamic> _$$DeezerAlbumModelImplToJson(
  _$DeezerAlbumModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'cover': instance.cover,
};

_$DeezerMusicModelImpl _$$DeezerMusicModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeezerMusicModelImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  preview: json['preview'] as String,
  artist: DeezerArtistModel.fromJson(json['artist'] as Map<String, dynamic>),
  album: DeezerAlbumModel.fromJson(json['album'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DeezerMusicModelImplToJson(
  _$DeezerMusicModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'preview': instance.preview,
  'artist': instance.artist,
  'album': instance.album,
};
