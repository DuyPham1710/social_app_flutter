// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deezer_music_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeezerArtistModel _$DeezerArtistModelFromJson(Map<String, dynamic> json) {
  return _DeezerArtistModel.fromJson(json);
}

/// @nodoc
mixin _$DeezerArtistModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get picture => throw _privateConstructorUsedError;

  /// Serializes this DeezerArtistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeezerArtistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeezerArtistModelCopyWith<DeezerArtistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeezerArtistModelCopyWith<$Res> {
  factory $DeezerArtistModelCopyWith(
    DeezerArtistModel value,
    $Res Function(DeezerArtistModel) then,
  ) = _$DeezerArtistModelCopyWithImpl<$Res, DeezerArtistModel>;
  @useResult
  $Res call({int id, String name, String picture});
}

/// @nodoc
class _$DeezerArtistModelCopyWithImpl<$Res, $Val extends DeezerArtistModel>
    implements $DeezerArtistModelCopyWith<$Res> {
  _$DeezerArtistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeezerArtistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? picture = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            picture: null == picture
                ? _value.picture
                : picture // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeezerArtistModelImplCopyWith<$Res>
    implements $DeezerArtistModelCopyWith<$Res> {
  factory _$$DeezerArtistModelImplCopyWith(
    _$DeezerArtistModelImpl value,
    $Res Function(_$DeezerArtistModelImpl) then,
  ) = __$$DeezerArtistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String picture});
}

/// @nodoc
class __$$DeezerArtistModelImplCopyWithImpl<$Res>
    extends _$DeezerArtistModelCopyWithImpl<$Res, _$DeezerArtistModelImpl>
    implements _$$DeezerArtistModelImplCopyWith<$Res> {
  __$$DeezerArtistModelImplCopyWithImpl(
    _$DeezerArtistModelImpl _value,
    $Res Function(_$DeezerArtistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeezerArtistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? picture = null}) {
    return _then(
      _$DeezerArtistModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        picture: null == picture
            ? _value.picture
            : picture // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeezerArtistModelImpl implements _DeezerArtistModel {
  const _$DeezerArtistModelImpl({
    required this.id,
    required this.name,
    required this.picture,
  });

  factory _$DeezerArtistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeezerArtistModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String picture;

  @override
  String toString() {
    return 'DeezerArtistModel(id: $id, name: $name, picture: $picture)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeezerArtistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.picture, picture) || other.picture == picture));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, picture);

  /// Create a copy of DeezerArtistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeezerArtistModelImplCopyWith<_$DeezerArtistModelImpl> get copyWith =>
      __$$DeezerArtistModelImplCopyWithImpl<_$DeezerArtistModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeezerArtistModelImplToJson(this);
  }
}

abstract class _DeezerArtistModel implements DeezerArtistModel {
  const factory _DeezerArtistModel({
    required final int id,
    required final String name,
    required final String picture,
  }) = _$DeezerArtistModelImpl;

  factory _DeezerArtistModel.fromJson(Map<String, dynamic> json) =
      _$DeezerArtistModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get picture;

  /// Create a copy of DeezerArtistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeezerArtistModelImplCopyWith<_$DeezerArtistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeezerAlbumModel _$DeezerAlbumModelFromJson(Map<String, dynamic> json) {
  return _DeezerAlbumModel.fromJson(json);
}

/// @nodoc
mixin _$DeezerAlbumModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get cover => throw _privateConstructorUsedError;

  /// Serializes this DeezerAlbumModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeezerAlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeezerAlbumModelCopyWith<DeezerAlbumModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeezerAlbumModelCopyWith<$Res> {
  factory $DeezerAlbumModelCopyWith(
    DeezerAlbumModel value,
    $Res Function(DeezerAlbumModel) then,
  ) = _$DeezerAlbumModelCopyWithImpl<$Res, DeezerAlbumModel>;
  @useResult
  $Res call({int id, String title, String cover});
}

/// @nodoc
class _$DeezerAlbumModelCopyWithImpl<$Res, $Val extends DeezerAlbumModel>
    implements $DeezerAlbumModelCopyWith<$Res> {
  _$DeezerAlbumModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeezerAlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? title = null, Object? cover = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            cover: null == cover
                ? _value.cover
                : cover // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeezerAlbumModelImplCopyWith<$Res>
    implements $DeezerAlbumModelCopyWith<$Res> {
  factory _$$DeezerAlbumModelImplCopyWith(
    _$DeezerAlbumModelImpl value,
    $Res Function(_$DeezerAlbumModelImpl) then,
  ) = __$$DeezerAlbumModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, String cover});
}

