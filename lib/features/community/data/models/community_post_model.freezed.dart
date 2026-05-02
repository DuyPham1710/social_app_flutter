// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommunityPostModel _$CommunityPostModelFromJson(Map<String, dynamic> json) {
  return _CommunityPostModel.fromJson(json);
}

/// @nodoc
mixin _$CommunityPostModel {
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
  @JsonKey(name: 'communityStatus')
  String? get communityStatus => throw _privateConstructorUsedError; // 'pending', 'approved', 'rejected'
  @JsonKey(name: 'communityId')
  CommunityRefModel get community => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CommunityPostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityPostModelCopyWith<CommunityPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityPostModelCopyWith<$Res> {
  factory $CommunityPostModelCopyWith(
    CommunityPostModel value,
    $Res Function(CommunityPostModel) then,
  ) = _$CommunityPostModelCopyWithImpl<$Res, CommunityPostModel>;
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
    @JsonKey(name: 'communityStatus') String? communityStatus,
    @JsonKey(name: 'communityId') CommunityRefModel community,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $UserModelCopyWith<$Res> get user;
  $CommunityRefModelCopyWith<$Res> get community;
}

/// @nodoc
class _$CommunityPostModelCopyWithImpl<$Res, $Val extends CommunityPostModel>
    implements $CommunityPostModelCopyWith<$Res> {
  _$CommunityPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityPostModel
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
    Object? communityStatus = freezed,
    Object? community = null,
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
            communityStatus: freezed == communityStatus
                ? _value.communityStatus
                : communityStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            community: null == community
                ? _value.community
                : community // ignore: cast_nullable_to_non_nullable
                      as CommunityRefModel,
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

  /// Create a copy of CommunityPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of CommunityPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunityRefModelCopyWith<$Res> get community {
    return $CommunityRefModelCopyWith<$Res>(_value.community, (value) {
      return _then(_value.copyWith(community: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommunityPostModelImplCopyWith<$Res>
    implements $CommunityPostModelCopyWith<$Res> {
  factory _$$CommunityPostModelImplCopyWith(
    _$CommunityPostModelImpl value,
    $Res Function(_$CommunityPostModelImpl) then,
  ) = __$$CommunityPostModelImplCopyWithImpl<$Res>;
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
    @JsonKey(name: 'communityStatus') String? communityStatus,
    @JsonKey(name: 'communityId') CommunityRefModel community,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $UserModelCopyWith<$Res> get user;
  @override
  $CommunityRefModelCopyWith<$Res> get community;
}

/// @nodoc
class __$$CommunityPostModelImplCopyWithImpl<$Res>
    extends _$CommunityPostModelCopyWithImpl<$Res, _$CommunityPostModelImpl>
    implements _$$CommunityPostModelImplCopyWith<$Res> {
  __$$CommunityPostModelImplCopyWithImpl(
    _$CommunityPostModelImpl _value,
    $Res Function(_$CommunityPostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityPostModel
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
    Object? communityStatus = freezed,
    Object? community = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CommunityPostModelImpl(
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
        communityStatus: freezed == communityStatus
            ? _value.communityStatus
            : communityStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        community: null == community
            ? _value.community
            : community // ignore: cast_nullable_to_non_nullable
                  as CommunityRefModel,
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
class _$CommunityPostModelImpl implements _CommunityPostModel {
  const _$CommunityPostModelImpl({
    @JsonKey(name: '_id') required this.id,
    this.caption,
    @JsonKey(name: 'userId') required this.user,
    required final List<PostUrlModel> urls,
    required this.layout,
    final List<ReactPostModel> reacts = const [],
    @EmojiConverter() @JsonKey(name: 'isReact') this.isReact,
    @JsonKey(name: 'privacy_type') this.privacyType = PrivacyType.public,
    @JsonKey(name: 'communityStatus') this.communityStatus,
    @JsonKey(name: 'communityId') required this.community,
    this.createdAt,
    this.updatedAt,
  }) : _urls = urls,
       _reacts = reacts;

  factory _$CommunityPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityPostModelImplFromJson(json);

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
  @override
  @JsonKey(name: 'communityStatus')
  final String? communityStatus;
  // 'pending', 'approved', 'rejected'
  @override
  @JsonKey(name: 'communityId')
  final CommunityRefModel community;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CommunityPostModel(id: $id, caption: $caption, user: $user, urls: $urls, layout: $layout, reacts: $reacts, isReact: $isReact, privacyType: $privacyType, communityStatus: $communityStatus, community: $community, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityPostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._urls, _urls) &&
            (identical(other.layout, layout) || other.layout == layout) &&
            const DeepCollectionEquality().equals(other._reacts, _reacts) &&
            (identical(other.isReact, isReact) || other.isReact == isReact) &&
            (identical(other.privacyType, privacyType) ||
                other.privacyType == privacyType) &&
            (identical(other.communityStatus, communityStatus) ||
                other.communityStatus == communityStatus) &&
            (identical(other.community, community) ||
                other.community == community) &&
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
    communityStatus,
    community,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CommunityPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityPostModelImplCopyWith<_$CommunityPostModelImpl> get copyWith =>
      __$$CommunityPostModelImplCopyWithImpl<_$CommunityPostModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityPostModelImplToJson(this);
  }
}

abstract class _CommunityPostModel implements CommunityPostModel {
  const factory _CommunityPostModel({
    @JsonKey(name: '_id') required final String id,
    final String? caption,
    @JsonKey(name: 'userId') required final UserModel user,
    required final List<PostUrlModel> urls,
    required final String layout,
    final List<ReactPostModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') final EmojiType? isReact,
    @JsonKey(name: 'privacy_type') final PrivacyType privacyType,
    @JsonKey(name: 'communityStatus') final String? communityStatus,
    @JsonKey(name: 'communityId') required final CommunityRefModel community,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CommunityPostModelImpl;

  factory _CommunityPostModel.fromJson(Map<String, dynamic> json) =
      _$CommunityPostModelImpl.fromJson;

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
  @JsonKey(name: 'communityStatus')
  String? get communityStatus; // 'pending', 'approved', 'rejected'
  @override
  @JsonKey(name: 'communityId')
  CommunityRefModel get community;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CommunityPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityPostModelImplCopyWith<_$CommunityPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
