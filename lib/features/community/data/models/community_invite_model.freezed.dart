// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_invite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommunityInviteModel _$CommunityInviteModelFromJson(Map<String, dynamic> json) {
  return _CommunityInviteModel.fromJson(json);
}

/// @nodoc
mixin _$CommunityInviteModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  CommunityInfoModel get communityId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommunityInviteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityInviteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityInviteModelCopyWith<CommunityInviteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityInviteModelCopyWith<$Res> {
  factory $CommunityInviteModelCopyWith(
    CommunityInviteModel value,
    $Res Function(CommunityInviteModel) then,
  ) = _$CommunityInviteModelCopyWithImpl<$Res, CommunityInviteModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    CommunityInfoModel communityId,
    String type,
    String status,
    @JsonKey(name: 'createdAt') DateTime createdAt,
  });

  $CommunityInfoModelCopyWith<$Res> get communityId;
}

/// @nodoc
class _$CommunityInviteModelCopyWithImpl<
  $Res,
  $Val extends CommunityInviteModel
>
    implements $CommunityInviteModelCopyWith<$Res> {
  _$CommunityInviteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityInviteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? communityId = null,
    Object? type = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            communityId: null == communityId
                ? _value.communityId
                : communityId // ignore: cast_nullable_to_non_nullable
                      as CommunityInfoModel,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of CommunityInviteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunityInfoModelCopyWith<$Res> get communityId {
    return $CommunityInfoModelCopyWith<$Res>(_value.communityId, (value) {
      return _then(_value.copyWith(communityId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommunityInviteModelImplCopyWith<$Res>
    implements $CommunityInviteModelCopyWith<$Res> {
  factory _$$CommunityInviteModelImplCopyWith(
    _$CommunityInviteModelImpl value,
    $Res Function(_$CommunityInviteModelImpl) then,
  ) = __$$CommunityInviteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    CommunityInfoModel communityId,
    String type,
    String status,
    @JsonKey(name: 'createdAt') DateTime createdAt,
  });

  @override
  $CommunityInfoModelCopyWith<$Res> get communityId;
}

/// @nodoc
class __$$CommunityInviteModelImplCopyWithImpl<$Res>
    extends _$CommunityInviteModelCopyWithImpl<$Res, _$CommunityInviteModelImpl>
    implements _$$CommunityInviteModelImplCopyWith<$Res> {
  __$$CommunityInviteModelImplCopyWithImpl(
    _$CommunityInviteModelImpl _value,
    $Res Function(_$CommunityInviteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityInviteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? communityId = null,
    Object? type = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CommunityInviteModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        communityId: null == communityId
            ? _value.communityId
            : communityId // ignore: cast_nullable_to_non_nullable
                  as CommunityInfoModel,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityInviteModelImpl implements _CommunityInviteModel {
  const _$CommunityInviteModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.userId,
    required this.communityId,
    required this.type,
    required this.status,
    @JsonKey(name: 'createdAt') required this.createdAt,
  });

  factory _$CommunityInviteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityInviteModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final CommunityInfoModel communityId;
  @override
  final String type;
  @override
  final String status;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @override
  String toString() {
    return 'CommunityInviteModel(id: $id, userId: $userId, communityId: $communityId, type: $type, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityInviteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    communityId,
    type,
    status,
    createdAt,
  );

  /// Create a copy of CommunityInviteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityInviteModelImplCopyWith<_$CommunityInviteModelImpl>
  get copyWith =>
      __$$CommunityInviteModelImplCopyWithImpl<_$CommunityInviteModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityInviteModelImplToJson(this);
  }
}

abstract class _CommunityInviteModel implements CommunityInviteModel {
  const factory _CommunityInviteModel({
    @JsonKey(name: '_id') required final String id,
    required final String userId,
    required final CommunityInfoModel communityId,
    required final String type,
    required final String status,
    @JsonKey(name: 'createdAt') required final DateTime createdAt,
  }) = _$CommunityInviteModelImpl;

  factory _CommunityInviteModel.fromJson(Map<String, dynamic> json) =
      _$CommunityInviteModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  CommunityInfoModel get communityId;
  @override
  String get type;
  @override
  String get status;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;

  /// Create a copy of CommunityInviteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityInviteModelImplCopyWith<_$CommunityInviteModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CommunityInfoModel _$CommunityInfoModelFromJson(Map<String, dynamic> json) {
  return _CommunityInfoModel.fromJson(json);
}

/// @nodoc
mixin _$CommunityInfoModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CommunityInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityInfoModelCopyWith<CommunityInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityInfoModelCopyWith<$Res> {
  factory $CommunityInfoModelCopyWith(
    CommunityInfoModel value,
    $Res Function(CommunityInfoModel) then,
  ) = _$CommunityInfoModelCopyWithImpl<$Res, CommunityInfoModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String? avatar,
    String? description,
  });
}

/// @nodoc
class _$CommunityInfoModelCopyWithImpl<$Res, $Val extends CommunityInfoModel>
    implements $CommunityInfoModelCopyWith<$Res> {
  _$CommunityInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommunityInfoModelImplCopyWith<$Res>
    implements $CommunityInfoModelCopyWith<$Res> {
  factory _$$CommunityInfoModelImplCopyWith(
    _$CommunityInfoModelImpl value,
    $Res Function(_$CommunityInfoModelImpl) then,
  ) = __$$CommunityInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String? avatar,
    String? description,
  });
}

/// @nodoc
class __$$CommunityInfoModelImplCopyWithImpl<$Res>
    extends _$CommunityInfoModelCopyWithImpl<$Res, _$CommunityInfoModelImpl>
    implements _$$CommunityInfoModelImplCopyWith<$Res> {
  __$$CommunityInfoModelImplCopyWithImpl(
    _$CommunityInfoModelImpl _value,
    $Res Function(_$CommunityInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$CommunityInfoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityInfoModelImpl implements _CommunityInfoModel {
  const _$CommunityInfoModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    this.avatar,
    this.description,
  });

  factory _$CommunityInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityInfoModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String? avatar;
  @override
  final String? description;

  @override
  String toString() {
    return 'CommunityInfoModel(id: $id, name: $name, avatar: $avatar, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityInfoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatar, description);

  /// Create a copy of CommunityInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityInfoModelImplCopyWith<_$CommunityInfoModelImpl> get copyWith =>
      __$$CommunityInfoModelImplCopyWithImpl<_$CommunityInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityInfoModelImplToJson(this);
  }
}

abstract class _CommunityInfoModel implements CommunityInfoModel {
  const factory _CommunityInfoModel({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    final String? avatar,
    final String? description,
  }) = _$CommunityInfoModelImpl;

  factory _CommunityInfoModel.fromJson(Map<String, dynamic> json) =
      _$CommunityInfoModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String? get avatar;
  @override
  String? get description;

  /// Create a copy of CommunityInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityInfoModelImplCopyWith<_$CommunityInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
