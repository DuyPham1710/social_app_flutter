// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivitySummaryModel _$ActivitySummaryModelFromJson(Map<String, dynamic> json) {
  return _ActivitySummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ActivitySummaryModel {
  ActivityCountsModel get activities => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;

  /// Serializes this ActivitySummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivitySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivitySummaryModelCopyWith<ActivitySummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitySummaryModelCopyWith<$Res> {
  factory $ActivitySummaryModelCopyWith(
    ActivitySummaryModel value,
    $Res Function(ActivitySummaryModel) then,
  ) = _$ActivitySummaryModelCopyWithImpl<$Res, ActivitySummaryModel>;
  @useResult
  $Res call({ActivityCountsModel activities, String summary});

  $ActivityCountsModelCopyWith<$Res> get activities;
}

/// @nodoc
class _$ActivitySummaryModelCopyWithImpl<
  $Res,
  $Val extends ActivitySummaryModel
>
    implements $ActivitySummaryModelCopyWith<$Res> {
  _$ActivitySummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivitySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activities = null, Object? summary = null}) {
    return _then(
      _value.copyWith(
            activities: null == activities
                ? _value.activities
                : activities // ignore: cast_nullable_to_non_nullable
                      as ActivityCountsModel,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of ActivitySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityCountsModelCopyWith<$Res> get activities {
    return $ActivityCountsModelCopyWith<$Res>(_value.activities, (value) {
      return _then(_value.copyWith(activities: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivitySummaryModelImplCopyWith<$Res>
    implements $ActivitySummaryModelCopyWith<$Res> {
  factory _$$ActivitySummaryModelImplCopyWith(
    _$ActivitySummaryModelImpl value,
    $Res Function(_$ActivitySummaryModelImpl) then,
  ) = __$$ActivitySummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ActivityCountsModel activities, String summary});

  @override
  $ActivityCountsModelCopyWith<$Res> get activities;
}

/// @nodoc
class __$$ActivitySummaryModelImplCopyWithImpl<$Res>
    extends _$ActivitySummaryModelCopyWithImpl<$Res, _$ActivitySummaryModelImpl>
    implements _$$ActivitySummaryModelImplCopyWith<$Res> {
  __$$ActivitySummaryModelImplCopyWithImpl(
    _$ActivitySummaryModelImpl _value,
    $Res Function(_$ActivitySummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivitySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activities = null, Object? summary = null}) {
    return _then(
      _$ActivitySummaryModelImpl(
        activities: null == activities
            ? _value.activities
            : activities // ignore: cast_nullable_to_non_nullable
                  as ActivityCountsModel,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivitySummaryModelImpl implements _ActivitySummaryModel {
  const _$ActivitySummaryModelImpl({
    required this.activities,
    required this.summary,
  });

  factory _$ActivitySummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivitySummaryModelImplFromJson(json);

  @override
  final ActivityCountsModel activities;
  @override
  final String summary;

  @override
  String toString() {
    return 'ActivitySummaryModel(activities: $activities, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySummaryModelImpl &&
            (identical(other.activities, activities) ||
                other.activities == activities) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, activities, summary);

  /// Create a copy of ActivitySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitySummaryModelImplCopyWith<_$ActivitySummaryModelImpl>
  get copyWith =>
      __$$ActivitySummaryModelImplCopyWithImpl<_$ActivitySummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivitySummaryModelImplToJson(this);
  }
}

abstract class _ActivitySummaryModel implements ActivitySummaryModel {
  const factory _ActivitySummaryModel({
    required final ActivityCountsModel activities,
    required final String summary,
  }) = _$ActivitySummaryModelImpl;

  factory _ActivitySummaryModel.fromJson(Map<String, dynamic> json) =
      _$ActivitySummaryModelImpl.fromJson;

  @override
  ActivityCountsModel get activities;
  @override
  String get summary;

  /// Create a copy of ActivitySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivitySummaryModelImplCopyWith<_$ActivitySummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ActivityCountsModel _$ActivityCountsModelFromJson(Map<String, dynamic> json) {
  return _ActivityCountsModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityCountsModel {
  int get postCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  int get reactCount => throw _privateConstructorUsedError;
  int get storyCount => throw _privateConstructorUsedError;

  /// Serializes this ActivityCountsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityCountsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityCountsModelCopyWith<ActivityCountsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCountsModelCopyWith<$Res> {
  factory $ActivityCountsModelCopyWith(
    ActivityCountsModel value,
    $Res Function(ActivityCountsModel) then,
  ) = _$ActivityCountsModelCopyWithImpl<$Res, ActivityCountsModel>;
  @useResult
  $Res call({int postCount, int commentCount, int reactCount, int storyCount});
}

/// @nodoc
class _$ActivityCountsModelCopyWithImpl<$Res, $Val extends ActivityCountsModel>
    implements $ActivityCountsModelCopyWith<$Res> {
  _$ActivityCountsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityCountsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postCount = null,
    Object? commentCount = null,
    Object? reactCount = null,
    Object? storyCount = null,
  }) {
    return _then(
      _value.copyWith(
            postCount: null == postCount
                ? _value.postCount
                : postCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            reactCount: null == reactCount
                ? _value.reactCount
                : reactCount // ignore: cast_nullable_to_non_nullable
                      as int,
            storyCount: null == storyCount
                ? _value.storyCount
                : storyCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityCountsModelImplCopyWith<$Res>
    implements $ActivityCountsModelCopyWith<$Res> {
  factory _$$ActivityCountsModelImplCopyWith(
    _$ActivityCountsModelImpl value,
    $Res Function(_$ActivityCountsModelImpl) then,
  ) = __$$ActivityCountsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int postCount, int commentCount, int reactCount, int storyCount});
}

/// @nodoc
class __$$ActivityCountsModelImplCopyWithImpl<$Res>
    extends _$ActivityCountsModelCopyWithImpl<$Res, _$ActivityCountsModelImpl>
    implements _$$ActivityCountsModelImplCopyWith<$Res> {
  __$$ActivityCountsModelImplCopyWithImpl(
    _$ActivityCountsModelImpl _value,
    $Res Function(_$ActivityCountsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityCountsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postCount = null,
    Object? commentCount = null,
    Object? reactCount = null,
    Object? storyCount = null,
  }) {
    return _then(
      _$ActivityCountsModelImpl(
        postCount: null == postCount
            ? _value.postCount
            : postCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        reactCount: null == reactCount
            ? _value.reactCount
            : reactCount // ignore: cast_nullable_to_non_nullable
                  as int,
        storyCount: null == storyCount
            ? _value.storyCount
            : storyCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityCountsModelImpl implements _ActivityCountsModel {
  const _$ActivityCountsModelImpl({
    required this.postCount,
    required this.commentCount,
    required this.reactCount,
    required this.storyCount,
  });

  factory _$ActivityCountsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityCountsModelImplFromJson(json);

  @override
  final int postCount;
  @override
  final int commentCount;
  @override
  final int reactCount;
  @override
  final int storyCount;

  @override
  String toString() {
    return 'ActivityCountsModel(postCount: $postCount, commentCount: $commentCount, reactCount: $reactCount, storyCount: $storyCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityCountsModelImpl &&
            (identical(other.postCount, postCount) ||
                other.postCount == postCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.reactCount, reactCount) ||
                other.reactCount == reactCount) &&
            (identical(other.storyCount, storyCount) ||
                other.storyCount == storyCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, postCount, commentCount, reactCount, storyCount);

  /// Create a copy of ActivityCountsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityCountsModelImplCopyWith<_$ActivityCountsModelImpl> get copyWith =>
      __$$ActivityCountsModelImplCopyWithImpl<_$ActivityCountsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityCountsModelImplToJson(this);
  }
}

abstract class _ActivityCountsModel implements ActivityCountsModel {
  const factory _ActivityCountsModel({
    required final int postCount,
    required final int commentCount,
    required final int reactCount,
    required final int storyCount,
  }) = _$ActivityCountsModelImpl;

  factory _ActivityCountsModel.fromJson(Map<String, dynamic> json) =
      _$ActivityCountsModelImpl.fromJson;

  @override
  int get postCount;
  @override
  int get commentCount;
  @override
  int get reactCount;
  @override
  int get storyCount;

  /// Create a copy of ActivityCountsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityCountsModelImplCopyWith<_$ActivityCountsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
