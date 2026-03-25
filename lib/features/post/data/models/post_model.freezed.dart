// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  List<PostUrlModel> get urls => throw _privateConstructorUsedError;
  String get layout => throw _privateConstructorUsedError;
  List<ReactPostModel> get reacts => throw _privateConstructorUsedError;
  @EmojiConverter()
  @JsonKey(name: 'isReact')
  EmojiType? get isReact => throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy_type')
  PrivacyType get privacyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_except')
  List<String> get friendsExcept => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_detail')
  List<String> get friendsDetail => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String? caption,
    @JsonKey(name: 'userId') UserModel user,
    List<PostUrlModel> urls,
    String layout,
    List<ReactPostModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
    @JsonKey(name: 'privacy_type') PrivacyType privacyType,
    @JsonKey(name: 'friends_except') List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') List<String> friendsDetail,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = freezed,
    Object? user = null,
    Object? urls = null,
    Object? layout = null,
    Object? reacts = null,
    Object? isReact = freezed,
    Object? privacyType = null,
    Object? friendsExcept = null,
    Object? friendsDetail = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            urls: null == urls
                ? _value.urls
                : urls // ignore: cast_nullable_to_non_nullable
                      as List<PostUrlModel>,
            layout: null == layout
                ? _value.layout
                : layout // ignore: cast_nullable_to_non_nullable
                      as String,
            reacts: null == reacts
                ? _value.reacts
                : reacts // ignore: cast_nullable_to_non_nullable
                      as List<ReactPostModel>,
            isReact: freezed == isReact
                ? _value.isReact
                : isReact // ignore: cast_nullable_to_non_nullable
                      as EmojiType?,
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
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
    _$PostModelImpl value,
    $Res Function(_$PostModelImpl) then,
  ) = __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String? caption,
    @JsonKey(name: 'userId') UserModel user,
    List<PostUrlModel> urls,
    String layout,
    List<ReactPostModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
    @JsonKey(name: 'privacy_type') PrivacyType privacyType,
    @JsonKey(name: 'friends_except') List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') List<String> friendsDetail,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
    _$PostModelImpl _value,
    $Res Function(_$PostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = freezed,
    Object? user = null,
    Object? urls = null,
    Object? layout = null,
    Object? reacts = null,
    Object? isReact = freezed,
    Object? privacyType = null,
    Object? friendsExcept = null,
    Object? friendsDetail = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PostModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        urls: null == urls
            ? _value._urls
            : urls // ignore: cast_nullable_to_non_nullable
                  as List<PostUrlModel>,
        layout: null == layout
            ? _value.layout
            : layout // ignore: cast_nullable_to_non_nullable
                  as String,
        reacts: null == reacts
            ? _value._reacts
            : reacts // ignore: cast_nullable_to_non_nullable
                  as List<ReactPostModel>,
        isReact: freezed == isReact
            ? _value.isReact
            : isReact // ignore: cast_nullable_to_non_nullable
                  as EmojiType?,
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
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl({
    @JsonKey(name: '_id') required this.id,
    this.caption,
    @JsonKey(name: 'userId') required this.user,
    required final List<PostUrlModel> urls,
    required this.layout,
    final List<ReactPostModel> reacts = const [],
    @EmojiConverter() @JsonKey(name: 'isReact') this.isReact,
    @JsonKey(name: 'privacy_type') this.privacyType = PrivacyType.public,
    @JsonKey(name: 'friends_except')
    final List<String> friendsExcept = const [],
    @JsonKey(name: 'friends_detail')
    final List<String> friendsDetail = const [],
    this.createdAt,
    this.updatedAt,
  }) : _urls = urls,
       _reacts = reacts,
       _friendsExcept = friendsExcept,
       _friendsDetail = friendsDetail;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String? caption;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  final List<PostUrlModel> _urls;
  @override
  List<PostUrlModel> get urls {
    if (_urls is EqualUnmodifiableListView) return _urls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urls);
  }

  @override
  final String layout;
  final List<ReactPostModel> _reacts;
  @override
  @JsonKey()
  List<ReactPostModel> get reacts {
    if (_reacts is EqualUnmodifiableListView) return _reacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reacts);
  }

  @override
  @EmojiConverter()
  @JsonKey(name: 'isReact')
  final EmojiType? isReact;
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
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._urls, _urls) &&
            (identical(other.layout, layout) || other.layout == layout) &&
            const DeepCollectionEquality().equals(other._reacts, _reacts) &&
            (identical(other.isReact, isReact) || other.isReact == isReact) &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    caption,
    user,
    const DeepCollectionEquality().hash(_urls),
    layout,
    const DeepCollectionEquality().hash(_reacts),
    isReact,
    privacyType,
    const DeepCollectionEquality().hash(_friendsExcept),
    const DeepCollectionEquality().hash(_friendsDetail),
    createdAt,
    updatedAt,
  );

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(this);
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel({
    @JsonKey(name: '_id') required final String id,
    final String? caption,
    @JsonKey(name: 'userId') required final UserModel user,
    required final List<PostUrlModel> urls,
    required final String layout,
    final List<ReactPostModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') final EmojiType? isReact,
    @JsonKey(name: 'privacy_type') final PrivacyType privacyType,
    @JsonKey(name: 'friends_except') final List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') final List<String> friendsDetail,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String? get caption;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  List<PostUrlModel> get urls;
  @override
  String get layout;
  @override
  List<ReactPostModel> get reacts;
  @override
  @EmojiConverter()
  @JsonKey(name: 'isReact')
  EmojiType? get isReact;
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
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
