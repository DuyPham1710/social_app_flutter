// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roadmap_point_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoadmapPointModel _$RoadmapPointModelFromJson(Map<String, dynamic> json) {
  return _RoadmapPointModel.fromJson(json);
}

/// @nodoc
mixin _$RoadmapPointModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get communityId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'locationCoordinates')
  dynamic get locationCoordinates => throw _privateConstructorUsedError;
  int get postCount => throw _privateConstructorUsedError;
  List<String> get postIds => throw _privateConstructorUsedError;
  UserModel? get firstPostedBy => throw _privateConstructorUsedError;
  DateTime? get firstPostedAt => throw _privateConstructorUsedError;
  DateTime? get lastPostedAt => throw _privateConstructorUsedError;

  /// Serializes this RoadmapPointModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoadmapPointModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoadmapPointModelCopyWith<RoadmapPointModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadmapPointModelCopyWith<$Res> {
  factory $RoadmapPointModelCopyWith(
    RoadmapPointModel value,
    $Res Function(RoadmapPointModel) then,
  ) = _$RoadmapPointModelCopyWithImpl<$Res, RoadmapPointModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String communityId,
    String locationName,
    @JsonKey(name: 'locationCoordinates') dynamic locationCoordinates,
    int postCount,
    List<String> postIds,
    UserModel? firstPostedBy,
    DateTime? firstPostedAt,
    DateTime? lastPostedAt,
  });

  $UserModelCopyWith<$Res>? get firstPostedBy;
}

