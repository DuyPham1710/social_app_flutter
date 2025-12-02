// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment-log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentLogModel _$CommentLogModelFromJson(Map<String, dynamic> json) {
  return _CommentLogModel.fromJson(json);
}

/// @nodoc
mixin _$CommentLogModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'commentId')
  String get commentId => throw _privateConstructorUsedError;
  String get oldContent => throw _privateConstructorUsedError;
  String get newContent => throw _privateConstructorUsedError;
  UserModel get editedBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CommentLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentLogModelCopyWith<CommentLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentLogModelCopyWith<$Res> {
  factory $CommentLogModelCopyWith(
    CommentLogModel value,
    $Res Function(CommentLogModel) then,
  ) = _$CommentLogModelCopyWithImpl<$Res, CommentLogModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'commentId') String commentId,
    String oldContent,
    String newContent,
    UserModel editedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $UserModelCopyWith<$Res> get editedBy;
}

/// @nodoc
class _$CommentLogModelCopyWithImpl<$Res, $Val extends CommentLogModel>
    implements $CommentLogModelCopyWith<$Res> {
  _$CommentLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commentId = null,
    Object? oldContent = null,
    Object? newContent = null,
    Object? editedBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            commentId: null == commentId
                ? _value.commentId
                : commentId // ignore: cast_nullable_to_non_nullable
                      as String,
            oldContent: null == oldContent
                ? _value.oldContent
                : oldContent // ignore: cast_nullable_to_non_nullable
                      as String,
            newContent: null == newContent
                ? _value.newContent
                : newContent // ignore: cast_nullable_to_non_nullable
                      as String,
            editedBy: null == editedBy
                ? _value.editedBy
                : editedBy // ignore: cast_nullable_to_non_nullable
                      as UserModel,
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

  /// Create a copy of CommentLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get editedBy {
    return $UserModelCopyWith<$Res>(_value.editedBy, (value) {
      return _then(_value.copyWith(editedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentLogModelImplCopyWith<$Res>
    implements $CommentLogModelCopyWith<$Res> {
  factory _$$CommentLogModelImplCopyWith(
    _$CommentLogModelImpl value,
    $Res Function(_$CommentLogModelImpl) then,
  ) = __$$CommentLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'commentId') String commentId,
    String oldContent,
    String newContent,
    UserModel editedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $UserModelCopyWith<$Res> get editedBy;
}

/// @nodoc
class __$$CommentLogModelImplCopyWithImpl<$Res>
    extends _$CommentLogModelCopyWithImpl<$Res, _$CommentLogModelImpl>
    implements _$$CommentLogModelImplCopyWith<$Res> {
  __$$CommentLogModelImplCopyWithImpl(
    _$CommentLogModelImpl _value,
    $Res Function(_$CommentLogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commentId = null,
    Object? oldContent = null,
    Object? newContent = null,
    Object? editedBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CommentLogModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        commentId: null == commentId
            ? _value.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
                  as String,
        oldContent: null == oldContent
            ? _value.oldContent
            : oldContent // ignore: cast_nullable_to_non_nullable
                  as String,
        newContent: null == newContent
            ? _value.newContent
            : newContent // ignore: cast_nullable_to_non_nullable
                  as String,
        editedBy: null == editedBy
            ? _value.editedBy
            : editedBy // ignore: cast_nullable_to_non_nullable
                  as UserModel,
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
class _$CommentLogModelImpl implements _CommentLogModel {
  const _$CommentLogModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'commentId') required this.commentId,
    required this.oldContent,
    required this.newContent,
    required this.editedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CommentLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentLogModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'commentId')
  final String commentId;
  @override
  final String oldContent;
  @override
  final String newContent;
  @override
  final UserModel editedBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.oldContent, oldContent) ||
                other.oldContent == oldContent) &&
            (identical(other.newContent, newContent) ||
                other.newContent == newContent) &&
            (identical(other.editedBy, editedBy) ||
                other.editedBy == editedBy) &&
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
    commentId,
    oldContent,
    newContent,
    editedBy,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CommentLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentLogModelImplCopyWith<_$CommentLogModelImpl> get copyWith =>
      __$$CommentLogModelImplCopyWithImpl<_$CommentLogModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentLogModelImplToJson(this);
  }
}

abstract class _CommentLogModel implements CommentLogModel {
  const factory _CommentLogModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'commentId') required final String commentId,
    required final String oldContent,
    required final String newContent,
    required final UserModel editedBy,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CommentLogModelImpl;

  factory _CommentLogModel.fromJson(Map<String, dynamic> json) =
      _$CommentLogModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'commentId')
  String get commentId;
  @override
  String get oldContent;
  @override
  String get newContent;
  @override
  UserModel get editedBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CommentLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentLogModelImplCopyWith<_$CommentLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
