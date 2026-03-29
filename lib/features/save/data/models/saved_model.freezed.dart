// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavedModel _$SavedModelFromJson(Map<String, dynamic> json) {
  return _SavedModel.fromJson(json);
}

/// @nodoc
mixin _$SavedModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get collection => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get authorId => throw _privateConstructorUsedError;
  String? get authorName => throw _privateConstructorUsedError;
  String? get authorAvatar => throw _privateConstructorUsedError;

  /// Serializes this SavedModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedModelCopyWith<SavedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedModelCopyWith<$Res> {
  factory $SavedModelCopyWith(
    SavedModel value,
    $Res Function(SavedModel) then,
  ) = _$SavedModelCopyWithImpl<$Res, SavedModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String targetId,
    String type,
    String content,
    String collection,
    String note,
    DateTime? createdAt,
    String? authorId,
    String? authorName,
    String? authorAvatar,
  });
}

/// @nodoc
class _$SavedModelCopyWithImpl<$Res, $Val extends SavedModel>
    implements $SavedModelCopyWith<$Res> {
  _$SavedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? targetId = null,
    Object? type = null,
    Object? content = null,
    Object? collection = null,
    Object? note = null,
    Object? createdAt = freezed,
    Object? authorId = freezed,
    Object? authorName = freezed,
    Object? authorAvatar = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            targetId: null == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            collection: null == collection
                ? _value.collection
                : collection // ignore: cast_nullable_to_non_nullable
                      as String,
            note: null == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            authorId: freezed == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String?,
            authorName: freezed == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            authorAvatar: freezed == authorAvatar
                ? _value.authorAvatar
                : authorAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavedModelImplCopyWith<$Res>
    implements $SavedModelCopyWith<$Res> {
  factory _$$SavedModelImplCopyWith(
    _$SavedModelImpl value,
    $Res Function(_$SavedModelImpl) then,
  ) = __$$SavedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String targetId,
    String type,
    String content,
    String collection,
    String note,
    DateTime? createdAt,
    String? authorId,
    String? authorName,
    String? authorAvatar,
  });
}

/// @nodoc
class __$$SavedModelImplCopyWithImpl<$Res>
    extends _$SavedModelCopyWithImpl<$Res, _$SavedModelImpl>
    implements _$$SavedModelImplCopyWith<$Res> {
  __$$SavedModelImplCopyWithImpl(
    _$SavedModelImpl _value,
    $Res Function(_$SavedModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? targetId = null,
    Object? type = null,
    Object? content = null,
    Object? collection = null,
    Object? note = null,
    Object? createdAt = freezed,
    Object? authorId = freezed,
    Object? authorName = freezed,
    Object? authorAvatar = freezed,
  }) {
    return _then(
      _$SavedModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: null == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        collection: null == collection
            ? _value.collection
            : collection // ignore: cast_nullable_to_non_nullable
                  as String,
        note: null == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        authorId: freezed == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        authorName: freezed == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        authorAvatar: freezed == authorAvatar
            ? _value.authorAvatar
            : authorAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedModelImpl implements _SavedModel {
  const _$SavedModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.userId,
    required this.targetId,
    required this.type,
    this.content = '',
    this.collection = 'default',
    this.note = '',
    this.createdAt,
    this.authorId,
    this.authorName,
    this.authorAvatar,
  });

  factory _$SavedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String targetId;
  @override
  final String type;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String collection;
  @override
  @JsonKey()
  final String note;
  @override
  final DateTime? createdAt;
  @override
  final String? authorId;
  @override
  final String? authorName;
  @override
  final String? authorAvatar;

  @override
  String toString() {
    return 'SavedModel(id: $id, userId: $userId, targetId: $targetId, type: $type, content: $content, collection: $collection, note: $note, createdAt: $createdAt, authorId: $authorId, authorName: $authorName, authorAvatar: $authorAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatar, authorAvatar) ||
                other.authorAvatar == authorAvatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    targetId,
    type,
    content,
    collection,
    note,
    createdAt,
    authorId,
    authorName,
    authorAvatar,
  );

  /// Create a copy of SavedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedModelImplCopyWith<_$SavedModelImpl> get copyWith =>
      __$$SavedModelImplCopyWithImpl<_$SavedModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedModelImplToJson(this);
  }
}

abstract class _SavedModel implements SavedModel {
  const factory _SavedModel({
    @JsonKey(name: '_id') required final String id,
    required final String userId,
    required final String targetId,
    required final String type,
    final String content,
    final String collection,
    final String note,
    final DateTime? createdAt,
    final String? authorId,
    final String? authorName,
    final String? authorAvatar,
  }) = _$SavedModelImpl;

  factory _SavedModel.fromJson(Map<String, dynamic> json) =
      _$SavedModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get targetId;
  @override
  String get type;
  @override
  String get content;
  @override
  String get collection;
  @override
  String get note;
  @override
  DateTime? get createdAt;
  @override
  String? get authorId;
  @override
  String? get authorName;
  @override
  String? get authorAvatar;

  /// Create a copy of SavedModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedModelImplCopyWith<_$SavedModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