/// @nodoc
class _$RoadmapPointModelCopyWithImpl<$Res, $Val extends RoadmapPointModel>
    implements $RoadmapPointModelCopyWith<$Res> {
  _$RoadmapPointModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoadmapPointModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? communityId = null,
    Object? locationName = null,
    Object? locationCoordinates = freezed,
    Object? postCount = null,
    Object? postIds = null,
    Object? firstPostedBy = freezed,
    Object? firstPostedAt = freezed,
    Object? lastPostedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            communityId: null == communityId
                ? _value.communityId
                : communityId // ignore: cast_nullable_to_non_nullable
                      as String,
            locationName: null == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String,
            locationCoordinates: freezed == locationCoordinates
                ? _value.locationCoordinates
                : locationCoordinates // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            postCount: null == postCount
                ? _value.postCount
                : postCount // ignore: cast_nullable_to_non_nullable
                      as int,
            postIds: null == postIds
                ? _value.postIds
                : postIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            firstPostedBy: freezed == firstPostedBy
                ? _value.firstPostedBy
                : firstPostedBy // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            firstPostedAt: freezed == firstPostedAt
                ? _value.firstPostedAt
                : firstPostedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastPostedAt: freezed == lastPostedAt
                ? _value.lastPostedAt
                : lastPostedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of RoadmapPointModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get firstPostedBy {
    if (_value.firstPostedBy == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.firstPostedBy!, (value) {
      return _then(_value.copyWith(firstPostedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoadmapPointModelImplCopyWith<$Res>
    implements $RoadmapPointModelCopyWith<$Res> {
  factory _$$RoadmapPointModelImplCopyWith(
    _$RoadmapPointModelImpl value,
    $Res Function(_$RoadmapPointModelImpl) then,
  ) = __$$RoadmapPointModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String communityId,
    String locationName,
    @JsonKey(name: 'locationCoordinates') dynamic locationCoordinates,
    int postCount,
    List<String> postIds,
    UserModel? firstPostedBy,
    DateTime? firstPostedAt,
    DateTime? lastPostedAt,
  });

  @override
  $UserModelCopyWith<$Res>? get firstPostedBy;
}

/// @nodoc
class __$$RoadmapPointModelImplCopyWithImpl<$Res>
    extends _$RoadmapPointModelCopyWithImpl<$Res, _$RoadmapPointModelImpl>
    implements _$$RoadmapPointModelImplCopyWith<$Res> {
  __$$RoadmapPointModelImplCopyWithImpl(
    _$RoadmapPointModelImpl _value,
    $Res Function(_$RoadmapPointModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoadmapPointModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? communityId = null,
    Object? locationName = null,
    Object? locationCoordinates = freezed,
    Object? postCount = null,
    Object? postIds = null,
    Object? firstPostedBy = freezed,
    Object? firstPostedAt = freezed,
    Object? lastPostedAt = freezed,
  }) {
    return _then(
      _$RoadmapPointModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        communityId: null == communityId
            ? _value.communityId
            : communityId // ignore: cast_nullable_to_non_nullable
                  as String,
        locationName: null == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String,
        locationCoordinates: freezed == locationCoordinates
            ? _value.locationCoordinates
            : locationCoordinates // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        postCount: null == postCount
            ? _value.postCount
            : postCount // ignore: cast_nullable_to_non_nullable
                  as int,
        postIds: null == postIds
            ? _value._postIds
            : postIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        firstPostedBy: freezed == firstPostedBy
            ? _value.firstPostedBy
            : firstPostedBy // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        firstPostedAt: freezed == firstPostedAt
            ? _value.firstPostedAt
            : firstPostedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastPostedAt: freezed == lastPostedAt
            ? _value.lastPostedAt
            : lastPostedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadmapPointModelImpl extends _RoadmapPointModel {
  const _$RoadmapPointModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.communityId,
    required this.locationName,
    @JsonKey(name: 'locationCoordinates') this.locationCoordinates,
    required this.postCount,
    final List<String> postIds = const [],
    this.firstPostedBy,
    this.firstPostedAt,
    this.lastPostedAt,
  }) : _postIds = postIds,
       super._();

  factory _$RoadmapPointModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadmapPointModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String communityId;
  @override
  final String locationName;
  @override
  @JsonKey(name: 'locationCoordinates')
  final dynamic locationCoordinates;
  @override
  final int postCount;
  final List<String> _postIds;
  @override
  @JsonKey()
  List<String> get postIds {
    if (_postIds is EqualUnmodifiableListView) return _postIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_postIds);
  }

  @override
  final UserModel? firstPostedBy;
  @override
  final DateTime? firstPostedAt;
  @override
  final DateTime? lastPostedAt;

  @override
  String toString() {
    return 'RoadmapPointModel(id: $id, communityId: $communityId, locationName: $locationName, locationCoordinates: $locationCoordinates, postCount: $postCount, postIds: $postIds, firstPostedBy: $firstPostedBy, firstPostedAt: $firstPostedAt, lastPostedAt: $lastPostedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadmapPointModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            const DeepCollectionEquality().equals(
              other.locationCoordinates,
              locationCoordinates,
            ) &&
            (identical(other.postCount, postCount) ||
                other.postCount == postCount) &&
            const DeepCollectionEquality().equals(other._postIds, _postIds) &&
            (identical(other.firstPostedBy, firstPostedBy) ||
                other.firstPostedBy == firstPostedBy) &&
            (identical(other.firstPostedAt, firstPostedAt) ||
                other.firstPostedAt == firstPostedAt) &&
            (identical(other.lastPostedAt, lastPostedAt) ||
                other.lastPostedAt == lastPostedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    communityId,
    locationName,
    const DeepCollectionEquality().hash(locationCoordinates),
    postCount,
    const DeepCollectionEquality().hash(_postIds),
    firstPostedBy,
    firstPostedAt,
    lastPostedAt,
  );

  /// Create a copy of RoadmapPointModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadmapPointModelImplCopyWith<_$RoadmapPointModelImpl> get copyWith =>
      __$$RoadmapPointModelImplCopyWithImpl<_$RoadmapPointModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadmapPointModelImplToJson(this);
  }
}

abstract class _RoadmapPointModel extends RoadmapPointModel {
  const factory _RoadmapPointModel({
    @JsonKey(name: '_id') required final String id,
    required final String communityId,
    required final String locationName,
    @JsonKey(name: 'locationCoordinates') final dynamic locationCoordinates,
    required final int postCount,
    final List<String> postIds,
    final UserModel? firstPostedBy,
    final DateTime? firstPostedAt,
    final DateTime? lastPostedAt,
  }) = _$RoadmapPointModelImpl;
  const _RoadmapPointModel._() : super._();

  factory _RoadmapPointModel.fromJson(Map<String, dynamic> json) =
      _$RoadmapPointModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get communityId;
  @override
  String get locationName;
  @override
  @JsonKey(name: 'locationCoordinates')
  dynamic get locationCoordinates;
  @override
  int get postCount;
  @override
  List<String> get postIds;
  @override
  UserModel? get firstPostedBy;
  @override
  DateTime? get firstPostedAt;
  @override
  DateTime? get lastPostedAt;

  /// Create a copy of RoadmapPointModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoadmapPointModelImplCopyWith<_$RoadmapPointModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
