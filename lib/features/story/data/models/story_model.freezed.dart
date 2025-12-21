// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) {
  return _StoryModel.fromJson(json);
}

/// @nodoc
mixin _$StoryModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  MediaType get mediaType => throw _privateConstructorUsedError;
  DeezerMusicModel? get music => throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy_type')
  PrivacyType get privacyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_except')
  List<String> get friendsExcept => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_detail')
  List<String> get friendsDetail => throw _privateConstructorUsedError;
  DateTime get expireAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<ReactStoryModel> get reacts => throw _privateConstructorUsedError;
  @EmojiConverter()
  @JsonKey(name: 'isReact')
  EmojiType? get isReact => throw _privateConstructorUsedError;

  /// Serializes this StoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryModelCopyWith<StoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryModelCopyWith<$Res> {
  factory $StoryModelCopyWith(
    StoryModel value,
    $Res Function(StoryModel) then,
  ) = _$StoryModelCopyWithImpl<$Res, StoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String? title,
    String? mediaUrl,
    MediaType mediaType,
    DeezerMusicModel? music,
    @JsonKey(name: 'privacy_type') PrivacyType privacyType,
    @JsonKey(name: 'friends_except') List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') List<String> friendsDetail,
    DateTime expireAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ReactStoryModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
  });

  $UserModelCopyWith<$Res> get user;
  $DeezerMusicModelCopyWith<$Res>? get music;
}

