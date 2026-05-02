// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemberListModel _$MemberListModelFromJson(Map<String, dynamic> json) {
  return _MemberListModel.fromJson(json);
}

/// @nodoc
mixin _$MemberListModel {
  List<MemberModel> get data => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;

  /// Serializes this MemberListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberListModelCopyWith<MemberListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberListModelCopyWith<$Res> {
  factory $MemberListModelCopyWith(
    MemberListModel value,
    $Res Function(MemberListModel) then,
  ) = _$MemberListModelCopyWithImpl<$Res, MemberListModel>;
  @useResult
  $Res call({
    List<MemberModel> data,
    int page,
    int limit,
    int total,
    bool hasNext,
  });
}

/// @nodoc
class _$MemberListModelCopyWithImpl<$Res, $Val extends MemberListModel>
    implements $MemberListModelCopyWith<$Res> {
  _$MemberListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberListModel
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
                      as List<MemberModel>,
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
abstract class _$$MemberListModelImplCopyWith<$Res>
    implements $MemberListModelCopyWith<$Res> {
  factory _$$MemberListModelImplCopyWith(
    _$MemberListModelImpl value,
    $Res Function(_$MemberListModelImpl) then,
  ) = __$$MemberListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MemberModel> data,
    int page,
    int limit,
    int total,
    bool hasNext,
  });
}

/// @nodoc
class __$$MemberListModelImplCopyWithImpl<$Res>
    extends _$MemberListModelCopyWithImpl<$Res, _$MemberListModelImpl>
    implements _$$MemberListModelImplCopyWith<$Res> {
  __$$MemberListModelImplCopyWithImpl(
    _$MemberListModelImpl _value,
    $Res Function(_$MemberListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberListModel
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
      _$MemberListModelImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<MemberModel>,
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
class _$MemberListModelImpl implements _MemberListModel {
  const _$MemberListModelImpl({
    required final List<MemberModel> data,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
  }) : _data = data;

  factory _$MemberListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberListModelImplFromJson(json);

  final List<MemberModel> _data;
  @override
  List<MemberModel> get data {
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
    return 'MemberListModel(data: $data, page: $page, limit: $limit, total: $total, hasNext: $hasNext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberListModelImpl &&
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

  /// Create a copy of MemberListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberListModelImplCopyWith<_$MemberListModelImpl> get copyWith =>
      __$$MemberListModelImplCopyWithImpl<_$MemberListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberListModelImplToJson(this);
  }
}

abstract class _MemberListModel implements MemberListModel {
  const factory _MemberListModel({
    required final List<MemberModel> data,
    required final int page,
    required final int limit,
    required final int total,
    required final bool hasNext,
  }) = _$MemberListModelImpl;

  factory _MemberListModel.fromJson(Map<String, dynamic> json) =
      _$MemberListModelImpl.fromJson;

  @override
  List<MemberModel> get data;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  bool get hasNext;

  /// Create a copy of MemberListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberListModelImplCopyWith<_$MemberListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
