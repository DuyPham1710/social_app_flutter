// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) {
  return _SearchResultModel.fromJson(json);
}

/// @nodoc
mixin _$SearchResultModel {
  List<UserModel> get userResponseDtos => throw _privateConstructorUsedError;
  PaginationModel get pagination => throw _privateConstructorUsedError;

  /// Serializes this SearchResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultModelCopyWith<SearchResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultModelCopyWith<$Res> {
  factory $SearchResultModelCopyWith(
    SearchResultModel value,
    $Res Function(SearchResultModel) then,
  ) = _$SearchResultModelCopyWithImpl<$Res, SearchResultModel>;
  @useResult
  $Res call({List<UserModel> userResponseDtos, PaginationModel pagination});

  $PaginationModelCopyWith<$Res> get pagination;
}

/// @nodoc
class _$SearchResultModelCopyWithImpl<$Res, $Val extends SearchResultModel>
    implements $SearchResultModelCopyWith<$Res> {
  _$SearchResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userResponseDtos = null, Object? pagination = null}) {
    return _then(
      _value.copyWith(
            userResponseDtos: null == userResponseDtos
                ? _value.userResponseDtos
                : userResponseDtos // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>,
            pagination: null == pagination
                ? _value.pagination
                : pagination // ignore: cast_nullable_to_non_nullable
                      as PaginationModel,
          )
          as $Val,
    );
  }

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationModelCopyWith<$Res> get pagination {
    return $PaginationModelCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchResultModelImplCopyWith<$Res>
    implements $SearchResultModelCopyWith<$Res> {
  factory _$$SearchResultModelImplCopyWith(
    _$SearchResultModelImpl value,
    $Res Function(_$SearchResultModelImpl) then,
  ) = __$$SearchResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserModel> userResponseDtos, PaginationModel pagination});

  @override
  $PaginationModelCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$SearchResultModelImplCopyWithImpl<$Res>
    extends _$SearchResultModelCopyWithImpl<$Res, _$SearchResultModelImpl>
    implements _$$SearchResultModelImplCopyWith<$Res> {
  __$$SearchResultModelImplCopyWithImpl(
    _$SearchResultModelImpl _value,
    $Res Function(_$SearchResultModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userResponseDtos = null, Object? pagination = null}) {
    return _then(
      _$SearchResultModelImpl(
        userResponseDtos: null == userResponseDtos
            ? _value._userResponseDtos
            : userResponseDtos // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        pagination: null == pagination
            ? _value.pagination
            : pagination // ignore: cast_nullable_to_non_nullable
                  as PaginationModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultModelImpl implements _SearchResultModel {
  const _$SearchResultModelImpl({
    required final List<UserModel> userResponseDtos,
    required this.pagination,
  }) : _userResponseDtos = userResponseDtos;

  factory _$SearchResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultModelImplFromJson(json);

  final List<UserModel> _userResponseDtos;
  @override
  List<UserModel> get userResponseDtos {
    if (_userResponseDtos is EqualUnmodifiableListView)
      return _userResponseDtos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userResponseDtos);
  }

  @override
  final PaginationModel pagination;

  @override
  String toString() {
    return 'SearchResultModel(userResponseDtos: $userResponseDtos, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultModelImpl &&
            const DeepCollectionEquality().equals(
              other._userResponseDtos,
              _userResponseDtos,
            ) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_userResponseDtos),
    pagination,
  );

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultModelImplCopyWith<_$SearchResultModelImpl> get copyWith =>
      __$$SearchResultModelImplCopyWithImpl<_$SearchResultModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultModelImplToJson(this);
  }
}

abstract class _SearchResultModel implements SearchResultModel {
  const factory _SearchResultModel({
    required final List<UserModel> userResponseDtos,
    required final PaginationModel pagination,
  }) = _$SearchResultModelImpl;

  factory _SearchResultModel.fromJson(Map<String, dynamic> json) =
      _$SearchResultModelImpl.fromJson;

  @override
  List<UserModel> get userResponseDtos;
  @override
  PaginationModel get pagination;

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultModelImplCopyWith<_$SearchResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) {
  return _PaginationModel.fromJson(json);
}

/// @nodoc
mixin _$PaginationModel {
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get itemsPerPage => throw _privateConstructorUsedError;
  bool get hasNextPage => throw _privateConstructorUsedError;
  bool get hasPrevPage => throw _privateConstructorUsedError;

  /// Serializes this PaginationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationModelCopyWith<PaginationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationModelCopyWith<$Res> {
  factory $PaginationModelCopyWith(
    PaginationModel value,
    $Res Function(PaginationModel) then,
  ) = _$PaginationModelCopyWithImpl<$Res, PaginationModel>;
  @useResult
  $Res call({
    int currentPage,
    int totalPages,
    int totalItems,
    int itemsPerPage,
    bool hasNextPage,
    bool hasPrevPage,
  });
}

/// @nodoc
class _$PaginationModelCopyWithImpl<$Res, $Val extends PaginationModel>
    implements $PaginationModelCopyWith<$Res> {
  _$PaginationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalItems = null,
    Object? itemsPerPage = null,
    Object? hasNextPage = null,
    Object? hasPrevPage = null,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            totalItems: null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int,
            itemsPerPage: null == itemsPerPage
                ? _value.itemsPerPage
                : itemsPerPage // ignore: cast_nullable_to_non_nullable
                      as int,
            hasNextPage: null == hasNextPage
                ? _value.hasNextPage
                : hasNextPage // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasPrevPage: null == hasPrevPage
                ? _value.hasPrevPage
                : hasPrevPage // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginationModelImplCopyWith<$Res>
    implements $PaginationModelCopyWith<$Res> {
  factory _$$PaginationModelImplCopyWith(
    _$PaginationModelImpl value,
    $Res Function(_$PaginationModelImpl) then,
  ) = __$$PaginationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentPage,
    int totalPages,
    int totalItems,
    int itemsPerPage,
    bool hasNextPage,
    bool hasPrevPage,
  });
}

