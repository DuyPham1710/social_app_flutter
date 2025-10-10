// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_url_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostUrlModel _$PostUrlModelFromJson(Map<String, dynamic> json) {
  return _PostUrlModel.fromJson(json);
}

/// @nodoc
mixin _$PostUrlModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PostUrlModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostUrlModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostUrlModelCopyWith<PostUrlModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostUrlModelCopyWith<$Res> {
  factory $PostUrlModelCopyWith(
    PostUrlModel value,
    $Res Function(PostUrlModel) then,
  ) = _$PostUrlModelCopyWithImpl<$Res, PostUrlModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String url,
    String? title,
    int order,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$PostUrlModelCopyWithImpl<$Res, $Val extends PostUrlModel>
    implements $PostUrlModelCopyWith<$Res> {
  _$PostUrlModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostUrlModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? title = freezed,
    Object? order = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostUrlModelImplCopyWith<$Res>
    implements $PostUrlModelCopyWith<$Res> {
  factory _$$PostUrlModelImplCopyWith(
    _$PostUrlModelImpl value,
    $Res Function(_$PostUrlModelImpl) then,
  ) = __$$PostUrlModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String url,
    String? title,
    int order,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PostUrlModelImplCopyWithImpl<$Res>
    extends _$PostUrlModelCopyWithImpl<$Res, _$PostUrlModelImpl>
    implements _$$PostUrlModelImplCopyWith<$Res> {
  __$$PostUrlModelImplCopyWithImpl(
    _$PostUrlModelImpl _value,
    $Res Function(_$PostUrlModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostUrlModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? title = freezed,
    Object? order = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PostUrlModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostUrlModelImpl implements _PostUrlModel {
  const _$PostUrlModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.url,
    this.title,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory _$PostUrlModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostUrlModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String url;
  @override
  final String? title;
  @override
  final int order;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostUrlModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, url, title, order, createdAt, updatedAt);

  /// Create a copy of PostUrlModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostUrlModelImplCopyWith<_$PostUrlModelImpl> get copyWith =>
      __$$PostUrlModelImplCopyWithImpl<_$PostUrlModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostUrlModelImplToJson(this);
  }
}

abstract class _PostUrlModel implements PostUrlModel {
  const factory _PostUrlModel({
    @JsonKey(name: '_id') required final String id,
    required final String url,
    final String? title,
    required final int order,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$PostUrlModelImpl;

  factory _PostUrlModel.fromJson(Map<String, dynamic> json) =
      _$PostUrlModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get url;
  @override
  String? get title;
  @override
  int get order;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PostUrlModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostUrlModelImplCopyWith<_$PostUrlModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
