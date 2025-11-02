// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ParentCommentModel _$ParentCommentModelFromJson(Map<String, dynamic> json) {
  return _ParentCommentModel.fromJson(json);
}

/// @nodoc
mixin _$ParentCommentModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel? get user => throw _privateConstructorUsedError;

  /// Serializes this ParentCommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParentCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParentCommentModelCopyWith<ParentCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParentCommentModelCopyWith<$Res> {
  factory $ParentCommentModelCopyWith(
    ParentCommentModel value,
    $Res Function(ParentCommentModel) then,
  ) = _$ParentCommentModelCopyWithImpl<$Res, ParentCommentModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String content,
    DateTime? createdAt,
    @JsonKey(name: 'userId') UserModel? user,
  });

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$ParentCommentModelCopyWithImpl<$Res, $Val extends ParentCommentModel>
    implements $ParentCommentModelCopyWith<$Res> {
  _$ParentCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParentCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of ParentCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParentCommentModelImplCopyWith<$Res>
    implements $ParentCommentModelCopyWith<$Res> {
  factory _$$ParentCommentModelImplCopyWith(
    _$ParentCommentModelImpl value,
    $Res Function(_$ParentCommentModelImpl) then,
  ) = __$$ParentCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String content,
    DateTime? createdAt,
    @JsonKey(name: 'userId') UserModel? user,
  });

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$ParentCommentModelImplCopyWithImpl<$Res>
    extends _$ParentCommentModelCopyWithImpl<$Res, _$ParentCommentModelImpl>
    implements _$$ParentCommentModelImplCopyWith<$Res> {
  __$$ParentCommentModelImplCopyWithImpl(
    _$ParentCommentModelImpl _value,
    $Res Function(_$ParentCommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParentCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _$ParentCommentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParentCommentModelImpl implements _ParentCommentModel {
  const _$ParentCommentModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.content,
    this.createdAt,
    @JsonKey(name: 'userId') this.user,
  });

  factory _$ParentCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParentCommentModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String content;
  @override
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'userId')
  final UserModel? user;

  @override
  String toString() {
    return 'ParentCommentModel(id: $id, content: $content, createdAt: $createdAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParentCommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, content, createdAt, user);

  /// Create a copy of ParentCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParentCommentModelImplCopyWith<_$ParentCommentModelImpl> get copyWith =>
      __$$ParentCommentModelImplCopyWithImpl<_$ParentCommentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ParentCommentModelImplToJson(this);
  }
}

abstract class _ParentCommentModel implements ParentCommentModel {
  const factory _ParentCommentModel({
    @JsonKey(name: '_id') required final String id,
    required final String content,
    final DateTime? createdAt,
    @JsonKey(name: 'userId') final UserModel? user,
  }) = _$ParentCommentModelImpl;

  factory _ParentCommentModel.fromJson(Map<String, dynamic> json) =
      _$ParentCommentModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get content;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'userId')
  UserModel? get user;

  /// Create a copy of ParentCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParentCommentModelImplCopyWith<_$ParentCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
