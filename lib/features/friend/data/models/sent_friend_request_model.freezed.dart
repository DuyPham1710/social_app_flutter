// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sent_friend_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SentFriendRequestModel {
  @JsonKey(name: '_id')
  String get requestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  dynamic get senderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_id')
  dynamic get receiverId => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get mutualFriends => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_name', includeIfNull: false)
  String? get receiverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
  String? get receiverAvatarUrl => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get mutualFriendAvatars => throw _privateConstructorUsedError;

  /// Create a copy of SentFriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SentFriendRequestModelCopyWith<SentFriendRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SentFriendRequestModelCopyWith<$Res> {
  factory $SentFriendRequestModelCopyWith(
    SentFriendRequestModel value,
    $Res Function(SentFriendRequestModel) then,
  ) = _$SentFriendRequestModelCopyWithImpl<$Res, SentFriendRequestModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String requestId,
    @JsonKey(name: 'sender_id') dynamic senderId,
    @JsonKey(name: 'receiver_id') dynamic receiverId,
    @JsonKey(name: 'createdAt', includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(name: 'receiver_name', includeIfNull: false) String? receiverName,
    @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
    String? receiverAvatarUrl,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  });
}

/// @nodoc
class _$SentFriendRequestModelCopyWithImpl<
  $Res,
  $Val extends SentFriendRequestModel
