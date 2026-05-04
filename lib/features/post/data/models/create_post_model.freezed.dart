// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreatePostModel _$CreatePostModelFromJson(Map<String, dynamic> json) {
  return _CreatePostModel.fromJson(json);
}

/// @nodoc
mixin _$CreatePostModel {
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  List<File>? get files => throw _privateConstructorUsedError;
  List<String>? get titles => throw _privateConstructorUsedError;
  List<int>? get orders => throw _privateConstructorUsedError;
  LayoutType? get layout => throw _privateConstructorUsedError;
  PrivacyType? get privacyType => throw _privateConstructorUsedError;
  List<String>? get friendsExcept => throw _privateConstructorUsedError;
  List<String>? get friendsDetail => throw _privateConstructorUsedError;
  List<String>? get taggedUserIds => throw _privateConstructorUsedError;
  String? get communityId => throw _privateConstructorUsedError;

  /// Serializes this CreatePostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostModelCopyWith<CreatePostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostModelCopyWith<$Res> {
  factory $CreatePostModelCopyWith(
    CreatePostModel value,
    $Res Function(CreatePostModel) then,
  ) = _$CreatePostModelCopyWithImpl<$Res, CreatePostModel>;
  @useResult
  $Res call({
    String? caption,
    @JsonKey(ignore: true) List<File>? files,
    List<String>? titles,
    List<int>? orders,
    LayoutType? layout,
    PrivacyType? privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
    List<String>? taggedUserIds,
    String? communityId,
  });
}

