// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PrivacyModel _$PrivacyModelFromJson(Map<String, dynamic> json) {
  return _PrivacyModel.fromJson(json);
}

/// @nodoc
mixin _$PrivacyModel {
  @JsonKey(name: 'userId')
  UserModel? get user => throw _privateConstructorUsedError;
  PrivacyType get defaultPrivacy => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_except')
  List<UserModel>? get friendsExcept => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_detail')
  List<UserModel>? get friendsDetail => throw _privateConstructorUsedError;

  /// Serializes this PrivacyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacyModelCopyWith<PrivacyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyModelCopyWith<$Res> {
  factory $PrivacyModelCopyWith(
    PrivacyModel value,
    $Res Function(PrivacyModel) then,
  ) = _$PrivacyModelCopyWithImpl<$Res, PrivacyModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'userId') UserModel? user,
    PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') List<UserModel>? friendsExcept,
    @JsonKey(name: 'friends_detail') List<UserModel>? friendsDetail,
  });

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$PrivacyModelCopyWithImpl<$Res, $Val extends PrivacyModel>
    implements $PrivacyModelCopyWith<$Res> {
  _$PrivacyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? defaultPrivacy = null,
    Object? friendsExcept = freezed,
    Object? friendsDetail = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            defaultPrivacy: null == defaultPrivacy
                ? _value.defaultPrivacy
                : defaultPrivacy // ignore: cast_nullable_to_non_nullable
                      as PrivacyType,
            friendsExcept: freezed == friendsExcept
                ? _value.friendsExcept
                : friendsExcept // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>?,
            friendsDetail: freezed == friendsDetail
                ? _value.friendsDetail
                : friendsDetail // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of PrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrivacyModelImplCopyWith<$Res>
    implements $PrivacyModelCopyWith<$Res> {
  factory _$$PrivacyModelImplCopyWith(
    _$PrivacyModelImpl value,
    $Res Function(_$PrivacyModelImpl) then,
  ) = __$$PrivacyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'userId') UserModel? user,
    PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') List<UserModel>? friendsExcept,
    @JsonKey(name: 'friends_detail') List<UserModel>? friendsDetail,
  });

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$PrivacyModelImplCopyWithImpl<$Res>
    extends _$PrivacyModelCopyWithImpl<$Res, _$PrivacyModelImpl>
    implements _$$PrivacyModelImplCopyWith<$Res> {
  __$$PrivacyModelImplCopyWithImpl(
    _$PrivacyModelImpl _value,
    $Res Function(_$PrivacyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? defaultPrivacy = null,
    Object? friendsExcept = freezed,
    Object? friendsDetail = freezed,
  }) {
    return _then(
      _$PrivacyModelImpl(
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        defaultPrivacy: null == defaultPrivacy
            ? _value.defaultPrivacy
            : defaultPrivacy // ignore: cast_nullable_to_non_nullable
                  as PrivacyType,
        friendsExcept: freezed == friendsExcept
            ? _value._friendsExcept
            : friendsExcept // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>?,
        friendsDetail: freezed == friendsDetail
            ? _value._friendsDetail
            : friendsDetail // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyModelImpl implements _PrivacyModel {
  const _$PrivacyModelImpl({
    @JsonKey(name: 'userId') this.user,
    required this.defaultPrivacy,
    @JsonKey(name: 'friends_except')
    final List<UserModel>? friendsExcept = const [],
    @JsonKey(name: 'friends_detail')
    final List<UserModel>? friendsDetail = const [],
  }) : _friendsExcept = friendsExcept,
       _friendsDetail = friendsDetail;

  factory _$PrivacyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyModelImplFromJson(json);

  @override
  @JsonKey(name: 'userId')
  final UserModel? user;
  @override
  final PrivacyType defaultPrivacy;
  final List<UserModel>? _friendsExcept;
  @override
  @JsonKey(name: 'friends_except')
  List<UserModel>? get friendsExcept {
    final value = _friendsExcept;
    if (value == null) return null;
    if (_friendsExcept is EqualUnmodifiableListView) return _friendsExcept;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<UserModel>? _friendsDetail;
  @override
  @JsonKey(name: 'friends_detail')
  List<UserModel>? get friendsDetail {
    final value = _friendsDetail;
    if (value == null) return null;
    if (_friendsDetail is EqualUnmodifiableListView) return _friendsDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PrivacyModel(user: $user, defaultPrivacy: $defaultPrivacy, friendsExcept: $friendsExcept, friendsDetail: $friendsDetail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.defaultPrivacy, defaultPrivacy) ||
                other.defaultPrivacy == defaultPrivacy) &&
            const DeepCollectionEquality().equals(
              other._friendsExcept,
              _friendsExcept,
            ) &&
            const DeepCollectionEquality().equals(
              other._friendsDetail,
              _friendsDetail,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    defaultPrivacy,
    const DeepCollectionEquality().hash(_friendsExcept),
    const DeepCollectionEquality().hash(_friendsDetail),
  );

  /// Create a copy of PrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyModelImplCopyWith<_$PrivacyModelImpl> get copyWith =>
      __$$PrivacyModelImplCopyWithImpl<_$PrivacyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyModelImplToJson(this);
  }
}

abstract class _PrivacyModel implements PrivacyModel {
  const factory _PrivacyModel({
    @JsonKey(name: 'userId') final UserModel? user,
    required final PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') final List<UserModel>? friendsExcept,
    @JsonKey(name: 'friends_detail') final List<UserModel>? friendsDetail,
  }) = _$PrivacyModelImpl;

  factory _PrivacyModel.fromJson(Map<String, dynamic> json) =
      _$PrivacyModelImpl.fromJson;

  @override
  @JsonKey(name: 'userId')
  UserModel? get user;
  @override
  PrivacyType get defaultPrivacy;
  @override
  @JsonKey(name: 'friends_except')
  List<UserModel>? get friendsExcept;
  @override
  @JsonKey(name: 'friends_detail')
  List<UserModel>? get friendsDetail;

  /// Create a copy of PrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyModelImplCopyWith<_$PrivacyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
