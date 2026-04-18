// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommunityRequestModel _$CommunityRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _CommunityRequestModel.fromJson(json);
}

/// @nodoc
mixin _$CommunityRequestModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'join', 'invite'
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'approved', 'rejected'
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommunityRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityRequestModelCopyWith<CommunityRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityRequestModelCopyWith<$Res> {
  factory $CommunityRequestModelCopyWith(
    CommunityRequestModel value,
    $Res Function(CommunityRequestModel) then,
  ) = _$CommunityRequestModelCopyWithImpl<$Res, CommunityRequestModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String type,
    String status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$CommunityRequestModelCopyWithImpl<
  $Res,
  $Val extends CommunityRequestModel
>
    implements $CommunityRequestModelCopyWith<$Res> {
  _$CommunityRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? type = null,
    Object? status = null,
    Object? createdAt = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of CommunityRequestModel
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
abstract class _$$CommunityRequestModelImplCopyWith<$Res>
    implements $CommunityRequestModelCopyWith<$Res> {
  factory _$$CommunityRequestModelImplCopyWith(
    _$CommunityRequestModelImpl value,
    $Res Function(_$CommunityRequestModelImpl) then,
  ) = __$$CommunityRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'userId') UserModel user,
    String type,
    String status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  });

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$CommunityRequestModelImplCopyWithImpl<$Res>
    extends
        _$CommunityRequestModelCopyWithImpl<$Res, _$CommunityRequestModelImpl>
    implements _$$CommunityRequestModelImplCopyWith<$Res> {
  __$$CommunityRequestModelImplCopyWithImpl(
    _$CommunityRequestModelImpl _value,
    $Res Function(_$CommunityRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? type = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CommunityRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityRequestModelImpl implements _CommunityRequestModel {
  const _$CommunityRequestModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'userId') required this.user,
    required this.type,
    required this.status,
    @JsonKey(name: 'createdAt') this.createdAt,
  });

  factory _$CommunityRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityRequestModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  @override
  final String type;
  // 'join', 'invite'
  @override
  final String status;
  // 'pending', 'approved', 'rejected'
  @override
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CommunityRequestModel(id: $id, user: $user, type: $type, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, user, type, status, createdAt);

  /// Create a copy of CommunityRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityRequestModelImplCopyWith<_$CommunityRequestModelImpl>
  get copyWith =>
      __$$CommunityRequestModelImplCopyWithImpl<_$CommunityRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityRequestModelImplToJson(this);
  }
}

abstract class _CommunityRequestModel implements CommunityRequestModel {
  const factory _CommunityRequestModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'userId') required final UserModel user,
    required final String type,
    required final String status,
    @JsonKey(name: 'createdAt') final DateTime? createdAt,
  }) = _$CommunityRequestModelImpl;

  factory _CommunityRequestModel.fromJson(Map<String, dynamic> json) =
      _$CommunityRequestModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  String get type; // 'join', 'invite'
  @override
  String get status; // 'pending', 'approved', 'rejected'
  @override
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt;

  /// Create a copy of CommunityRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityRequestModelImplCopyWith<_$CommunityRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
