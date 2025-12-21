// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'react_story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReactStoryModel _$ReactStoryModelFromJson(Map<String, dynamic> json) {
  return _ReactStoryModel.fromJson(json);
}

/// @nodoc
mixin _$ReactStoryModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'storyId')
  String get storyId => throw _privateConstructorUsedError;
  @EmojiConverter()
  @JsonKey(name: 'emojiId')
  EmojiType get emoji => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int? get mutualFriendsCount => throw _privateConstructorUsedError;
  bool? get isFriend => throw _privateConstructorUsedError;

  /// Serializes this ReactStoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactStoryModelCopyWith<ReactStoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactStoryModelCopyWith<$Res> {
  factory $ReactStoryModelCopyWith(
    ReactStoryModel value,
    $Res Function(ReactStoryModel) then,
  ) = _$ReactStoryModelCopyWithImpl<$Res, ReactStoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    @JsonKey(name: 'storyId') String storyId,
    @EmojiConverter() @JsonKey(name: 'emojiId') EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? mutualFriendsCount,
    bool? isFriend,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$ReactStoryModelCopyWithImpl<$Res, $Val extends ReactStoryModel>
    implements $ReactStoryModelCopyWith<$Res> {
  _$ReactStoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? storyId = null,
    Object? emoji = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mutualFriendsCount = freezed,
    Object? isFriend = freezed,
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
            storyId: null == storyId
                ? _value.storyId
                : storyId // ignore: cast_nullable_to_non_nullable
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
            mutualFriendsCount: freezed == mutualFriendsCount
                ? _value.mutualFriendsCount
                : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFriend: freezed == isFriend
                ? _value.isFriend
                : isFriend // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of ReactStoryModel
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
abstract class _$$ReactStoryModelImplCopyWith<$Res>
    implements $ReactStoryModelCopyWith<$Res> {
  factory _$$ReactStoryModelImplCopyWith(
    _$ReactStoryModelImpl value,
    $Res Function(_$ReactStoryModelImpl) then,
  ) = __$$ReactStoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    @JsonKey(name: 'storyId') String storyId,
    @EmojiConverter() @JsonKey(name: 'emojiId') EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? mutualFriendsCount,
    bool? isFriend,
  });

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$ReactStoryModelImplCopyWithImpl<$Res>
    extends _$ReactStoryModelCopyWithImpl<$Res, _$ReactStoryModelImpl>
    implements _$$ReactStoryModelImplCopyWith<$Res> {
  __$$ReactStoryModelImplCopyWithImpl(
    _$ReactStoryModelImpl _value,
    $Res Function(_$ReactStoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReactStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? storyId = null,
    Object? emoji = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mutualFriendsCount = freezed,
    Object? isFriend = freezed,
  }) {
    return _then(
      _$ReactStoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        storyId: null == storyId
            ? _value.storyId
            : storyId // ignore: cast_nullable_to_non_nullable
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
        mutualFriendsCount: freezed == mutualFriendsCount
            ? _value.mutualFriendsCount
            : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFriend: freezed == isFriend
            ? _value.isFriend
            : isFriend // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactStoryModelImpl implements _ReactStoryModel {
  const _$ReactStoryModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'userId') required this.user,
    @JsonKey(name: 'storyId') required this.storyId,
    @EmojiConverter() @JsonKey(name: 'emojiId') required this.emoji,
    this.createdAt,
    this.updatedAt,
    this.mutualFriendsCount,
    this.isFriend,
  });

  factory _$ReactStoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactStoryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  @override
  @JsonKey(name: 'storyId')
  final String storyId;
  @override
  @EmojiConverter()
  @JsonKey(name: 'emojiId')
  final EmojiType emoji;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final int? mutualFriendsCount;
  @override
  final bool? isFriend;

  @override
  String toString() {
    return 'ReactStoryModel(id: $id, user: $user, storyId: $storyId, emoji: $emoji, createdAt: $createdAt, updatedAt: $updatedAt, mutualFriendsCount: $mutualFriendsCount, isFriend: $isFriend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactStoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mutualFriendsCount, mutualFriendsCount) ||
                other.mutualFriendsCount == mutualFriendsCount) &&
            (identical(other.isFriend, isFriend) ||
                other.isFriend == isFriend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    user,
    storyId,
    emoji,
    createdAt,
    updatedAt,
    mutualFriendsCount,
    isFriend,
  );

  /// Create a copy of ReactStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactStoryModelImplCopyWith<_$ReactStoryModelImpl> get copyWith =>
      __$$ReactStoryModelImplCopyWithImpl<_$ReactStoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactStoryModelImplToJson(this);
  }
}

abstract class _ReactStoryModel implements ReactStoryModel {
  const factory _ReactStoryModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'userId') required final UserModel user,
    @JsonKey(name: 'storyId') required final String storyId,
    @EmojiConverter() @JsonKey(name: 'emojiId') required final EmojiType emoji,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final int? mutualFriendsCount,
    final bool? isFriend,
  }) = _$ReactStoryModelImpl;

  factory _ReactStoryModel.fromJson(Map<String, dynamic> json) =
      _$ReactStoryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  @JsonKey(name: 'storyId')
  String get storyId;
  @override
  @EmojiConverter()
  @JsonKey(name: 'emojiId')
  EmojiType get emoji;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int? get mutualFriendsCount;
  @override
  bool? get isFriend;

  /// Create a copy of ReactStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactStoryModelImplCopyWith<_$ReactStoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