/// @nodoc
class __$$PaginationModelImplCopyWithImpl<$Res>
    extends _$PaginationModelCopyWithImpl<$Res, _$PaginationModelImpl>
    implements _$$PaginationModelImplCopyWith<$Res> {
  __$$PaginationModelImplCopyWithImpl(
    _$PaginationModelImpl _value,
    $Res Function(_$PaginationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalItems = null,
    Object? itemsPerPage = null,
    Object? hasNextPage = null,
    Object? hasPrevPage = null,
  }) {
    return _then(
      _$PaginationModelImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        totalItems: null == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int,
        itemsPerPage: null == itemsPerPage
            ? _value.itemsPerPage
            : itemsPerPage // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNextPage: null == hasNextPage
            ? _value.hasNextPage
            : hasNextPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasPrevPage: null == hasPrevPage
            ? _value.hasPrevPage
            : hasPrevPage // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationModelImpl implements _PaginationModel {
  const _$PaginationModelImpl({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory _$PaginationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationModelImplFromJson(json);

  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final int totalItems;
  @override
  final int itemsPerPage;
  @override
  final bool hasNextPage;
  @override
  final bool hasPrevPage;

  @override
  String toString() {
    return 'PaginationModel(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems, itemsPerPage: $itemsPerPage, hasNextPage: $hasNextPage, hasPrevPage: $hasPrevPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationModelImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.itemsPerPage, itemsPerPage) ||
                other.itemsPerPage == itemsPerPage) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPrevPage, hasPrevPage) ||
                other.hasPrevPage == hasPrevPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPage,
    totalPages,
    totalItems,
    itemsPerPage,
    hasNextPage,
    hasPrevPage,
  );

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationModelImplCopyWith<_$PaginationModelImpl> get copyWith =>
      __$$PaginationModelImplCopyWithImpl<_$PaginationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationModelImplToJson(this);
  }
}

abstract class _PaginationModel implements PaginationModel {
  const factory _PaginationModel({
    required final int currentPage,
    required final int totalPages,
    required final int totalItems,
    required final int itemsPerPage,
    required final bool hasNextPage,
    required final bool hasPrevPage,
  }) = _$PaginationModelImpl;

  factory _PaginationModel.fromJson(Map<String, dynamic> json) =
      _$PaginationModelImpl.fromJson;

  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get totalItems;
  @override
  int get itemsPerPage;
  @override
  bool get hasNextPage;
  @override
  bool get hasPrevPage;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationModelImplCopyWith<_$PaginationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
