// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_roadmap_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CommunityRoadmapEvent {
  String get communityId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String communityId, int? limit) getRoadmapPoints,
    required TResult Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )
    getNearbyRoadmapPoints,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String communityId, int? limit)? getRoadmapPoints,
    TResult? Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )?
    getNearbyRoadmapPoints,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String communityId, int? limit)? getRoadmapPoints,
    TResult Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )?
    getNearbyRoadmapPoints,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetRoadmapPointsRequested value) getRoadmapPoints,
    required TResult Function(GetNearbyRoadmapPointsRequested value)
    getNearbyRoadmapPoints,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetRoadmapPointsRequested value)? getRoadmapPoints,
    TResult? Function(GetNearbyRoadmapPointsRequested value)?
    getNearbyRoadmapPoints,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetRoadmapPointsRequested value)? getRoadmapPoints,
    TResult Function(GetNearbyRoadmapPointsRequested value)?
    getNearbyRoadmapPoints,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityRoadmapEventCopyWith<CommunityRoadmapEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityRoadmapEventCopyWith<$Res> {
  factory $CommunityRoadmapEventCopyWith(
    CommunityRoadmapEvent value,
    $Res Function(CommunityRoadmapEvent) then,
  ) = _$CommunityRoadmapEventCopyWithImpl<$Res, CommunityRoadmapEvent>;
  @useResult
  $Res call({String communityId});
}

/// @nodoc
class _$CommunityRoadmapEventCopyWithImpl<
  $Res,
  $Val extends CommunityRoadmapEvent
>
    implements $CommunityRoadmapEventCopyWith<$Res> {
  _$CommunityRoadmapEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? communityId = null}) {
    return _then(
      _value.copyWith(
            communityId: null == communityId
                ? _value.communityId
                : communityId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetRoadmapPointsRequestedImplCopyWith<$Res>
    implements $CommunityRoadmapEventCopyWith<$Res> {
  factory _$$GetRoadmapPointsRequestedImplCopyWith(
    _$GetRoadmapPointsRequestedImpl value,
    $Res Function(_$GetRoadmapPointsRequestedImpl) then,
  ) = __$$GetRoadmapPointsRequestedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String communityId, int? limit});
}

/// @nodoc
class __$$GetRoadmapPointsRequestedImplCopyWithImpl<$Res>
    extends
        _$CommunityRoadmapEventCopyWithImpl<
          $Res,
          _$GetRoadmapPointsRequestedImpl
        >
    implements _$$GetRoadmapPointsRequestedImplCopyWith<$Res> {
  __$$GetRoadmapPointsRequestedImplCopyWithImpl(
    _$GetRoadmapPointsRequestedImpl _value,
    $Res Function(_$GetRoadmapPointsRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? communityId = null, Object? limit = freezed}) {
    return _then(
      _$GetRoadmapPointsRequestedImpl(
        communityId: null == communityId
            ? _value.communityId
            : communityId // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetRoadmapPointsRequestedImpl implements GetRoadmapPointsRequested {
  const _$GetRoadmapPointsRequestedImpl({
    required this.communityId,
    this.limit,
  });

  @override
  final String communityId;
  @override
  final int? limit;

  @override
  String toString() {
    return 'CommunityRoadmapEvent.getRoadmapPoints(communityId: $communityId, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetRoadmapPointsRequestedImpl &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, communityId, limit);

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetRoadmapPointsRequestedImplCopyWith<_$GetRoadmapPointsRequestedImpl>
  get copyWith =>
      __$$GetRoadmapPointsRequestedImplCopyWithImpl<
        _$GetRoadmapPointsRequestedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String communityId, int? limit) getRoadmapPoints,
    required TResult Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )
    getNearbyRoadmapPoints,
  }) {
    return getRoadmapPoints(communityId, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String communityId, int? limit)? getRoadmapPoints,
    TResult? Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )?
    getNearbyRoadmapPoints,
  }) {
    return getRoadmapPoints?.call(communityId, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String communityId, int? limit)? getRoadmapPoints,
    TResult Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )?
    getNearbyRoadmapPoints,
    required TResult orElse(),
  }) {
    if (getRoadmapPoints != null) {
      return getRoadmapPoints(communityId, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetRoadmapPointsRequested value) getRoadmapPoints,
    required TResult Function(GetNearbyRoadmapPointsRequested value)
    getNearbyRoadmapPoints,
  }) {
    return getRoadmapPoints(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetRoadmapPointsRequested value)? getRoadmapPoints,
    TResult? Function(GetNearbyRoadmapPointsRequested value)?
    getNearbyRoadmapPoints,
  }) {
    return getRoadmapPoints?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetRoadmapPointsRequested value)? getRoadmapPoints,
    TResult Function(GetNearbyRoadmapPointsRequested value)?
    getNearbyRoadmapPoints,
    required TResult orElse(),
  }) {
    if (getRoadmapPoints != null) {
      return getRoadmapPoints(this);
    }
    return orElse();
  }
}