/// @nodoc
class __$$DeezerAlbumModelImplCopyWithImpl<$Res>
    extends _$DeezerAlbumModelCopyWithImpl<$Res, _$DeezerAlbumModelImpl>
    implements _$$DeezerAlbumModelImplCopyWith<$Res> {
  __$$DeezerAlbumModelImplCopyWithImpl(
    _$DeezerAlbumModelImpl _value,
    $Res Function(_$DeezerAlbumModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeezerAlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? title = null, Object? cover = null}) {
    return _then(
      _$DeezerAlbumModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        cover: null == cover
            ? _value.cover
            : cover // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeezerAlbumModelImpl implements _DeezerAlbumModel {
  const _$DeezerAlbumModelImpl({
    required this.id,
    required this.title,
    required this.cover,
  });

  factory _$DeezerAlbumModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeezerAlbumModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String cover;

  @override
  String toString() {
    return 'DeezerAlbumModel(id: $id, title: $title, cover: $cover)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeezerAlbumModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.cover, cover) || other.cover == cover));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, cover);

  /// Create a copy of DeezerAlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeezerAlbumModelImplCopyWith<_$DeezerAlbumModelImpl> get copyWith =>
      __$$DeezerAlbumModelImplCopyWithImpl<_$DeezerAlbumModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeezerAlbumModelImplToJson(this);
  }
}

abstract class _DeezerAlbumModel implements DeezerAlbumModel {
  const factory _DeezerAlbumModel({
    required final int id,
    required final String title,
    required final String cover,
  }) = _$DeezerAlbumModelImpl;

  factory _DeezerAlbumModel.fromJson(Map<String, dynamic> json) =
      _$DeezerAlbumModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get cover;

  /// Create a copy of DeezerAlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeezerAlbumModelImplCopyWith<_$DeezerAlbumModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeezerMusicModel _$DeezerMusicModelFromJson(Map<String, dynamic> json) {
  return _DeezerMusicModel.fromJson(json);
}

/// @nodoc
mixin _$DeezerMusicModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get preview => throw _privateConstructorUsedError;
  DeezerArtistModel get artist => throw _privateConstructorUsedError;
  DeezerAlbumModel get album => throw _privateConstructorUsedError;

  /// Serializes this DeezerMusicModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeezerMusicModelCopyWith<DeezerMusicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeezerMusicModelCopyWith<$Res> {
  factory $DeezerMusicModelCopyWith(
    DeezerMusicModel value,
    $Res Function(DeezerMusicModel) then,
  ) = _$DeezerMusicModelCopyWithImpl<$Res, DeezerMusicModel>;
  @useResult
  $Res call({
    int id,
    String title,
    String preview,
    DeezerArtistModel artist,
    DeezerAlbumModel album,
  });

  $DeezerArtistModelCopyWith<$Res> get artist;
  $DeezerAlbumModelCopyWith<$Res> get album;
}

/// @nodoc
class _$DeezerMusicModelCopyWithImpl<$Res, $Val extends DeezerMusicModel>
    implements $DeezerMusicModelCopyWith<$Res> {
  _$DeezerMusicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? preview = null,
    Object? artist = null,
    Object? album = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            preview: null == preview
                ? _value.preview
                : preview // ignore: cast_nullable_to_non_nullable
                      as String,
            artist: null == artist
                ? _value.artist
                : artist // ignore: cast_nullable_to_non_nullable
                      as DeezerArtistModel,
            album: null == album
                ? _value.album
                : album // ignore: cast_nullable_to_non_nullable
                      as DeezerAlbumModel,
          )
          as $Val,
    );
  }

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeezerArtistModelCopyWith<$Res> get artist {
    return $DeezerArtistModelCopyWith<$Res>(_value.artist, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeezerAlbumModelCopyWith<$Res> get album {
    return $DeezerAlbumModelCopyWith<$Res>(_value.album, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeezerMusicModelImplCopyWith<$Res>
    implements $DeezerMusicModelCopyWith<$Res> {
  factory _$$DeezerMusicModelImplCopyWith(
    _$DeezerMusicModelImpl value,
    $Res Function(_$DeezerMusicModelImpl) then,
  ) = __$$DeezerMusicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String preview,
    DeezerArtistModel artist,
    DeezerAlbumModel album,
  });

  @override
  $DeezerArtistModelCopyWith<$Res> get artist;
  @override
  $DeezerAlbumModelCopyWith<$Res> get album;
}

/// @nodoc
class __$$DeezerMusicModelImplCopyWithImpl<$Res>
    extends _$DeezerMusicModelCopyWithImpl<$Res, _$DeezerMusicModelImpl>
    implements _$$DeezerMusicModelImplCopyWith<$Res> {
  __$$DeezerMusicModelImplCopyWithImpl(
    _$DeezerMusicModelImpl _value,
    $Res Function(_$DeezerMusicModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? preview = null,
    Object? artist = null,
    Object? album = null,
  }) {
    return _then(
      _$DeezerMusicModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        preview: null == preview
            ? _value.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as String,
        artist: null == artist
            ? _value.artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as DeezerArtistModel,
        album: null == album
            ? _value.album
            : album // ignore: cast_nullable_to_non_nullable
                  as DeezerAlbumModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeezerMusicModelImpl implements _DeezerMusicModel {
  const _$DeezerMusicModelImpl({
    required this.id,
    required this.title,
    required this.preview,
    required this.artist,
    required this.album,
  });

  factory _$DeezerMusicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeezerMusicModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String preview;
  @override
  final DeezerArtistModel artist;
  @override
  final DeezerAlbumModel album;

  @override
  String toString() {
    return 'DeezerMusicModel(id: $id, title: $title, preview: $preview, artist: $artist, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeezerMusicModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.preview, preview) || other.preview == preview) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.album, album) || other.album == album));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, preview, artist, album);

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeezerMusicModelImplCopyWith<_$DeezerMusicModelImpl> get copyWith =>
      __$$DeezerMusicModelImplCopyWithImpl<_$DeezerMusicModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeezerMusicModelImplToJson(this);
  }
}

abstract class _DeezerMusicModel implements DeezerMusicModel {
  const factory _DeezerMusicModel({
    required final int id,
    required final String title,
    required final String preview,
    required final DeezerArtistModel artist,
    required final DeezerAlbumModel album,
  }) = _$DeezerMusicModelImpl;

  factory _DeezerMusicModel.fromJson(Map<String, dynamic> json) =
      _$DeezerMusicModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get preview;
  @override
  DeezerArtistModel get artist;
  @override
  DeezerAlbumModel get album;

  /// Create a copy of DeezerMusicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeezerMusicModelImplCopyWith<_$DeezerMusicModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
