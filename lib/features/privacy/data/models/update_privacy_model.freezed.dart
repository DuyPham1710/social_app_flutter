// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_privacy_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdatePrivacyModel _$UpdatePrivacyModelFromJson(Map<String, dynamic> json) {
  return _UpdatePrivacyModel.fromJson(json);
}

/// @nodoc
mixin _$UpdatePrivacyModel {
  PrivacyType get defaultPrivacy => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_except')
  List<String>? get friendsExcept => throw _privateConstructorUsedError;
  @JsonKey(name: 'friends_detail')
  List<String>? get friendsDetail => throw _privateConstructorUsedError;

  /// Serializes this UpdatePrivacyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePrivacyModelCopyWith<UpdatePrivacyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePrivacyModelCopyWith<$Res> {
  factory $UpdatePrivacyModelCopyWith(
    UpdatePrivacyModel value,
    $Res Function(UpdatePrivacyModel) then,
  ) = _$UpdatePrivacyModelCopyWithImpl<$Res, UpdatePrivacyModel>;
  @useResult
  $Res call({
    PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') List<String>? friendsExcept,
    @JsonKey(name: 'friends_detail') List<String>? friendsDetail,
  });
}

/// @nodoc
class _$UpdatePrivacyModelCopyWithImpl<$Res, $Val extends UpdatePrivacyModel>
    implements $UpdatePrivacyModelCopyWith<$Res> {
  _$UpdatePrivacyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultPrivacy = null,
    Object? friendsExcept = freezed,
    Object? friendsDetail = freezed,
  }) {
    return _then(
      _value.copyWith(
            defaultPrivacy: null == defaultPrivacy
                ? _value.defaultPrivacy
                : defaultPrivacy // ignore: cast_nullable_to_non_nullable
                      as PrivacyType,
            friendsExcept: freezed == friendsExcept
                ? _value.friendsExcept
                : friendsExcept // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            friendsDetail: freezed == friendsDetail
                ? _value.friendsDetail
                : friendsDetail // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdatePrivacyModelImplCopyWith<$Res>
    implements $UpdatePrivacyModelCopyWith<$Res> {
  factory _$$UpdatePrivacyModelImplCopyWith(
    _$UpdatePrivacyModelImpl value,
    $Res Function(_$UpdatePrivacyModelImpl) then,
  ) = __$$UpdatePrivacyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') List<String>? friendsExcept,
    @JsonKey(name: 'friends_detail') List<String>? friendsDetail,
  });
}

/// @nodoc
class __$$UpdatePrivacyModelImplCopyWithImpl<$Res>
    extends _$UpdatePrivacyModelCopyWithImpl<$Res, _$UpdatePrivacyModelImpl>
    implements _$$UpdatePrivacyModelImplCopyWith<$Res> {
  __$$UpdatePrivacyModelImplCopyWithImpl(
    _$UpdatePrivacyModelImpl _value,
    $Res Function(_$UpdatePrivacyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdatePrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultPrivacy = null,
    Object? friendsExcept = freezed,
    Object? friendsDetail = freezed,
  }) {
    return _then(
      _$UpdatePrivacyModelImpl(
        defaultPrivacy: null == defaultPrivacy
            ? _value.defaultPrivacy
            : defaultPrivacy // ignore: cast_nullable_to_non_nullable
                  as PrivacyType,
        friendsExcept: freezed == friendsExcept
            ? _value._friendsExcept
            : friendsExcept // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        friendsDetail: freezed == friendsDetail
            ? _value._friendsDetail
            : friendsDetail // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePrivacyModelImpl implements _UpdatePrivacyModel {
  const _$UpdatePrivacyModelImpl({
    required this.defaultPrivacy,
    @JsonKey(name: 'friends_except')
    final List<String>? friendsExcept = const [],
    @JsonKey(name: 'friends_detail')
    final List<String>? friendsDetail = const [],
  }) : _friendsExcept = friendsExcept,
       _friendsDetail = friendsDetail;

  factory _$UpdatePrivacyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePrivacyModelImplFromJson(json);

  @override
  final PrivacyType defaultPrivacy;
  final List<String>? _friendsExcept;
  @override
  @JsonKey(name: 'friends_except')
  List<String>? get friendsExcept {
    final value = _friendsExcept;
    if (value == null) return null;
    if (_friendsExcept is EqualUnmodifiableListView) return _friendsExcept;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _friendsDetail;
  @override
  @JsonKey(name: 'friends_detail')
  List<String>? get friendsDetail {
    final value = _friendsDetail;
    if (value == null) return null;
    if (_friendsDetail is EqualUnmodifiableListView) return _friendsDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UpdatePrivacyModel(defaultPrivacy: $defaultPrivacy, friendsExcept: $friendsExcept, friendsDetail: $friendsDetail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePrivacyModelImpl &&
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
    defaultPrivacy,
    const DeepCollectionEquality().hash(_friendsExcept),
    const DeepCollectionEquality().hash(_friendsDetail),
  );

  /// Create a copy of UpdatePrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePrivacyModelImplCopyWith<_$UpdatePrivacyModelImpl> get copyWith =>
      __$$UpdatePrivacyModelImplCopyWithImpl<_$UpdatePrivacyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePrivacyModelImplToJson(this);
  }
}

abstract class _UpdatePrivacyModel implements UpdatePrivacyModel {
  const factory _UpdatePrivacyModel({
    required final PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') final List<String>? friendsExcept,
    @JsonKey(name: 'friends_detail') final List<String>? friendsDetail,
  }) = _$UpdatePrivacyModelImpl;

  factory _UpdatePrivacyModel.fromJson(Map<String, dynamic> json) =
      _$UpdatePrivacyModelImpl.fromJson;

  @override
  PrivacyType get defaultPrivacy;
  @override
  @JsonKey(name: 'friends_except')
  List<String>? get friendsExcept;
  @override
  @JsonKey(name: 'friends_detail')
  List<String>? get friendsDetail;

  /// Create a copy of UpdatePrivacyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePrivacyModelImplCopyWith<_$UpdatePrivacyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
