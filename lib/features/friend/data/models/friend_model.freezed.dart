// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) {
  return _FriendModel.fromJson(json);
}

/// @nodoc
mixin _$FriendModel {
  @JsonKey(name: '_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get bio => throw _privateConstructorUsedError;

  /// Serializes this FriendModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendModelCopyWith<FriendModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendModelCopyWith<$Res> {
  factory $FriendModelCopyWith(
    FriendModel value,
    $Res Function(FriendModel) then,
  ) = _$FriendModelCopyWithImpl<$Res, FriendModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? bio,
  });
}

/// @nodoc
class _$FriendModelCopyWithImpl<$Res, $Val extends FriendModel>
    implements $FriendModelCopyWith<$Res> {
  _$FriendModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = freezed,
    Object? username = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendModelImplCopyWith<$Res>
    implements $FriendModelCopyWith<$Res> {
  factory _$$FriendModelImplCopyWith(
    _$FriendModelImpl value,
    $Res Function(_$FriendModelImpl) then,
  ) = __$$FriendModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? bio,
  });
}

/// @nodoc
class __$$FriendModelImplCopyWithImpl<$Res>
    extends _$FriendModelCopyWithImpl<$Res, _$FriendModelImpl>
    implements _$$FriendModelImplCopyWith<$Res> {
  __$$FriendModelImplCopyWithImpl(
    _$FriendModelImpl _value,
    $Res Function(_$FriendModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = freezed,
    Object? username = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
  }) {
    return _then(
      _$FriendModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendModelImpl implements _FriendModel {
  const _$FriendModelImpl({
    @JsonKey(name: '_id') required this.userId,
    @JsonKey(includeIfNull: false) this.fullName,
    @JsonKey(includeIfNull: false) this.username,
    @JsonKey(includeIfNull: false) this.avatarUrl,
    @JsonKey(includeIfNull: false) this.bio,
  });

  factory _$FriendModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String userId;
  @override
  @JsonKey(includeIfNull: false)
  final String? fullName;
  @override
  @JsonKey(includeIfNull: false)
  final String? username;
  @override
  @JsonKey(includeIfNull: false)
  final String? avatarUrl;
  @override
  @JsonKey(includeIfNull: false)
  final String? bio;

  @override
  String toString() {
    return 'FriendModel(userId: $userId, fullName: $fullName, username: $username, avatarUrl: $avatarUrl, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, fullName, username, avatarUrl, bio);

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendModelImplCopyWith<_$FriendModelImpl> get copyWith =>
      __$$FriendModelImplCopyWithImpl<_$FriendModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendModelImplToJson(this);
  }
}

abstract class _FriendModel implements FriendModel {
  const factory _FriendModel({
    @JsonKey(name: '_id') required final String userId,
    @JsonKey(includeIfNull: false) final String? fullName,
    @JsonKey(includeIfNull: false) final String? username,
    @JsonKey(includeIfNull: false) final String? avatarUrl,
    @JsonKey(includeIfNull: false) final String? bio,
  }) = _$FriendModelImpl;

  factory _FriendModel.fromJson(Map<String, dynamic> json) =
      _$FriendModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get userId;
  @override
  @JsonKey(includeIfNull: false)
  String? get fullName;
  @override
  @JsonKey(includeIfNull: false)
  String? get username;
  @override
  @JsonKey(includeIfNull: false)
  String? get avatarUrl;
  @override
  @JsonKey(includeIfNull: false)
  String? get bio;

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendModelImplCopyWith<_$FriendModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