>
    implements $SentFriendRequestModelCopyWith<$Res> {
  _$SentFriendRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SentFriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? senderId = freezed,
    Object? receiverId = freezed,
    Object? createdAt = freezed,
    Object? mutualFriends = freezed,
    Object? receiverName = freezed,
    Object? receiverAvatarUrl = freezed,
    Object? mutualFriendAvatars = freezed,
  }) {
    return _then(
      _value.copyWith(
            requestId: null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: freezed == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            receiverId: freezed == receiverId
                ? _value.receiverId
                : receiverId // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            mutualFriends: freezed == mutualFriends
                ? _value.mutualFriends
                : mutualFriends // ignore: cast_nullable_to_non_nullable
                      as int?,
            receiverName: freezed == receiverName
                ? _value.receiverName
                : receiverName // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiverAvatarUrl: freezed == receiverAvatarUrl
                ? _value.receiverAvatarUrl
                : receiverAvatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mutualFriendAvatars: freezed == mutualFriendAvatars
                ? _value.mutualFriendAvatars
                : mutualFriendAvatars // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SentFriendRequestModelImplCopyWith<$Res>
    implements $SentFriendRequestModelCopyWith<$Res> {
  factory _$$SentFriendRequestModelImplCopyWith(
    _$SentFriendRequestModelImpl value,
    $Res Function(_$SentFriendRequestModelImpl) then,
  ) = __$$SentFriendRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String requestId,
    @JsonKey(name: 'sender_id') dynamic senderId,
    @JsonKey(name: 'receiver_id') dynamic receiverId,
    @JsonKey(name: 'createdAt', includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(name: 'receiver_name', includeIfNull: false) String? receiverName,
    @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
    String? receiverAvatarUrl,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  });
}

/// @nodoc
class __$$SentFriendRequestModelImplCopyWithImpl<$Res>
    extends
        _$SentFriendRequestModelCopyWithImpl<$Res, _$SentFriendRequestModelImpl>
    implements _$$SentFriendRequestModelImplCopyWith<$Res> {
  __$$SentFriendRequestModelImplCopyWithImpl(
    _$SentFriendRequestModelImpl _value,
    $Res Function(_$SentFriendRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SentFriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? senderId = freezed,
    Object? receiverId = freezed,
    Object? createdAt = freezed,
    Object? mutualFriends = freezed,
    Object? receiverName = freezed,
    Object? receiverAvatarUrl = freezed,
    Object? mutualFriendAvatars = freezed,
  }) {
    return _then(
      _$SentFriendRequestModelImpl(
        requestId: null == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: freezed == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        receiverId: freezed == receiverId
            ? _value.receiverId
            : receiverId // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        mutualFriends: freezed == mutualFriends
            ? _value.mutualFriends
            : mutualFriends // ignore: cast_nullable_to_non_nullable
                  as int?,
        receiverName: freezed == receiverName
            ? _value.receiverName
            : receiverName // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiverAvatarUrl: freezed == receiverAvatarUrl
            ? _value.receiverAvatarUrl
            : receiverAvatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mutualFriendAvatars: freezed == mutualFriendAvatars
            ? _value._mutualFriendAvatars
            : mutualFriendAvatars // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$SentFriendRequestModelImpl extends _SentFriendRequestModel {
  _$SentFriendRequestModelImpl({
    @JsonKey(name: '_id') required this.requestId,
    @JsonKey(name: 'sender_id') required this.senderId,
    @JsonKey(name: 'receiver_id') required this.receiverId,
    @JsonKey(name: 'createdAt', includeIfNull: false) this.createdAt,
    @JsonKey(includeIfNull: false) this.mutualFriends,
    @JsonKey(name: 'receiver_name', includeIfNull: false) this.receiverName,
    @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
    this.receiverAvatarUrl,
    @JsonKey(includeIfNull: false) final List<String>? mutualFriendAvatars,
  }) : _mutualFriendAvatars = mutualFriendAvatars,
       super._();

  @override
  @JsonKey(name: '_id')
  final String requestId;
  @override
  @JsonKey(name: 'sender_id')
  final dynamic senderId;
  @override
  @JsonKey(name: 'receiver_id')
  final dynamic receiverId;
  @override
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @override
  @JsonKey(includeIfNull: false)
  final int? mutualFriends;
  @override
  @JsonKey(name: 'receiver_name', includeIfNull: false)
  final String? receiverName;
  @override
  @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
  final String? receiverAvatarUrl;
  final List<String>? _mutualFriendAvatars;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get mutualFriendAvatars {
    final value = _mutualFriendAvatars;
    if (value == null) return null;
    if (_mutualFriendAvatars is EqualUnmodifiableListView)
      return _mutualFriendAvatars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SentFriendRequestModel(requestId: $requestId, senderId: $senderId, receiverId: $receiverId, createdAt: $createdAt, mutualFriends: $mutualFriends, receiverName: $receiverName, receiverAvatarUrl: $receiverAvatarUrl, mutualFriendAvatars: $mutualFriendAvatars)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SentFriendRequestModelImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            const DeepCollectionEquality().equals(other.senderId, senderId) &&
            const DeepCollectionEquality().equals(
              other.receiverId,
              receiverId,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.mutualFriends, mutualFriends) ||
                other.mutualFriends == mutualFriends) &&
            (identical(other.receiverName, receiverName) ||
                other.receiverName == receiverName) &&
            (identical(other.receiverAvatarUrl, receiverAvatarUrl) ||
                other.receiverAvatarUrl == receiverAvatarUrl) &&
            const DeepCollectionEquality().equals(
              other._mutualFriendAvatars,
              _mutualFriendAvatars,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    requestId,
    const DeepCollectionEquality().hash(senderId),
    const DeepCollectionEquality().hash(receiverId),
    createdAt,
    mutualFriends,
    receiverName,
    receiverAvatarUrl,
    const DeepCollectionEquality().hash(_mutualFriendAvatars),
  );

  /// Create a copy of SentFriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SentFriendRequestModelImplCopyWith<_$SentFriendRequestModelImpl>
  get copyWith =>
      __$$SentFriendRequestModelImplCopyWithImpl<_$SentFriendRequestModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SentFriendRequestModel extends SentFriendRequestModel {
  factory _SentFriendRequestModel({
    @JsonKey(name: '_id') required final String requestId,
    @JsonKey(name: 'sender_id') required final dynamic senderId,
    @JsonKey(name: 'receiver_id') required final dynamic receiverId,
    @JsonKey(name: 'createdAt', includeIfNull: false) final DateTime? createdAt,
    @JsonKey(includeIfNull: false) final int? mutualFriends,
    @JsonKey(name: 'receiver_name', includeIfNull: false)
    final String? receiverName,
    @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
    final String? receiverAvatarUrl,
    @JsonKey(includeIfNull: false) final List<String>? mutualFriendAvatars,
  }) = _$SentFriendRequestModelImpl;
  _SentFriendRequestModel._() : super._();

  @override
  @JsonKey(name: '_id')
  String get requestId;
  @override
  @JsonKey(name: 'sender_id')
  dynamic get senderId;
  @override
  @JsonKey(name: 'receiver_id')
  dynamic get receiverId;
  @override
  @JsonKey(name: 'createdAt', includeIfNull: false)
  DateTime? get createdAt;
  @override
  @JsonKey(includeIfNull: false)
  int? get mutualFriends;
  @override
  @JsonKey(name: 'receiver_name', includeIfNull: false)
  String? get receiverName;
  @override
  @JsonKey(name: 'receiver_avatar_url', includeIfNull: false)
  String? get receiverAvatarUrl;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get mutualFriendAvatars;

  /// Create a copy of SentFriendRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SentFriendRequestModelImplCopyWith<_$SentFriendRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