/// @nodoc
class _$StoryModelCopyWithImpl<$Res, $Val extends StoryModel>
    implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? title = freezed,
    Object? mediaUrl = freezed,
    Object? mediaType = null,
    Object? music = freezed,
    Object? privacyType = null,
    Object? friendsExcept = null,
    Object? friendsDetail = null,
    Object? expireAt = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reacts = null,
    Object? isReact = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaUrl: freezed == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as MediaType,
            music: freezed == music
                ? _value.music
                : music // ignore: cast_nullable_to_non_nullable
                      as DeezerMusicModel?,
            privacyType: null == privacyType
                ? _value.privacyType
                : privacyType // ignore: cast_nullable_to_non_nullable
                      as PrivacyType,
            friendsExcept: null == friendsExcept
                ? _value.friendsExcept
                : friendsExcept // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            friendsDetail: null == friendsDetail
                ? _value.friendsDetail
                : friendsDetail // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            expireAt: null == expireAt
                ? _value.expireAt
                : expireAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reacts: null == reacts
                ? _value.reacts
                : reacts // ignore: cast_nullable_to_non_nullable
                      as List<ReactStoryModel>,
            isReact: freezed == isReact
                ? _value.isReact
                : isReact // ignore: cast_nullable_to_non_nullable
                      as EmojiType?,
          )
          as $Val,
    );
  }

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeezerMusicModelCopyWith<$Res>? get music {
    if (_value.music == null) {
      return null;
    }

    return $DeezerMusicModelCopyWith<$Res>(_value.music!, (value) {
      return _then(_value.copyWith(music: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoryModelImplCopyWith<$Res>
    implements $StoryModelCopyWith<$Res> {
  factory _$$StoryModelImplCopyWith(
    _$StoryModelImpl value,
    $Res Function(_$StoryModelImpl) then,
  ) = __$$StoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String? title,
    String? mediaUrl,
    MediaType mediaType,
    DeezerMusicModel? music,
    @JsonKey(name: 'privacy_type') PrivacyType privacyType,
    @JsonKey(name: 'friends_except') List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') List<String> friendsDetail,
    DateTime expireAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ReactStoryModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
  });

  @override
  $UserModelCopyWith<$Res> get user;
  @override
  $DeezerMusicModelCopyWith<$Res>? get music;
}

/// @nodoc
class __$$StoryModelImplCopyWithImpl<$Res>
    extends _$StoryModelCopyWithImpl<$Res, _$StoryModelImpl>
    implements _$$StoryModelImplCopyWith<$Res> {
  __$$StoryModelImplCopyWithImpl(
    _$StoryModelImpl _value,
    $Res Function(_$StoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? title = freezed,
    Object? mediaUrl = freezed,
    Object? mediaType = null,
    Object? music = freezed,
    Object? privacyType = null,
    Object? friendsExcept = null,
    Object? friendsDetail = null,
    Object? expireAt = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reacts = null,
    Object? isReact = freezed,
  }) {
    return _then(
      _$StoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaUrl: freezed == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as MediaType,
        music: freezed == music
            ? _value.music
            : music // ignore: cast_nullable_to_non_nullable
                  as DeezerMusicModel?,
        privacyType: null == privacyType
            ? _value.privacyType
            : privacyType // ignore: cast_nullable_to_non_nullable
                  as PrivacyType,
        friendsExcept: null == friendsExcept
            ? _value._friendsExcept
            : friendsExcept // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        friendsDetail: null == friendsDetail
            ? _value._friendsDetail
            : friendsDetail // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        expireAt: null == expireAt
            ? _value.expireAt
            : expireAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reacts: null == reacts
            ? _value._reacts
            : reacts // ignore: cast_nullable_to_non_nullable
                  as List<ReactStoryModel>,
        isReact: freezed == isReact
            ? _value.isReact
            : isReact // ignore: cast_nullable_to_non_nullable
                  as EmojiType?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryModelImpl implements _StoryModel {
  const _$StoryModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'userId') required this.user,
    this.title,
    this.mediaUrl,
    required this.mediaType,
    this.music,
    @JsonKey(name: 'privacy_type') this.privacyType = PrivacyType.public,
    @JsonKey(name: 'friends_except')
    final List<String> friendsExcept = const [],
    @JsonKey(name: 'friends_detail')
    final List<String> friendsDetail = const [],
    required this.expireAt,
    this.createdAt,
    this.updatedAt,
    final List<ReactStoryModel> reacts = const [],
    @EmojiConverter() @JsonKey(name: 'isReact') this.isReact,
  }) : _friendsExcept = friendsExcept,
       _friendsDetail = friendsDetail,
       _reacts = reacts;

  factory _$StoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  @override
  final String? title;
  @override
  final String? mediaUrl;
  @override
  final MediaType mediaType;
  @override
  final DeezerMusicModel? music;
  @override
  @JsonKey(name: 'privacy_type')
  final PrivacyType privacyType;
  final List<String> _friendsExcept;
  @override
  @JsonKey(name: 'friends_except')
  List<String> get friendsExcept {
    if (_friendsExcept is EqualUnmodifiableListView) return _friendsExcept;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendsExcept);
  }

  final List<String> _friendsDetail;
  @override
  @JsonKey(name: 'friends_detail')
  List<String> get friendsDetail {
    if (_friendsDetail is EqualUnmodifiableListView) return _friendsDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendsDetail);
  }

  @override
  final DateTime expireAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  final List<ReactStoryModel> _reacts;
  @override
  @JsonKey()
  List<ReactStoryModel> get reacts {
    if (_reacts is EqualUnmodifiableListView) return _reacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reacts);
  }

  @override
  @EmojiConverter()
  @JsonKey(name: 'isReact')
  final EmojiType? isReact;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.music, music) || other.music == music) &&
            (identical(other.privacyType, privacyType) ||
                other.privacyType == privacyType) &&
            const DeepCollectionEquality().equals(
              other._friendsExcept,
              _friendsExcept,
            ) &&
            const DeepCollectionEquality().equals(
              other._friendsDetail,
              _friendsDetail,
            ) &&
            (identical(other.expireAt, expireAt) ||
                other.expireAt == expireAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._reacts, _reacts) &&
            (identical(other.isReact, isReact) || other.isReact == isReact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    user,
    title,
    mediaUrl,
    mediaType,
    music,
    privacyType,
    const DeepCollectionEquality().hash(_friendsExcept),
    const DeepCollectionEquality().hash(_friendsDetail),
    expireAt,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_reacts),
    isReact,
  );

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryModelImplCopyWith<_$StoryModelImpl> get copyWith =>
      __$$StoryModelImplCopyWithImpl<_$StoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryModelImplToJson(this);
  }
}

abstract class _StoryModel implements StoryModel {
  const factory _StoryModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'userId') required final UserModel user,
    final String? title,
    final String? mediaUrl,
    required final MediaType mediaType,
    final DeezerMusicModel? music,
    @JsonKey(name: 'privacy_type') final PrivacyType privacyType,
    @JsonKey(name: 'friends_except') final List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') final List<String> friendsDetail,
    required final DateTime expireAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final List<ReactStoryModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') final EmojiType? isReact,
  }) = _$StoryModelImpl;

  factory _StoryModel.fromJson(Map<String, dynamic> json) =
      _$StoryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  String? get title;
  @override
  String? get mediaUrl;
  @override
  MediaType get mediaType;
  @override
  DeezerMusicModel? get music;
  @override
  @JsonKey(name: 'privacy_type')
  PrivacyType get privacyType;
  @override
  @JsonKey(name: 'friends_except')
  List<String> get friendsExcept;
  @override
  @JsonKey(name: 'friends_detail')
  List<String> get friendsDetail;
  @override
  DateTime get expireAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<ReactStoryModel> get reacts;
  @override
  @EmojiConverter()
  @JsonKey(name: 'isReact')
  EmojiType? get isReact;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryModelImplCopyWith<_$StoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
