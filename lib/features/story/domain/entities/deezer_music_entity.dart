class DeezerArtistEntity {
  final int id;
  final String name;
  final String picture;

  const DeezerArtistEntity({
    required this.id,
    required this.name,
    required this.picture,
  });
}

class DeezerAlbumEntity {
  final int id;
  final String title;
  final String cover;

  const DeezerAlbumEntity({
    required this.id,
    required this.title,
    required this.cover,
  });
}

class DeezerMusicEntity {
  final int id;
  final String title;
  final String preview;
  final DeezerArtistEntity artist;
  final DeezerAlbumEntity album;

  const DeezerMusicEntity({
    required this.id,
    required this.title,
    required this.preview,
    required this.artist,
    required this.album,
  });
}
