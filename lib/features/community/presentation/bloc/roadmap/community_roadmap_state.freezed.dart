// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_roadmap_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CommunityRoadmapState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RoadmapPointModel> points) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RoadmapPointModel> points)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RoadmapPointModel> points)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityRoadmapInitial value) initial,
    required TResult Function(CommunityRoadmapLoading value) loading,
    required TResult Function(CommunityRoadmapLoaded value) loaded,
    required TResult Function(CommunityRoadmapError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityRoadmapInitial value)? initial,
    TResult? Function(CommunityRoadmapLoading value)? loading,
    TResult? Function(CommunityRoadmapLoaded value)? loaded,
    TResult? Function(CommunityRoadmapError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityRoadmapInitial value)? initial,
    TResult Function(CommunityRoadmapLoading value)? loading,
    TResult Function(CommunityRoadmapLoaded value)? loaded,
    TResult Function(CommunityRoadmapError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityRoadmapStateCopyWith<$Res> {
  factory $CommunityRoadmapStateCopyWith(
    CommunityRoadmapState value,
    $Res Function(CommunityRoadmapState) then,
  ) = _$CommunityRoadmapStateCopyWithImpl<$Res, CommunityRoadmapState>;
}

/// @nodoc
class _$CommunityRoadmapStateCopyWithImpl<
  $Res,
  $Val extends CommunityRoadmapState
>
    implements $CommunityRoadmapStateCopyWith<$Res> {
  _$CommunityRoadmapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CommunityRoadmapInitialImplCopyWith<$Res> {
  factory _$$CommunityRoadmapInitialImplCopyWith(
    _$CommunityRoadmapInitialImpl value,
    $Res Function(_$CommunityRoadmapInitialImpl) then,
  ) = __$$CommunityRoadmapInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommunityRoadmapInitialImplCopyWithImpl<$Res>
    extends
        _$CommunityRoadmapStateCopyWithImpl<$Res, _$CommunityRoadmapInitialImpl>
    implements _$$CommunityRoadmapInitialImplCopyWith<$Res> {
  __$$CommunityRoadmapInitialImplCopyWithImpl(
    _$CommunityRoadmapInitialImpl _value,
    $Res Function(_$CommunityRoadmapInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommunityRoadmapInitialImpl implements CommunityRoadmapInitial {
  const _$CommunityRoadmapInitialImpl();

  @override
  String toString() {
    return 'CommunityRoadmapState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityRoadmapInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RoadmapPointModel> points) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RoadmapPointModel> points)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RoadmapPointModel> points)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityRoadmapInitial value) initial,
    required TResult Function(CommunityRoadmapLoading value) loading,
    required TResult Function(CommunityRoadmapLoaded value) loaded,
    required TResult Function(CommunityRoadmapError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityRoadmapInitial value)? initial,
    TResult? Function(CommunityRoadmapLoading value)? loading,
    TResult? Function(CommunityRoadmapLoaded value)? loaded,
    TResult? Function(CommunityRoadmapError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityRoadmapInitial value)? initial,
    TResult Function(CommunityRoadmapLoading value)? loading,
    TResult Function(CommunityRoadmapLoaded value)? loaded,
    TResult Function(CommunityRoadmapError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CommunityRoadmapInitial implements CommunityRoadmapState {
  const factory CommunityRoadmapInitial() = _$CommunityRoadmapInitialImpl;
}

/// @nodoc
abstract class _$$CommunityRoadmapLoadingImplCopyWith<$Res> {
  factory _$$CommunityRoadmapLoadingImplCopyWith(
    _$CommunityRoadmapLoadingImpl value,
    $Res Function(_$CommunityRoadmapLoadingImpl) then,
  ) = __$$CommunityRoadmapLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommunityRoadmapLoadingImplCopyWithImpl<$Res>
    extends
        _$CommunityRoadmapStateCopyWithImpl<$Res, _$CommunityRoadmapLoadingImpl>
    implements _$$CommunityRoadmapLoadingImplCopyWith<$Res> {
  __$$CommunityRoadmapLoadingImplCopyWithImpl(
    _$CommunityRoadmapLoadingImpl _value,
    $Res Function(_$CommunityRoadmapLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommunityRoadmapLoadingImpl implements CommunityRoadmapLoading {
  const _$CommunityRoadmapLoadingImpl();

  @override
  String toString() {
    return 'CommunityRoadmapState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityRoadmapLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RoadmapPointModel> points) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RoadmapPointModel> points)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RoadmapPointModel> points)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityRoadmapInitial value) initial,
    required TResult Function(CommunityRoadmapLoading value) loading,
    required TResult Function(CommunityRoadmapLoaded value) loaded,
    required TResult Function(CommunityRoadmapError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityRoadmapInitial value)? initial,
    TResult? Function(CommunityRoadmapLoading value)? loading,
    TResult? Function(CommunityRoadmapLoaded value)? loaded,
    TResult? Function(CommunityRoadmapError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityRoadmapInitial value)? initial,
    TResult Function(CommunityRoadmapLoading value)? loading,
    TResult Function(CommunityRoadmapLoaded value)? loaded,
    TResult Function(CommunityRoadmapError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CommunityRoadmapLoading implements CommunityRoadmapState {
  const factory CommunityRoadmapLoading() = _$CommunityRoadmapLoadingImpl;
}

/// @nodoc
abstract class _$$CommunityRoadmapLoadedImplCopyWith<$Res> {
  factory _$$CommunityRoadmapLoadedImplCopyWith(
    _$CommunityRoadmapLoadedImpl value,
    $Res Function(_$CommunityRoadmapLoadedImpl) then,
  ) = __$$CommunityRoadmapLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<RoadmapPointModel> points});
}

/// @nodoc
class __$$CommunityRoadmapLoadedImplCopyWithImpl<$Res>
    extends
        _$CommunityRoadmapStateCopyWithImpl<$Res, _$CommunityRoadmapLoadedImpl>
    implements _$$CommunityRoadmapLoadedImplCopyWith<$Res> {
  __$$CommunityRoadmapLoadedImplCopyWithImpl(
    _$CommunityRoadmapLoadedImpl _value,
    $Res Function(_$CommunityRoadmapLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? points = null}) {
    return _then(
      _$CommunityRoadmapLoadedImpl(
        null == points
            ? _value._points
            : points // ignore: cast_nullable_to_non_nullable
                  as List<RoadmapPointModel>,
      ),
    );
  }
}

/// @nodoc

class _$CommunityRoadmapLoadedImpl implements CommunityRoadmapLoaded {
  const _$CommunityRoadmapLoadedImpl(final List<RoadmapPointModel> points)
    : _points = points;

  final List<RoadmapPointModel> _points;
  @override
  List<RoadmapPointModel> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  String toString() {
    return 'CommunityRoadmapState.loaded(points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityRoadmapLoadedImpl &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_points));

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityRoadmapLoadedImplCopyWith<_$CommunityRoadmapLoadedImpl>
  get copyWith =>
      __$$CommunityRoadmapLoadedImplCopyWithImpl<_$CommunityRoadmapLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RoadmapPointModel> points) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(points);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RoadmapPointModel> points)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(points);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RoadmapPointModel> points)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(points);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityRoadmapInitial value) initial,
    required TResult Function(CommunityRoadmapLoading value) loading,
    required TResult Function(CommunityRoadmapLoaded value) loaded,
    required TResult Function(CommunityRoadmapError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityRoadmapInitial value)? initial,
    TResult? Function(CommunityRoadmapLoading value)? loading,
    TResult? Function(CommunityRoadmapLoaded value)? loaded,
    TResult? Function(CommunityRoadmapError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityRoadmapInitial value)? initial,
    TResult Function(CommunityRoadmapLoading value)? loading,
    TResult Function(CommunityRoadmapLoaded value)? loaded,
    TResult Function(CommunityRoadmapError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CommunityRoadmapLoaded implements CommunityRoadmapState {
  const factory CommunityRoadmapLoaded(final List<RoadmapPointModel> points) =
      _$CommunityRoadmapLoadedImpl;

  List<RoadmapPointModel> get points;

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityRoadmapLoadedImplCopyWith<_$CommunityRoadmapLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CommunityRoadmapErrorImplCopyWith<$Res> {
  factory _$$CommunityRoadmapErrorImplCopyWith(
    _$CommunityRoadmapErrorImpl value,
    $Res Function(_$CommunityRoadmapErrorImpl) then,
  ) = __$$CommunityRoadmapErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CommunityRoadmapErrorImplCopyWithImpl<$Res>
    extends
        _$CommunityRoadmapStateCopyWithImpl<$Res, _$CommunityRoadmapErrorImpl>
    implements _$$CommunityRoadmapErrorImplCopyWith<$Res> {
  __$$CommunityRoadmapErrorImplCopyWithImpl(
    _$CommunityRoadmapErrorImpl _value,
    $Res Function(_$CommunityRoadmapErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$CommunityRoadmapErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CommunityRoadmapErrorImpl implements CommunityRoadmapError {
  const _$CommunityRoadmapErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CommunityRoadmapState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityRoadmapErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityRoadmapErrorImplCopyWith<_$CommunityRoadmapErrorImpl>
  get copyWith =>
      __$$CommunityRoadmapErrorImplCopyWithImpl<_$CommunityRoadmapErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RoadmapPointModel> points) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RoadmapPointModel> points)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RoadmapPointModel> points)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityRoadmapInitial value) initial,
    required TResult Function(CommunityRoadmapLoading value) loading,
    required TResult Function(CommunityRoadmapLoaded value) loaded,
    required TResult Function(CommunityRoadmapError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityRoadmapInitial value)? initial,
    TResult? Function(CommunityRoadmapLoading value)? loading,
    TResult? Function(CommunityRoadmapLoaded value)? loaded,
    TResult? Function(CommunityRoadmapError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityRoadmapInitial value)? initial,
    TResult Function(CommunityRoadmapLoading value)? loading,
    TResult Function(CommunityRoadmapLoaded value)? loaded,
    TResult Function(CommunityRoadmapError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CommunityRoadmapError implements CommunityRoadmapState {
  const factory CommunityRoadmapError(final String message) =
      _$CommunityRoadmapErrorImpl;

  String get message;

  /// Create a copy of CommunityRoadmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityRoadmapErrorImplCopyWith<_$CommunityRoadmapErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
