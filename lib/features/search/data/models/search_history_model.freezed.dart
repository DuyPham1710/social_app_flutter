// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchHistoryModel _$SearchHistoryModelFromJson(Map<String, dynamic> json) {
  return _SearchHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$SearchHistoryModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get query => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get resultCount => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false, name: 'viewedUser')
  UserModel? get viewedUser => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SearchHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHistoryModelCopyWith<SearchHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryModelCopyWith<$Res> {
  factory $SearchHistoryModelCopyWith(
    SearchHistoryModel value,
    $Res Function(SearchHistoryModel) then,
  ) = _$SearchHistoryModelCopyWithImpl<$Res, SearchHistoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(includeIfNull: false) String? query,
    @JsonKey(includeIfNull: false) int? resultCount,
    @JsonKey(includeIfNull: false, name: 'viewedUser') UserModel? viewedUser,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $UserModelCopyWith<$Res>? get viewedUser;
}

/// @nodoc
class _$SearchHistoryModelCopyWithImpl<$Res, $Val extends SearchHistoryModel>
    implements $SearchHistoryModelCopyWith<$Res> {
  _$SearchHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = freezed,
    Object? resultCount = freezed,
    Object? viewedUser = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            query: freezed == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String?,
            resultCount: freezed == resultCount
                ? _value.resultCount
                : resultCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            viewedUser: freezed == viewedUser
                ? _value.viewedUser
                : viewedUser // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get viewedUser {
    if (_value.viewedUser == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.viewedUser!, (value) {
      return _then(_value.copyWith(viewedUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchHistoryModelImplCopyWith<$Res>
    implements $SearchHistoryModelCopyWith<$Res> {
  factory _$$SearchHistoryModelImplCopyWith(
    _$SearchHistoryModelImpl value,
    $Res Function(_$SearchHistoryModelImpl) then,
  ) = __$$SearchHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(includeIfNull: false) String? query,
    @JsonKey(includeIfNull: false) int? resultCount,
    @JsonKey(includeIfNull: false, name: 'viewedUser') UserModel? viewedUser,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $UserModelCopyWith<$Res>? get viewedUser;
}

/// @nodoc
class __$$SearchHistoryModelImplCopyWithImpl<$Res>
    extends _$SearchHistoryModelCopyWithImpl<$Res, _$SearchHistoryModelImpl>
    implements _$$SearchHistoryModelImplCopyWith<$Res> {
  __$$SearchHistoryModelImplCopyWithImpl(
    _$SearchHistoryModelImpl _value,
    $Res Function(_$SearchHistoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = freezed,
    Object? resultCount = freezed,
    Object? viewedUser = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SearchHistoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        query: freezed == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String?,
        resultCount: freezed == resultCount
            ? _value.resultCount
            : resultCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        viewedUser: freezed == viewedUser
            ? _value.viewedUser
            : viewedUser // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchHistoryModelImpl implements _SearchHistoryModel {
  const _$SearchHistoryModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(includeIfNull: false) this.query,
    @JsonKey(includeIfNull: false) this.resultCount,
    @JsonKey(includeIfNull: false, name: 'viewedUser') this.viewedUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$SearchHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchHistoryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(includeIfNull: false)
  final String? query;
  @override
  @JsonKey(includeIfNull: false)
  final int? resultCount;
  @override
  @JsonKey(includeIfNull: false, name: 'viewedUser')
  final UserModel? viewedUser;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SearchHistoryModel(id: $id, query: $query, resultCount: $resultCount, viewedUser: $viewedUser, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.resultCount, resultCount) ||
                other.resultCount == resultCount) &&
            (identical(other.viewedUser, viewedUser) ||
                other.viewedUser == viewedUser) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    query,
    resultCount,
    viewedUser,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHistoryModelImplCopyWith<_$SearchHistoryModelImpl> get copyWith =>
      __$$SearchHistoryModelImplCopyWithImpl<_$SearchHistoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchHistoryModelImplToJson(this);
  }
}

abstract class _SearchHistoryModel implements SearchHistoryModel {
  const factory _SearchHistoryModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(includeIfNull: false) final String? query,
    @JsonKey(includeIfNull: false) final int? resultCount,
    @JsonKey(includeIfNull: false, name: 'viewedUser')
    final UserModel? viewedUser,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$SearchHistoryModelImpl;

  factory _SearchHistoryModel.fromJson(Map<String, dynamic> json) =
      _$SearchHistoryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(includeIfNull: false)
  String? get query;
  @override
  @JsonKey(includeIfNull: false)
  int? get resultCount;
  @override
  @JsonKey(includeIfNull: false, name: 'viewedUser')
  UserModel? get viewedUser;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHistoryModelImplCopyWith<_$SearchHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
