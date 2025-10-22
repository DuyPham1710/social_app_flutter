// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_story_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GroupedUserStoryModel _$GroupedUserStoryModelFromJson(
  Map<String, dynamic> json,
) {
  return _GroupedUserStoryModel.fromJson(json);
}

/// @nodoc
mixin _$GroupedUserStoryModel {
  UserModel get user => throw _privateConstructorUsedError;
  List<StoryModel> get stories => throw _privateConstructorUsedError;

  /// Serializes this GroupedUserStoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupedUserStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupedUserStoryModelCopyWith<GroupedUserStoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedUserStoryModelCopyWith<$Res> {
  factory $GroupedUserStoryModelCopyWith(
    GroupedUserStoryModel value,
    $Res Function(GroupedUserStoryModel) then,
  ) = _$GroupedUserStoryModelCopyWithImpl<$Res, GroupedUserStoryModel>;
  @useResult
  $Res call({UserModel user, List<StoryModel> stories});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$GroupedUserStoryModelCopyWithImpl<
  $Res,
  $Val extends GroupedUserStoryModel
>
    implements $GroupedUserStoryModelCopyWith<$Res> {
  _$GroupedUserStoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupedUserStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? stories = null}) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            stories: null == stories
                ? _value.stories
                : stories // ignore: cast_nullable_to_non_nullable
                      as List<StoryModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of GroupedUserStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupedUserStoryModelImplCopyWith<$Res>
    implements $GroupedUserStoryModelCopyWith<$Res> {
  factory _$$GroupedUserStoryModelImplCopyWith(
    _$GroupedUserStoryModelImpl value,
    $Res Function(_$GroupedUserStoryModelImpl) then,
  ) = __$$GroupedUserStoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel user, List<StoryModel> stories});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$GroupedUserStoryModelImplCopyWithImpl<$Res>
    extends
        _$GroupedUserStoryModelCopyWithImpl<$Res, _$GroupedUserStoryModelImpl>
    implements _$$GroupedUserStoryModelImplCopyWith<$Res> {
  __$$GroupedUserStoryModelImplCopyWithImpl(
    _$GroupedUserStoryModelImpl _value,
    $Res Function(_$GroupedUserStoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupedUserStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? stories = null}) {
    return _then(
      _$GroupedUserStoryModelImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        stories: null == stories
            ? _value._stories
            : stories // ignore: cast_nullable_to_non_nullable
                  as List<StoryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupedUserStoryModelImpl implements _GroupedUserStoryModel {
  const _$GroupedUserStoryModelImpl({
    required this.user,
    required final List<StoryModel> stories,
  }) : _stories = stories;

  factory _$GroupedUserStoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupedUserStoryModelImplFromJson(json);

  @override
  final UserModel user;
  final List<StoryModel> _stories;
  @override
  List<StoryModel> get stories {
    if (_stories is EqualUnmodifiableListView) return _stories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stories);
  }

  @override
  String toString() {
    return 'GroupedUserStoryModel(user: $user, stories: $stories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupedUserStoryModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._stories, _stories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    const DeepCollectionEquality().hash(_stories),
  );

  /// Create a copy of GroupedUserStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupedUserStoryModelImplCopyWith<_$GroupedUserStoryModelImpl>
  get copyWith =>
      __$$GroupedUserStoryModelImplCopyWithImpl<_$GroupedUserStoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupedUserStoryModelImplToJson(this);
  }
}

abstract class _GroupedUserStoryModel implements GroupedUserStoryModel {
  const factory _GroupedUserStoryModel({
    required final UserModel user,
    required final List<StoryModel> stories,
  }) = _$GroupedUserStoryModelImpl;

  factory _GroupedUserStoryModel.fromJson(Map<String, dynamic> json) =
      _$GroupedUserStoryModelImpl.fromJson;

  @override
  UserModel get user;
  @override
  List<StoryModel> get stories;

  /// Create a copy of GroupedUserStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupedUserStoryModelImplCopyWith<_$GroupedUserStoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

GroupedStoryListModel _$GroupedStoryListModelFromJson(
  Map<String, dynamic> json,
) {
  return _GroupedStoryListModel.fromJson(json);
}

/// @nodoc
mixin _$GroupedStoryListModel {
  List<GroupedUserStoryModel> get users => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;

  /// Serializes this GroupedStoryListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupedStoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupedStoryListModelCopyWith<GroupedStoryListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedStoryListModelCopyWith<$Res> {
  factory $GroupedStoryListModelCopyWith(
    GroupedStoryListModel value,
    $Res Function(GroupedStoryListModel) then,
  ) = _$GroupedStoryListModelCopyWithImpl<$Res, GroupedStoryListModel>;
  @useResult
  $Res call({
    List<GroupedUserStoryModel> users,
    int page,
    int limit,
    int total,
    bool hasNext,
  });
}

/// @nodoc
class _$GroupedStoryListModelCopyWithImpl<
  $Res,
  $Val extends GroupedStoryListModel
>
    implements $GroupedStoryListModelCopyWith<$Res> {
  _$GroupedStoryListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupedStoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? hasNext = null,
  }) {
    return _then(
      _value.copyWith(
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<GroupedUserStoryModel>,
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
abstract class _$$GroupedStoryListModelImplCopyWith<$Res>
    implements $GroupedStoryListModelCopyWith<$Res> {
  factory _$$GroupedStoryListModelImplCopyWith(
    _$GroupedStoryListModelImpl value,
    $Res Function(_$GroupedStoryListModelImpl) then,
  ) = __$$GroupedStoryListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<GroupedUserStoryModel> users,
    int page,
    int limit,
    int total,
    bool hasNext,
  });
}

/// @nodoc
class __$$GroupedStoryListModelImplCopyWithImpl<$Res>
    extends
        _$GroupedStoryListModelCopyWithImpl<$Res, _$GroupedStoryListModelImpl>
    implements _$$GroupedStoryListModelImplCopyWith<$Res> {
  __$$GroupedStoryListModelImplCopyWithImpl(
    _$GroupedStoryListModelImpl _value,
    $Res Function(_$GroupedStoryListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupedStoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? hasNext = null,
  }) {
    return _then(
      _$GroupedStoryListModelImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<GroupedUserStoryModel>,
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
class _$GroupedStoryListModelImpl implements _GroupedStoryListModel {
  const _$GroupedStoryListModelImpl({
    required final List<GroupedUserStoryModel> users,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
  }) : _users = users;

  factory _$GroupedStoryListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupedStoryListModelImplFromJson(json);

  final List<GroupedUserStoryModel> _users;
  @override
  List<GroupedUserStoryModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
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
    return 'GroupedStoryListModel(users: $users, page: $page, limit: $limit, total: $total, hasNext: $hasNext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupedStoryListModelImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    page,
    limit,
    total,
    hasNext,
  );

  /// Create a copy of GroupedStoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupedStoryListModelImplCopyWith<_$GroupedStoryListModelImpl>
  get copyWith =>
      __$$GroupedStoryListModelImplCopyWithImpl<_$GroupedStoryListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupedStoryListModelImplToJson(this);
  }
}

abstract class _GroupedStoryListModel implements GroupedStoryListModel {
  const factory _GroupedStoryListModel({
    required final List<GroupedUserStoryModel> users,
    required final int page,
    required final int limit,
    required final int total,
    required final bool hasNext,
  }) = _$GroupedStoryListModelImpl;

  factory _GroupedStoryListModel.fromJson(Map<String, dynamic> json) =
      _$GroupedStoryListModelImpl.fromJson;

  @override
  List<GroupedUserStoryModel> get users;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  bool get hasNext;

  /// Create a copy of GroupedStoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupedStoryListModelImplCopyWith<_$GroupedStoryListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
