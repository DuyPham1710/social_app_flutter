// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RelationshipStatusModel _$RelationshipStatusModelFromJson(
  Map<String, dynamic> json,
) {
  return _RelationshipStatusModel.fromJson(json);
}

/// @nodoc
mixin _$RelationshipStatusModel {
  String get status => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get requestId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get canSendRequest => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get canCancelRequest => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get canAcceptRequest => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get canRejectRequest => throw _privateConstructorUsedError;

  /// Serializes this RelationshipStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RelationshipStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RelationshipStatusModelCopyWith<RelationshipStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipStatusModelCopyWith<$Res> {
  factory $RelationshipStatusModelCopyWith(
    RelationshipStatusModel value,
    $Res Function(RelationshipStatusModel) then,
  ) = _$RelationshipStatusModelCopyWithImpl<$Res, RelationshipStatusModel>;
  @useResult
  $Res call({
    String status,
    @JsonKey(includeIfNull: false) String? requestId,
    @JsonKey(includeIfNull: false) bool? canSendRequest,
    @JsonKey(includeIfNull: false) bool? canCancelRequest,
    @JsonKey(includeIfNull: false) bool? canAcceptRequest,
    @JsonKey(includeIfNull: false) bool? canRejectRequest,
  });
}

/// @nodoc
class _$RelationshipStatusModelCopyWithImpl<
  $Res,
  $Val extends RelationshipStatusModel
>
    implements $RelationshipStatusModelCopyWith<$Res> {
  _$RelationshipStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RelationshipStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? requestId = freezed,
    Object? canSendRequest = freezed,
    Object? canCancelRequest = freezed,
    Object? canAcceptRequest = freezed,
    Object? canRejectRequest = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            requestId: freezed == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String?,
            canSendRequest: freezed == canSendRequest
                ? _value.canSendRequest
                : canSendRequest // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canCancelRequest: freezed == canCancelRequest
                ? _value.canCancelRequest
                : canCancelRequest // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canAcceptRequest: freezed == canAcceptRequest
                ? _value.canAcceptRequest
                : canAcceptRequest // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canRejectRequest: freezed == canRejectRequest
                ? _value.canRejectRequest
                : canRejectRequest // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RelationshipStatusModelImplCopyWith<$Res>
    implements $RelationshipStatusModelCopyWith<$Res> {
  factory _$$RelationshipStatusModelImplCopyWith(
    _$RelationshipStatusModelImpl value,
    $Res Function(_$RelationshipStatusModelImpl) then,
  ) = __$$RelationshipStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(includeIfNull: false) String? requestId,
    @JsonKey(includeIfNull: false) bool? canSendRequest,
    @JsonKey(includeIfNull: false) bool? canCancelRequest,
    @JsonKey(includeIfNull: false) bool? canAcceptRequest,
    @JsonKey(includeIfNull: false) bool? canRejectRequest,
  });
}

/// @nodoc
class __$$RelationshipStatusModelImplCopyWithImpl<$Res>
    extends
        _$RelationshipStatusModelCopyWithImpl<
          $Res,
          _$RelationshipStatusModelImpl
        >
    implements _$$RelationshipStatusModelImplCopyWith<$Res> {
  __$$RelationshipStatusModelImplCopyWithImpl(
    _$RelationshipStatusModelImpl _value,
    $Res Function(_$RelationshipStatusModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RelationshipStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? requestId = freezed,
    Object? canSendRequest = freezed,
    Object? canCancelRequest = freezed,
    Object? canAcceptRequest = freezed,
    Object? canRejectRequest = freezed,
  }) {
    return _then(
      _$RelationshipStatusModelImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        requestId: freezed == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String?,
        canSendRequest: freezed == canSendRequest
            ? _value.canSendRequest
            : canSendRequest // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canCancelRequest: freezed == canCancelRequest
            ? _value.canCancelRequest
            : canCancelRequest // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canAcceptRequest: freezed == canAcceptRequest
            ? _value.canAcceptRequest
            : canAcceptRequest // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canRejectRequest: freezed == canRejectRequest
            ? _value.canRejectRequest
            : canRejectRequest // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationshipStatusModelImpl implements _RelationshipStatusModel {
  const _$RelationshipStatusModelImpl({
    required this.status,
    @JsonKey(includeIfNull: false) this.requestId,
    @JsonKey(includeIfNull: false) this.canSendRequest,
    @JsonKey(includeIfNull: false) this.canCancelRequest,
    @JsonKey(includeIfNull: false) this.canAcceptRequest,
    @JsonKey(includeIfNull: false) this.canRejectRequest,
  });

  factory _$RelationshipStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationshipStatusModelImplFromJson(json);

  @override
  final String status;
  @override
  @JsonKey(includeIfNull: false)
  final String? requestId;
  @override
  @JsonKey(includeIfNull: false)
  final bool? canSendRequest;
  @override
  @JsonKey(includeIfNull: false)
  final bool? canCancelRequest;
  @override
  @JsonKey(includeIfNull: false)
  final bool? canAcceptRequest;
  @override
  @JsonKey(includeIfNull: false)
  final bool? canRejectRequest;

  @override
  String toString() {
    return 'RelationshipStatusModel(status: $status, requestId: $requestId, canSendRequest: $canSendRequest, canCancelRequest: $canCancelRequest, canAcceptRequest: $canAcceptRequest, canRejectRequest: $canRejectRequest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationshipStatusModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.canSendRequest, canSendRequest) ||
                other.canSendRequest == canSendRequest) &&
            (identical(other.canCancelRequest, canCancelRequest) ||
                other.canCancelRequest == canCancelRequest) &&
            (identical(other.canAcceptRequest, canAcceptRequest) ||
                other.canAcceptRequest == canAcceptRequest) &&
            (identical(other.canRejectRequest, canRejectRequest) ||
                other.canRejectRequest == canRejectRequest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    requestId,
    canSendRequest,
    canCancelRequest,
    canAcceptRequest,
    canRejectRequest,
  );

  /// Create a copy of RelationshipStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationshipStatusModelImplCopyWith<_$RelationshipStatusModelImpl>
  get copyWith =>
      __$$RelationshipStatusModelImplCopyWithImpl<
        _$RelationshipStatusModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationshipStatusModelImplToJson(this);
  }
}

abstract class _RelationshipStatusModel implements RelationshipStatusModel {
  const factory _RelationshipStatusModel({
    required final String status,
    @JsonKey(includeIfNull: false) final String? requestId,
    @JsonKey(includeIfNull: false) final bool? canSendRequest,
    @JsonKey(includeIfNull: false) final bool? canCancelRequest,
    @JsonKey(includeIfNull: false) final bool? canAcceptRequest,
    @JsonKey(includeIfNull: false) final bool? canRejectRequest,
  }) = _$RelationshipStatusModelImpl;

  factory _RelationshipStatusModel.fromJson(Map<String, dynamic> json) =
      _$RelationshipStatusModelImpl.fromJson;

  @override
  String get status;
  @override
  @JsonKey(includeIfNull: false)
  String? get requestId;
  @override
  @JsonKey(includeIfNull: false)
  bool? get canSendRequest;
  @override
  @JsonKey(includeIfNull: false)
  bool? get canCancelRequest;
  @override
  @JsonKey(includeIfNull: false)
  bool? get canAcceptRequest;
  @override
  @JsonKey(includeIfNull: false)
  bool? get canRejectRequest;

  /// Create a copy of RelationshipStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RelationshipStatusModelImplCopyWith<_$RelationshipStatusModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
