// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_suggestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FriendSuggestionModel {
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
  @JsonKey(includeIfNull: false)
  int? get mutualFriends => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get mutualFriendAvatars => throw _privateConstructorUsedError;

  /// Create a copy of FriendSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendSuggestionModelCopyWith<FriendSuggestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendSuggestionModelCopyWith<$Res> {
  factory $FriendSuggestionModelCopyWith(
    FriendSuggestionModel value,
    $Res Function(FriendSuggestionModel) then,
  ) = _$FriendSuggestionModelCopyWithImpl<$Res, FriendSuggestionModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? bio,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(includeIfNull: false) String? reason,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  });
}

/// @nodoc
class _$FriendSuggestionModelCopyWithImpl<
  $Res,
  $Val extends FriendSuggestionModel
>
    implements $FriendSuggestionModelCopyWith<$Res> {
  _$FriendSuggestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = freezed,
    Object? username = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? mutualFriends = freezed,
    Object? reason = freezed,
    Object? mutualFriendAvatars = freezed,
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
            mutualFriends: freezed == mutualFriends
                ? _value.mutualFriends
                : mutualFriends // ignore: cast_nullable_to_non_nullable
                      as int?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            mutualFriendAvatars: freezed == mutualFriendAvatars
                ? _value.mutualFriendAvatars
                : mutualFriendAvatars // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendSuggestionModelImplCopyWith<$Res>
    implements $FriendSuggestionModelCopyWith<$Res> {
  factory _$$FriendSuggestionModelImplCopyWith(
    _$FriendSuggestionModelImpl value,
    $Res Function(_$FriendSuggestionModelImpl) then,
  ) = __$$FriendSuggestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? bio,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(includeIfNull: false) String? reason,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  });
}

/// @nodoc
class __$$FriendSuggestionModelImplCopyWithImpl<$Res>
    extends
        _$FriendSuggestionModelCopyWithImpl<$Res, _$FriendSuggestionModelImpl>
    implements _$$FriendSuggestionModelImplCopyWith<$Res> {
  __$$FriendSuggestionModelImplCopyWithImpl(
    _$FriendSuggestionModelImpl _value,
    $Res Function(_$FriendSuggestionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = freezed,
    Object? username = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? mutualFriends = freezed,
    Object? reason = freezed,
    Object? mutualFriendAvatars = freezed,
  }) {
    return _then(
      _$FriendSuggestionModelImpl(
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
        mutualFriends: freezed == mutualFriends
            ? _value.mutualFriends
            : mutualFriends // ignore: cast_nullable_to_non_nullable
                  as int?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        mutualFriendAvatars: freezed == mutualFriendAvatars
            ? _value._mutualFriendAvatars
            : mutualFriendAvatars // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$FriendSuggestionModelImpl implements _FriendSuggestionModel {
  const _$FriendSuggestionModelImpl({
    @JsonKey(name: '_id') required this.userId,
    @JsonKey(includeIfNull: false) this.fullName,
    @JsonKey(includeIfNull: false) this.username,
    @JsonKey(includeIfNull: false) this.avatarUrl,
    @JsonKey(includeIfNull: false) this.bio,
    @JsonKey(includeIfNull: false) this.mutualFriends,
    @JsonKey(includeIfNull: false) this.reason,
    @JsonKey(includeIfNull: false) final List<String>? mutualFriendAvatars,
  }) : _mutualFriendAvatars = mutualFriendAvatars;

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
  @JsonKey(includeIfNull: false)
  final int? mutualFriends;
  @override
  @JsonKey(includeIfNull: false)
  final String? reason;
  final List<String>? _mutualFriendAvatars;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get mutualFriendAvatars {
    final value = _mutualFriendAvatars;
    if (value == null) return null;
    if (_mutualFriendAvatars is EqualUnmodifiableListView)
      return _mutualFriendAvatars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FriendSuggestionModel(userId: $userId, fullName: $fullName, username: $username, avatarUrl: $avatarUrl, bio: $bio, mutualFriends: $mutualFriends, reason: $reason, mutualFriendAvatars: $mutualFriendAvatars)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendSuggestionModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.mutualFriends, mutualFriends) ||
                other.mutualFriends == mutualFriends) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(
              other._mutualFriendAvatars,
              _mutualFriendAvatars,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    fullName,
    username,
    avatarUrl,
    bio,
    mutualFriends,
    reason,
    const DeepCollectionEquality().hash(_mutualFriendAvatars),
  );

  /// Create a copy of FriendSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendSuggestionModelImplCopyWith<_$FriendSuggestionModelImpl>
  get copyWith =>
      __$$FriendSuggestionModelImplCopyWithImpl<_$FriendSuggestionModelImpl>(
        this,
        _$identity,
      );
}

abstract class _FriendSuggestionModel implements FriendSuggestionModel {
  const factory _FriendSuggestionModel({
    @JsonKey(name: '_id') required final String userId,
    @JsonKey(includeIfNull: false) final String? fullName,
    @JsonKey(includeIfNull: false) final String? username,
    @JsonKey(includeIfNull: false) final String? avatarUrl,
    @JsonKey(includeIfNull: false) final String? bio,
    @JsonKey(includeIfNull: false) final int? mutualFriends,
    @JsonKey(includeIfNull: false) final String? reason,
    @JsonKey(includeIfNull: false) final List<String>? mutualFriendAvatars,
  }) = _$FriendSuggestionModelImpl;

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
  @override
  @JsonKey(includeIfNull: false)
  int? get mutualFriends;
  @override
  @JsonKey(includeIfNull: false)
  String? get reason;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get mutualFriendAvatars;

  /// Create a copy of FriendSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendSuggestionModelImplCopyWith<_$FriendSuggestionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
