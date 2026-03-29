// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavedListModel _$SavedListModelFromJson(Map<String, dynamic> json) {
  return _SavedListModel.fromJson(json);
}

/// @nodoc
mixin _$SavedListModel {
  List<SavedModel> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Serializes this SavedListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedListModelCopyWith<SavedListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedListModelCopyWith<$Res> {
  factory $SavedListModelCopyWith(
    SavedListModel value,
    $Res Function(SavedListModel) then,
  ) = _$SavedListModelCopyWithImpl<$Res, SavedListModel>;
  @useResult
  $Res call({List<SavedModel> data, int total, int page, int limit});
}

/// @nodoc
class _$SavedListModelCopyWithImpl<$Res, $Val extends SavedListModel>
    implements $SavedListModelCopyWith<$Res> {
  _$SavedListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<SavedModel>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavedListModelImplCopyWith<$Res>
    implements $SavedListModelCopyWith<$Res> {
  factory _$$SavedListModelImplCopyWith(
    _$SavedListModelImpl value,
    $Res Function(_$SavedListModelImpl) then,
  ) = __$$SavedListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SavedModel> data, int total, int page, int limit});
}

/// @nodoc
class __$$SavedListModelImplCopyWithImpl<$Res>
    extends _$SavedListModelCopyWithImpl<$Res, _$SavedListModelImpl>
    implements _$$SavedListModelImplCopyWith<$Res> {
  __$$SavedListModelImplCopyWithImpl(
    _$SavedListModelImpl _value,
    $Res Function(_$SavedListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      _$SavedListModelImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<SavedModel>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedListModelImpl implements _SavedListModel {
  const _$SavedListModelImpl({
    required final List<SavedModel> data,
    this.total = 0,
    this.page = 1,
    this.limit = 20,
  }) : _data = data;

  factory _$SavedListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedListModelImplFromJson(json);

  final List<SavedModel> _data;
  @override
  List<SavedModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'SavedListModel(data: $data, total: $total, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedListModelImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    total,
    page,
    limit,
  );

  /// Create a copy of SavedListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedListModelImplCopyWith<_$SavedListModelImpl> get copyWith =>
      __$$SavedListModelImplCopyWithImpl<_$SavedListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedListModelImplToJson(this);
  }
}

abstract class _SavedListModel implements SavedListModel {
  const factory _SavedListModel({
    required final List<SavedModel> data,
    final int total,
    final int page,
    final int limit,
  }) = _$SavedListModelImpl;

  factory _SavedListModel.fromJson(Map<String, dynamic> json) =
      _$SavedListModelImpl.fromJson;

  @override
  List<SavedModel> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;

  /// Create a copy of SavedListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedListModelImplCopyWith<_$SavedListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