abstract class GetRoadmapPointsRequested implements CommunityRoadmapEvent {
  const factory GetRoadmapPointsRequested({
    required final String communityId,
    final int? limit,
  }) = _$GetRoadmapPointsRequestedImpl;

  @override
  String get communityId;
  int? get limit;

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetRoadmapPointsRequestedImplCopyWith<_$GetRoadmapPointsRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetNearbyRoadmapPointsRequestedImplCopyWith<$Res>
    implements $CommunityRoadmapEventCopyWith<$Res> {
  factory _$$GetNearbyRoadmapPointsRequestedImplCopyWith(
    _$GetNearbyRoadmapPointsRequestedImpl value,
    $Res Function(_$GetNearbyRoadmapPointsRequestedImpl) then,
  ) = __$$GetNearbyRoadmapPointsRequestedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String communityId, double lat, double lng, double? radius});
}

/// @nodoc
class __$$GetNearbyRoadmapPointsRequestedImplCopyWithImpl<$Res>
    extends
        _$CommunityRoadmapEventCopyWithImpl<
          $Res,
          _$GetNearbyRoadmapPointsRequestedImpl
        >
    implements _$$GetNearbyRoadmapPointsRequestedImplCopyWith<$Res> {
  __$$GetNearbyRoadmapPointsRequestedImplCopyWithImpl(
    _$GetNearbyRoadmapPointsRequestedImpl _value,
    $Res Function(_$GetNearbyRoadmapPointsRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? communityId = null,
    Object? lat = null,
    Object? lng = null,
    Object? radius = freezed,
  }) {
    return _then(
      _$GetNearbyRoadmapPointsRequestedImpl(
        communityId: null == communityId
            ? _value.communityId
            : communityId // ignore: cast_nullable_to_non_nullable
                  as String,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        radius: freezed == radius
            ? _value.radius
            : radius // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$GetNearbyRoadmapPointsRequestedImpl
    implements GetNearbyRoadmapPointsRequested {
  const _$GetNearbyRoadmapPointsRequestedImpl({
    required this.communityId,
    required this.lat,
    required this.lng,
    this.radius,
  });

  @override
  final String communityId;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final double? radius;

  @override
  String toString() {
    return 'CommunityRoadmapEvent.getNearbyRoadmapPoints(communityId: $communityId, lat: $lat, lng: $lng, radius: $radius)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetNearbyRoadmapPointsRequestedImpl &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.radius, radius) || other.radius == radius));
  }

  @override
  int get hashCode => Object.hash(runtimeType, communityId, lat, lng, radius);

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetNearbyRoadmapPointsRequestedImplCopyWith<
    _$GetNearbyRoadmapPointsRequestedImpl
  >
  get copyWith =>
      __$$GetNearbyRoadmapPointsRequestedImplCopyWithImpl<
        _$GetNearbyRoadmapPointsRequestedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String communityId, int? limit) getRoadmapPoints,
    required TResult Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )
    getNearbyRoadmapPoints,
  }) {
    return getNearbyRoadmapPoints(communityId, lat, lng, radius);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String communityId, int? limit)? getRoadmapPoints,
    TResult? Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )?
    getNearbyRoadmapPoints,
  }) {
    return getNearbyRoadmapPoints?.call(communityId, lat, lng, radius);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String communityId, int? limit)? getRoadmapPoints,
    TResult Function(
      String communityId,
      double lat,
      double lng,
      double? radius,
    )?
    getNearbyRoadmapPoints,
    required TResult orElse(),
  }) {
    if (getNearbyRoadmapPoints != null) {
      return getNearbyRoadmapPoints(communityId, lat, lng, radius);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetRoadmapPointsRequested value) getRoadmapPoints,
    required TResult Function(GetNearbyRoadmapPointsRequested value)
    getNearbyRoadmapPoints,
  }) {
    return getNearbyRoadmapPoints(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetRoadmapPointsRequested value)? getRoadmapPoints,
    TResult? Function(GetNearbyRoadmapPointsRequested value)?
    getNearbyRoadmapPoints,
  }) {
    return getNearbyRoadmapPoints?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetRoadmapPointsRequested value)? getRoadmapPoints,
    TResult Function(GetNearbyRoadmapPointsRequested value)?
    getNearbyRoadmapPoints,
    required TResult orElse(),
  }) {
    if (getNearbyRoadmapPoints != null) {
      return getNearbyRoadmapPoints(this);
    }
    return orElse();
  }
}

abstract class GetNearbyRoadmapPointsRequested
    implements CommunityRoadmapEvent {
  const factory GetNearbyRoadmapPointsRequested({
    required final String communityId,
    required final double lat,
    required final double lng,
    final double? radius,
  }) = _$GetNearbyRoadmapPointsRequestedImpl;

  @override
  String get communityId;
  double get lat;
  double get lng;
  double? get radius;

  /// Create a copy of CommunityRoadmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetNearbyRoadmapPointsRequestedImplCopyWith<
    _$GetNearbyRoadmapPointsRequestedImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
