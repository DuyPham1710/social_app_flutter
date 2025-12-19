// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'react_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReactCommentModel _$ReactCommentModelFromJson(Map<String, dynamic> json) {
  return _ReactCommentModel.fromJson(json);
}

/// @nodoc
mixin _$ReactCommentModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  String get commentId => throw _privateConstructorUsedError;
  @CommentEmojiConverter()
  @JsonKey(name: 'emojiId')
  EmojiType get emoji => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int? get mutualFriendsCount => throw _privateConstructorUsedError;
  bool? get isFriend => throw _privateConstructorUsedError;

  /// Serializes this ReactCommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactCommentModelCopyWith<ReactCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactCommentModelCopyWith<$Res> {
  factory $ReactCommentModelCopyWith(
    ReactCommentModel value,
    $Res Function(ReactCommentModel) then,
  ) = _$ReactCommentModelCopyWithImpl<$Res, ReactCommentModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String commentId,
    @CommentEmojiConverter() @JsonKey(name: 'emojiId') EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? mutualFriendsCount,
    bool? isFriend,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$ReactCommentModelCopyWithImpl<$Res, $Val extends ReactCommentModel>
    implements $ReactCommentModelCopyWith<$Res> {
  _$ReactCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? commentId = null,
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
            commentId: null == commentId
                ? _value.commentId
                : commentId // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of ReactCommentModel
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
abstract class _$$ReactCommentModelImplCopyWith<$Res>
    implements $ReactCommentModelCopyWith<$Res> {
  factory _$$ReactCommentModelImplCopyWith(
    _$ReactCommentModelImpl value,
    $Res Function(_$ReactCommentModelImpl) then,
  ) = __$$ReactCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String commentId,
    @CommentEmojiConverter() @JsonKey(name: 'emojiId') EmojiType emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? mutualFriendsCount,
    bool? isFriend,
  });

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$ReactCommentModelImplCopyWithImpl<$Res>
    extends _$ReactCommentModelCopyWithImpl<$Res, _$ReactCommentModelImpl>
    implements _$$ReactCommentModelImplCopyWith<$Res> {
  __$$ReactCommentModelImplCopyWithImpl(
    _$ReactCommentModelImpl _value,
    $Res Function(_$ReactCommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReactCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? commentId = null,
    Object? emoji = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mutualFriendsCount = freezed,
    Object? isFriend = freezed,
  }) {
    return _then(
      _$ReactCommentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        commentId: null == commentId
            ? _value.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
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
class _$ReactCommentModelImpl implements _ReactCommentModel {
  const _$ReactCommentModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'userId') required this.user,
    required this.commentId,
    @CommentEmojiConverter() @JsonKey(name: 'emojiId') required this.emoji,
    this.createdAt,
    this.updatedAt,
    this.mutualFriendsCount,
    this.isFriend,
  });

  factory _$ReactCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactCommentModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  @override
  final String commentId;
  @override
  @CommentEmojiConverter()
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
    return 'ReactCommentModel(id: $id, user: $user, commentId: $commentId, emoji: $emoji, createdAt: $createdAt, updatedAt: $updatedAt, mutualFriendsCount: $mutualFriendsCount, isFriend: $isFriend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactCommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
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
    commentId,
    emoji,
    createdAt,
    updatedAt,
    mutualFriendsCount,
    isFriend,
  );

  /// Create a copy of ReactCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactCommentModelImplCopyWith<_$ReactCommentModelImpl> get copyWith =>
      __$$ReactCommentModelImplCopyWithImpl<_$ReactCommentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactCommentModelImplToJson(this);
  }
}

abstract class _ReactCommentModel implements ReactCommentModel {
  const factory _ReactCommentModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'userId') required final UserModel user,
    required final String commentId,
    @CommentEmojiConverter()
    @JsonKey(name: 'emojiId')
    required final EmojiType emoji,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final int? mutualFriendsCount,
    final bool? isFriend,
  }) = _$ReactCommentModelImpl;

  factory _ReactCommentModel.fromJson(Map<String, dynamic> json) =
      _$ReactCommentModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  String get commentId;
  @override
  @CommentEmojiConverter()
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

  /// Create a copy of ReactCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactCommentModelImplCopyWith<_$ReactCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
