// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'react_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReactPostModel _$ReactPostModelFromJson(Map<String, dynamic> json) {
  return _ReactPostModel.fromJson(json);
}

/// @nodoc
mixin _$ReactPostModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  @EmojiConverter()
  @JsonKey(name: 'emojiId')
  EmojiType get emoji => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReactPostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactPostModelCopyWith<ReactPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactPostModelCopyWith<$Res> {
  factory $ReactPostModelCopyWith(
    ReactPostModel value,
    $Res Function(ReactPostModel) then,
  ) = _$ReactPostModelCopyWithImpl<$Res, ReactPostModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String postId,
    @EmojiConverter() @JsonKey(name: 'emojiId') EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$ReactPostModelCopyWithImpl<$Res, $Val extends ReactPostModel>
    implements $ReactPostModelCopyWith<$Res> {
  _$ReactPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? postId = null,
    Object? emoji = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as EmojiType,
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

  /// Create a copy of ReactPostModel
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
abstract class _$$ReactPostModelImplCopyWith<$Res>
    implements $ReactPostModelCopyWith<$Res> {
  factory _$$ReactPostModelImplCopyWith(
    _$ReactPostModelImpl value,
    $Res Function(_$ReactPostModelImpl) then,
  ) = __$$ReactPostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String postId,
    @EmojiConverter() @JsonKey(name: 'emojiId') EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$ReactPostModelImplCopyWithImpl<$Res>
    extends _$ReactPostModelCopyWithImpl<$Res, _$ReactPostModelImpl>
    implements _$$ReactPostModelImplCopyWith<$Res> {
  __$$ReactPostModelImplCopyWithImpl(
    _$ReactPostModelImpl _value,
    $Res Function(_$ReactPostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReactPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? postId = null,
    Object? emoji = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ReactPostModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as EmojiType,
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
class _$ReactPostModelImpl implements _ReactPostModel {
  const _$ReactPostModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'userId') required this.user,
    required this.postId,
    @EmojiConverter() @JsonKey(name: 'emojiId') required this.emoji,
    this.createdAt,
    this.updatedAt,
  });

  factory _$ReactPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactPostModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  @override
  final String postId;
  @override
  @EmojiConverter()
  @JsonKey(name: 'emojiId')
  final EmojiType emoji;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReactPostModel(id: $id, user: $user, postId: $postId, emoji: $emoji, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactPostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, user, postId, emoji, createdAt, updatedAt);

  /// Create a copy of ReactPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactPostModelImplCopyWith<_$ReactPostModelImpl> get copyWith =>
      __$$ReactPostModelImplCopyWithImpl<_$ReactPostModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactPostModelImplToJson(this);
  }
}

abstract class _ReactPostModel implements ReactPostModel {
  const factory _ReactPostModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'userId') required final UserModel user,
    required final String postId,
    @EmojiConverter() @JsonKey(name: 'emojiId') required final EmojiType emoji,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ReactPostModelImpl;

  factory _ReactPostModel.fromJson(Map<String, dynamic> json) =
      _$ReactPostModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  String get postId;
  @override
  @EmojiConverter()
  @JsonKey(name: 'emojiId')
  EmojiType get emoji;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ReactPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactPostModelImplCopyWith<_$ReactPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
