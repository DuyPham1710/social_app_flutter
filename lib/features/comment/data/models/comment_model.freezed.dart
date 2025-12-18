// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  UserModel get user => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  ParentCommentModel? get parentId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'reacts')
  List<ReactCommentModel>? get reacts => throw _privateConstructorUsedError;
  @JsonKey(name: 'taggedUserIds')
  List<UserModel>? get taggedUsers => throw _privateConstructorUsedError;

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
    CommentModel value,
    $Res Function(CommentModel) then,
  ) = _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String content,
    @JsonKey(name: 'userId') UserModel user,
    String postId,
    ParentCommentModel? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(name: 'reacts') List<ReactCommentModel>? reacts,
    @JsonKey(name: 'taggedUserIds') List<UserModel>? taggedUsers,
  });

  $UserModelCopyWith<$Res> get user;
  $ParentCommentModelCopyWith<$Res>? get parentId;
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? user = null,
    Object? postId = null,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reacts = freezed,
    Object? taggedUsers = freezed,
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
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as ParentCommentModel?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reacts: freezed == reacts
                ? _value.reacts
                : reacts // ignore: cast_nullable_to_non_nullable
                      as List<ReactCommentModel>?,
            taggedUsers: freezed == taggedUsers
                ? _value.taggedUsers
                : taggedUsers // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParentCommentModelCopyWith<$Res>? get parentId {
    if (_value.parentId == null) {
      return null;
    }

    return $ParentCommentModelCopyWith<$Res>(_value.parentId!, (value) {
      return _then(_value.copyWith(parentId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
    _$CommentModelImpl value,
    $Res Function(_$CommentModelImpl) then,
  ) = __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String content,
    @JsonKey(name: 'userId') UserModel user,
    String postId,
    ParentCommentModel? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(name: 'reacts') List<ReactCommentModel>? reacts,
    @JsonKey(name: 'taggedUserIds') List<UserModel>? taggedUsers,
  });

  @override
  $UserModelCopyWith<$Res> get user;
  @override
  $ParentCommentModelCopyWith<$Res>? get parentId;
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
    _$CommentModelImpl _value,
    $Res Function(_$CommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? user = null,
    Object? postId = null,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reacts = freezed,
    Object? taggedUsers = freezed,
  }) {
    return _then(
      _$CommentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as ParentCommentModel?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reacts: freezed == reacts
            ? _value._reacts
            : reacts // ignore: cast_nullable_to_non_nullable
                  as List<ReactCommentModel>?,
        taggedUsers: freezed == taggedUsers
            ? _value._taggedUsers
            : taggedUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl implements _CommentModel {
  const _$CommentModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.content,
    @JsonKey(name: 'userId') required this.user,
    required this.postId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    @JsonKey(name: 'reacts') final List<ReactCommentModel>? reacts,
    @JsonKey(name: 'taggedUserIds') final List<UserModel>? taggedUsers,
  }) : _reacts = reacts,
       _taggedUsers = taggedUsers;

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String content;
  @override
  @JsonKey(name: 'userId')
  final UserModel user;
  @override
  final String postId;
  @override
  final ParentCommentModel? parentId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  final List<ReactCommentModel>? _reacts;
  @override
  @JsonKey(name: 'reacts')
  List<ReactCommentModel>? get reacts {
    final value = _reacts;
    if (value == null) return null;
    if (_reacts is EqualUnmodifiableListView) return _reacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<UserModel>? _taggedUsers;
  @override
  @JsonKey(name: 'taggedUserIds')
  List<UserModel>? get taggedUsers {
    final value = _taggedUsers;
    if (value == null) return null;
    if (_taggedUsers is EqualUnmodifiableListView) return _taggedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._reacts, _reacts) &&
            const DeepCollectionEquality().equals(
              other._taggedUsers,
              _taggedUsers,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    content,
    user,
    postId,
    parentId,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_reacts),
    const DeepCollectionEquality().hash(_taggedUsers),
  );

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(this);
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel({
    @JsonKey(name: '_id') required final String id,
    required final String content,
    @JsonKey(name: 'userId') required final UserModel user,
    required final String postId,
    final ParentCommentModel? parentId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    @JsonKey(name: 'reacts') final List<ReactCommentModel>? reacts,
    @JsonKey(name: 'taggedUserIds') final List<UserModel>? taggedUsers,
  }) = _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get content;
  @override
  @JsonKey(name: 'userId')
  UserModel get user;
  @override
  String get postId;
  @override
  ParentCommentModel? get parentId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'reacts')
  List<ReactCommentModel>? get reacts;
  @override
  @JsonKey(name: 'taggedUserIds')
  List<UserModel>? get taggedUsers;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
