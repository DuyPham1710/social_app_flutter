// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostListResponse _$PostListResponseFromJson(Map<String, dynamic> json) {
  return _PostListResponse.fromJson(json);
}

/// @nodoc
mixin _$PostListResponse {
  List<PostModel> get data => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;
  bool? get hasNext => throw _privateConstructorUsedError;

  /// Serializes this PostListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostListResponseCopyWith<PostListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostListResponseCopyWith<$Res> {
  factory $PostListResponseCopyWith(
    PostListResponse value,
    $Res Function(PostListResponse) then,
  ) = _$PostListResponseCopyWithImpl<$Res, PostListResponse>;
  @useResult
  $Res call({
    List<PostModel> data,
    int? page,
    int? limit,
    int? total,
    bool? hasNext,
  });
}

/// @nodoc
class _$PostListResponseCopyWithImpl<$Res, $Val extends PostListResponse>
    implements $PostListResponseCopyWith<$Res> {
  _$PostListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? page = freezed,
    Object? limit = freezed,
    Object? total = freezed,
    Object? hasNext = freezed,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<PostModel>,
            page: freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int?,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int?,
            hasNext: freezed == hasNext
                ? _value.hasNext
                : hasNext // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostListResponseImplCopyWith<$Res>
    implements $PostListResponseCopyWith<$Res> {
  factory _$$PostListResponseImplCopyWith(
    _$PostListResponseImpl value,
    $Res Function(_$PostListResponseImpl) then,
  ) = __$$PostListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PostModel> data,
    int? page,
    int? limit,
    int? total,
    bool? hasNext,
  });
}

/// @nodoc
class __$$PostListResponseImplCopyWithImpl<$Res>
    extends _$PostListResponseCopyWithImpl<$Res, _$PostListResponseImpl>
    implements _$$PostListResponseImplCopyWith<$Res> {
  __$$PostListResponseImplCopyWithImpl(
    _$PostListResponseImpl _value,
    $Res Function(_$PostListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? page = freezed,
    Object? limit = freezed,
    Object? total = freezed,
    Object? hasNext = freezed,
  }) {
    return _then(
      _$PostListResponseImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<PostModel>,
        page: freezed == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int?,
        hasNext: freezed == hasNext
            ? _value.hasNext
            : hasNext // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostListResponseImpl implements _PostListResponse {
  const _$PostListResponseImpl({
    required final List<PostModel> data,
    this.page,
    this.limit,
    this.total,
    this.hasNext,
  }) : _data = data;

  factory _$PostListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostListResponseImplFromJson(json);

  final List<PostModel> _data;
  @override
  List<PostModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int? page;
  @override
  final int? limit;
  @override
  final int? total;
  @override
  final bool? hasNext;

  @override
  String toString() {
    return 'PostListResponse(data: $data, page: $page, limit: $limit, total: $total, hasNext: $hasNext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostListResponseImpl &&
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

  /// Create a copy of PostListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostListResponseImplCopyWith<_$PostListResponseImpl> get copyWith =>
      __$$PostListResponseImplCopyWithImpl<_$PostListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PostListResponseImplToJson(this);
  }
}

abstract class _PostListResponse implements PostListResponse {
  const factory _PostListResponse({
    required final List<PostModel> data,
    final int? page,
    final int? limit,
    final int? total,
    final bool? hasNext,
  }) = _$PostListResponseImpl;

  factory _PostListResponse.fromJson(Map<String, dynamic> json) =
      _$PostListResponseImpl.fromJson;

  @override
  List<PostModel> get data;
  @override
  int? get page;
  @override
  int? get limit;
  @override
  int? get total;
  @override
  bool? get hasNext;

  /// Create a copy of PostListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostListResponseImplCopyWith<_$PostListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