/// @nodoc
class _$CreatePostModelCopyWithImpl<$Res, $Val extends CreatePostModel>
    implements $CreatePostModelCopyWith<$Res> {
  _$CreatePostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caption = freezed,
    Object? files = freezed,
    Object? titles = freezed,
    Object? orders = freezed,
    Object? layout = freezed,
    Object? privacyType = freezed,
    Object? friendsExcept = freezed,
    Object? friendsDetail = freezed,
    Object? taggedUserIds = freezed,
    Object? communityId = freezed,
  }) {
    return _then(
      _value.copyWith(
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            files: freezed == files
                ? _value.files
                : files // ignore: cast_nullable_to_non_nullable
                      as List<File>?,
            titles: freezed == titles
                ? _value.titles
                : titles // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            orders: freezed == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            layout: freezed == layout
                ? _value.layout
                : layout // ignore: cast_nullable_to_non_nullable
                      as LayoutType?,
            privacyType: freezed == privacyType
                ? _value.privacyType
                : privacyType // ignore: cast_nullable_to_non_nullable
                      as PrivacyType?,
            friendsExcept: freezed == friendsExcept
                ? _value.friendsExcept
                : friendsExcept // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            friendsDetail: freezed == friendsDetail
                ? _value.friendsDetail
                : friendsDetail // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            taggedUserIds: freezed == taggedUserIds
                ? _value.taggedUserIds
                : taggedUserIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            communityId: freezed == communityId
                ? _value.communityId
                : communityId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePostModelImplCopyWith<$Res>
    implements $CreatePostModelCopyWith<$Res> {
  factory _$$CreatePostModelImplCopyWith(
    _$CreatePostModelImpl value,
    $Res Function(_$CreatePostModelImpl) then,
  ) = __$$CreatePostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? caption,
    @JsonKey(ignore: true) List<File>? files,
    List<String>? titles,
    List<int>? orders,
    LayoutType? layout,
    PrivacyType? privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
    List<String>? taggedUserIds,
    String? communityId,
  });
}

/// @nodoc
class __$$CreatePostModelImplCopyWithImpl<$Res>
    extends _$CreatePostModelCopyWithImpl<$Res, _$CreatePostModelImpl>
    implements _$$CreatePostModelImplCopyWith<$Res> {
  __$$CreatePostModelImplCopyWithImpl(
    _$CreatePostModelImpl _value,
    $Res Function(_$CreatePostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caption = freezed,
    Object? files = freezed,
    Object? titles = freezed,
    Object? orders = freezed,
    Object? layout = freezed,
    Object? privacyType = freezed,
    Object? friendsExcept = freezed,
    Object? friendsDetail = freezed,
    Object? taggedUserIds = freezed,
    Object? communityId = freezed,
  }) {
    return _then(
      _$CreatePostModelImpl(
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        files: freezed == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<File>?,
        titles: freezed == titles
            ? _value._titles
            : titles // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        orders: freezed == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        layout: freezed == layout
            ? _value.layout
            : layout // ignore: cast_nullable_to_non_nullable
                  as LayoutType?,
        privacyType: freezed == privacyType
            ? _value.privacyType
            : privacyType // ignore: cast_nullable_to_non_nullable
                  as PrivacyType?,
        friendsExcept: freezed == friendsExcept
            ? _value._friendsExcept
            : friendsExcept // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        friendsDetail: freezed == friendsDetail
            ? _value._friendsDetail
            : friendsDetail // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        taggedUserIds: freezed == taggedUserIds
            ? _value._taggedUserIds
            : taggedUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        communityId: freezed == communityId
            ? _value.communityId
            : communityId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostModelImpl implements _CreatePostModel {
  const _$CreatePostModelImpl({
    this.caption,
    @JsonKey(ignore: true) final List<File>? files,
    final List<String>? titles,
    final List<int>? orders,
    this.layout,
    this.privacyType,
    final List<String>? friendsExcept,
    final List<String>? friendsDetail,
    final List<String>? taggedUserIds,
    this.communityId,
  }) : _files = files,
       _titles = titles,
       _orders = orders,
       _friendsExcept = friendsExcept,
       _friendsDetail = friendsDetail,
       _taggedUserIds = taggedUserIds;

  factory _$CreatePostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostModelImplFromJson(json);

  @override
  final String? caption;
  final List<File>? _files;
  @override
  @JsonKey(ignore: true)
  List<File>? get files {
    final value = _files;
    if (value == null) return null;
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _titles;
  @override
  List<String>? get titles {
    final value = _titles;
    if (value == null) return null;
    if (_titles is EqualUnmodifiableListView) return _titles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _orders;
  @override
  List<int>? get orders {
    final value = _orders;
    if (value == null) return null;
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final LayoutType? layout;
  @override
  final PrivacyType? privacyType;
  final List<String>? _friendsExcept;
  @override
  List<String>? get friendsExcept {
    final value = _friendsExcept;
    if (value == null) return null;
    if (_friendsExcept is EqualUnmodifiableListView) return _friendsExcept;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _friendsDetail;
  @override
  List<String>? get friendsDetail {
    final value = _friendsDetail;
    if (value == null) return null;
    if (_friendsDetail is EqualUnmodifiableListView) return _friendsDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _taggedUserIds;
  @override
  List<String>? get taggedUserIds {
    final value = _taggedUserIds;
    if (value == null) return null;
    if (_taggedUserIds is EqualUnmodifiableListView) return _taggedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? communityId;

  @override
  String toString() {
    return 'CreatePostModel(caption: $caption, files: $files, titles: $titles, orders: $orders, layout: $layout, privacyType: $privacyType, friendsExcept: $friendsExcept, friendsDetail: $friendsDetail, taggedUserIds: $taggedUserIds, communityId: $communityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostModelImpl &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            const DeepCollectionEquality().equals(other._titles, _titles) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.layout, layout) || other.layout == layout) &&
            (identical(other.privacyType, privacyType) ||
                other.privacyType == privacyType) &&
            const DeepCollectionEquality().equals(
              other._friendsExcept,
              _friendsExcept,
            ) &&
            const DeepCollectionEquality().equals(
              other._friendsDetail,
              _friendsDetail,
            ) &&
            const DeepCollectionEquality().equals(
              other._taggedUserIds,
              _taggedUserIds,
            ) &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    caption,
    const DeepCollectionEquality().hash(_files),
    const DeepCollectionEquality().hash(_titles),
    const DeepCollectionEquality().hash(_orders),
    layout,
    privacyType,
    const DeepCollectionEquality().hash(_friendsExcept),
    const DeepCollectionEquality().hash(_friendsDetail),
    const DeepCollectionEquality().hash(_taggedUserIds),
    communityId,
  );

  /// Create a copy of CreatePostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostModelImplCopyWith<_$CreatePostModelImpl> get copyWith =>
      __$$CreatePostModelImplCopyWithImpl<_$CreatePostModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostModelImplToJson(this);
  }
}

abstract class _CreatePostModel implements CreatePostModel {
  const factory _CreatePostModel({
    final String? caption,
    @JsonKey(ignore: true) final List<File>? files,
    final List<String>? titles,
    final List<int>? orders,
    final LayoutType? layout,
    final PrivacyType? privacyType,
    final List<String>? friendsExcept,
    final List<String>? friendsDetail,
    final List<String>? taggedUserIds,
    final String? communityId,
  }) = _$CreatePostModelImpl;

  factory _CreatePostModel.fromJson(Map<String, dynamic> json) =
      _$CreatePostModelImpl.fromJson;

  @override
  String? get caption;
  @override
  @JsonKey(ignore: true)
  List<File>? get files;
  @override
  List<String>? get titles;
  @override
  List<int>? get orders;
  @override
  LayoutType? get layout;
  @override
  PrivacyType? get privacyType;
  @override
  List<String>? get friendsExcept;
  @override
  List<String>? get friendsDetail;
  @override
  List<String>? get taggedUserIds;
  @override
  String? get communityId;

  /// Create a copy of CreatePostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostModelImplCopyWith<_$CreatePostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
