// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roadmap_point_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoadmapPointListModel _$RoadmapPointListModelFromJson(
  Map<String, dynamic> json,
) {
  return _RoadmapPointListModel.fromJson(json);
}

/// @nodoc
mixin _$RoadmapPointListModel {
  List<RoadmapPointModel> get data => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;

  /// Serializes this RoadmapPointListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoadmapPointListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoadmapPointListModelCopyWith<RoadmapPointListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadmapPointListModelCopyWith<$Res> {
  factory $RoadmapPointListModelCopyWith(
    RoadmapPointListModel value,
    $Res Function(RoadmapPointListModel) then,
  ) = _$RoadmapPointListModelCopyWithImpl<$Res, RoadmapPointListModel>;
  @useResult
  $Res call({
    List<RoadmapPointModel> data,
    int page,
    int limit,
    int total,
    bool hasNext,
  });
}

/// @nodoc
class _$RoadmapPointListModelCopyWithImpl<
  $Res,
  $Val extends RoadmapPointListModel
>
    implements $RoadmapPointListModelCopyWith<$Res> {
  _$RoadmapPointListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoadmapPointListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? hasNext = null,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<RoadmapPointModel>,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            hasNext: null == hasNext
                ? _value.hasNext
                : hasNext // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoadmapPointListModelImplCopyWith<$Res>
    implements $RoadmapPointListModelCopyWith<$Res> {
  factory _$$RoadmapPointListModelImplCopyWith(
    _$RoadmapPointListModelImpl value,
    $Res Function(_$RoadmapPointListModelImpl) then,
  ) = __$$RoadmapPointListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<RoadmapPointModel> data,
    int page,
    int limit,
    int total,
    bool hasNext,
  });
}

/// @nodoc
class __$$RoadmapPointListModelImplCopyWithImpl<$Res>
    extends
        _$RoadmapPointListModelCopyWithImpl<$Res, _$RoadmapPointListModelImpl>
    implements _$$RoadmapPointListModelImplCopyWith<$Res> {
  __$$RoadmapPointListModelImplCopyWithImpl(
    _$RoadmapPointListModelImpl _value,
    $Res Function(_$RoadmapPointListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoadmapPointListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? hasNext = null,
  }) {
    return _then(
      _$RoadmapPointListModelImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<RoadmapPointModel>,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNext: null == hasNext
            ? _value.hasNext
            : hasNext // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadmapPointListModelImpl implements _RoadmapPointListModel {
  const _$RoadmapPointListModelImpl({
    required final List<RoadmapPointModel> data,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
  }) : _data = data;

  factory _$RoadmapPointListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadmapPointListModelImplFromJson(json);

  final List<RoadmapPointModel> _data;
  @override
  List<RoadmapPointModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int page;
  @override
  final int limit;
  @override
  final int total;
  @override
  final bool hasNext;

  @override
  String toString() {
    return 'RoadmapPointListModel(data: $data, page: $page, limit: $limit, total: $total, hasNext: $hasNext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadmapPointListModelImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    page,
    limit,
    total,
    hasNext,
  );

  /// Create a copy of RoadmapPointListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadmapPointListModelImplCopyWith<_$RoadmapPointListModelImpl>
  get copyWith =>
      __$$RoadmapPointListModelImplCopyWithImpl<_$RoadmapPointListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadmapPointListModelImplToJson(this);
  }
}

abstract class _RoadmapPointListModel implements RoadmapPointListModel {
  const factory _RoadmapPointListModel({
    required final List<RoadmapPointModel> data,
    required final int page,
    required final int limit,
    required final int total,
    required final bool hasNext,
  }) = _$RoadmapPointListModelImpl;

  factory _RoadmapPointListModel.fromJson(Map<String, dynamic> json) =
      _$RoadmapPointListModelImpl.fromJson;

  @override
  List<RoadmapPointModel> get data;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  bool get hasNext;

  /// Create a copy of RoadmapPointListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoadmapPointListModelImplCopyWith<_$RoadmapPointListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
