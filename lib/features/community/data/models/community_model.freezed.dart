// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) {
  return _CommunityModel.fromJson(json);
}

/// @nodoc
mixin _$CommunityModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get coverImage => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDateTime)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'adminId', fromJson: _extractAdminId)
  String get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy')
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'myRole')
  String? get myRole => throw _privateConstructorUsedError;
  @JsonKey(name: 'memberStatus')
  String? get memberStatus => throw _privateConstructorUsedError;

  /// Serializes this CommunityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityModelCopyWith<CommunityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityModelCopyWith<$Res> {
  factory $CommunityModelCopyWith(
    CommunityModel value,
    $Res Function(CommunityModel) then,
  ) = _$CommunityModelCopyWithImpl<$Res, CommunityModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String? description,
    String? avatar,
    String? coverImage,
    int memberCount,
    @JsonKey(fromJson: _parseDateTime) DateTime createdAt,
    @JsonKey(name: 'adminId', fromJson: _extractAdminId) String createdBy,
    @JsonKey(name: 'privacy') String? status,
    @JsonKey(name: 'myRole') String? myRole,
    @JsonKey(name: 'memberStatus') String? memberStatus,
  });
}

/// @nodoc
class _$CommunityModelCopyWithImpl<$Res, $Val extends CommunityModel>
    implements $CommunityModelCopyWith<$Res> {
  _$CommunityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? coverImage = freezed,
    Object? memberCount = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? status = freezed,
    Object? myRole = freezed,
    Object? memberStatus = freezed,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverImage: freezed == coverImage
                ? _value.coverImage
                : coverImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            myRole: freezed == myRole
                ? _value.myRole
                : myRole // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberStatus: freezed == memberStatus
                ? _value.memberStatus
                : memberStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommunityModelImplCopyWith<$Res>
    implements $CommunityModelCopyWith<$Res> {
  factory _$$CommunityModelImplCopyWith(
    _$CommunityModelImpl value,
    $Res Function(_$CommunityModelImpl) then,
  ) = __$$CommunityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String? description,
    String? avatar,
    String? coverImage,
    int memberCount,
    @JsonKey(fromJson: _parseDateTime) DateTime createdAt,
    @JsonKey(name: 'adminId', fromJson: _extractAdminId) String createdBy,
    @JsonKey(name: 'privacy') String? status,
    @JsonKey(name: 'myRole') String? myRole,
    @JsonKey(name: 'memberStatus') String? memberStatus,
  });
}

/// @nodoc
class __$$CommunityModelImplCopyWithImpl<$Res>
    extends _$CommunityModelCopyWithImpl<$Res, _$CommunityModelImpl>
    implements _$$CommunityModelImplCopyWith<$Res> {
  __$$CommunityModelImplCopyWithImpl(
    _$CommunityModelImpl _value,
    $Res Function(_$CommunityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? coverImage = freezed,
    Object? memberCount = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? status = freezed,
    Object? myRole = freezed,
    Object? memberStatus = freezed,
  }) {
    return _then(
      _$CommunityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverImage: freezed == coverImage
            ? _value.coverImage
            : coverImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        myRole: freezed == myRole
            ? _value.myRole
            : myRole // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberStatus: freezed == memberStatus
            ? _value.memberStatus
            : memberStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityModelImpl implements _CommunityModel {
  const _$CommunityModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    this.description,
    this.avatar,
    this.coverImage,
    required this.memberCount,
    @JsonKey(fromJson: _parseDateTime) required this.createdAt,
    @JsonKey(name: 'adminId', fromJson: _extractAdminId)
    required this.createdBy,
    @JsonKey(name: 'privacy') this.status,
    @JsonKey(name: 'myRole') this.myRole,
    @JsonKey(name: 'memberStatus') this.memberStatus,
  });

  factory _$CommunityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? avatar;
  @override
  final String? coverImage;
  @override
  final int memberCount;
  @override
  @JsonKey(fromJson: _parseDateTime)
  final DateTime createdAt;
  @override
  @JsonKey(name: 'adminId', fromJson: _extractAdminId)
  final String createdBy;
  @override
  @JsonKey(name: 'privacy')
  final String? status;
  @override
  @JsonKey(name: 'myRole')
  final String? myRole;
  @override
  @JsonKey(name: 'memberStatus')
  final String? memberStatus;

  @override
  String toString() {
    return 'CommunityModel(id: $id, name: $name, description: $description, avatar: $avatar, coverImage: $coverImage, memberCount: $memberCount, createdAt: $createdAt, createdBy: $createdBy, status: $status, myRole: $myRole, memberStatus: $memberStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.myRole, myRole) || other.myRole == myRole) &&
            (identical(other.memberStatus, memberStatus) ||
                other.memberStatus == memberStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    avatar,
    coverImage,
    memberCount,
    createdAt,
    createdBy,
    status,
    myRole,
    memberStatus,
  );

  /// Create a copy of CommunityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityModelImplCopyWith<_$CommunityModelImpl> get copyWith =>
      __$$CommunityModelImplCopyWithImpl<_$CommunityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityModelImplToJson(this);
  }
}

abstract class _CommunityModel implements CommunityModel {
  const factory _CommunityModel({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    final String? description,
    final String? avatar,
    final String? coverImage,
    required final int memberCount,
    @JsonKey(fromJson: _parseDateTime) required final DateTime createdAt,
    @JsonKey(name: 'adminId', fromJson: _extractAdminId)
    required final String createdBy,
    @JsonKey(name: 'privacy') final String? status,
    @JsonKey(name: 'myRole') final String? myRole,
    @JsonKey(name: 'memberStatus') final String? memberStatus,
  }) = _$CommunityModelImpl;

  factory _CommunityModel.fromJson(Map<String, dynamic> json) =
      _$CommunityModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get avatar;
  @override
  String? get coverImage;
  @override
  int get memberCount;
  @override
  @JsonKey(fromJson: _parseDateTime)
  DateTime get createdAt;
  @override
  @JsonKey(name: 'adminId', fromJson: _extractAdminId)
  String get createdBy;
  @override
  @JsonKey(name: 'privacy')
  String? get status;
  @override
  @JsonKey(name: 'myRole')
  String? get myRole;
  @override
  @JsonKey(name: 'memberStatus')
  String? get memberStatus;

  /// Create a copy of CommunityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityModelImplCopyWith<_$CommunityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
