// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemberStatusModel _$MemberStatusModelFromJson(Map<String, dynamic> json) {
  return _MemberStatusModel.fromJson(json);
}

/// @nodoc
mixin _$MemberStatusModel {
  String get status =>
      throw _privateConstructorUsedError; // 'member', 'invited', 'pending', 'none'
  String? get role => throw _privateConstructorUsedError;

  /// Serializes this MemberStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberStatusModelCopyWith<MemberStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberStatusModelCopyWith<$Res> {
  factory $MemberStatusModelCopyWith(
    MemberStatusModel value,
    $Res Function(MemberStatusModel) then,
  ) = _$MemberStatusModelCopyWithImpl<$Res, MemberStatusModel>;
  @useResult
  $Res call({String status, String? role});
}

/// @nodoc
class _$MemberStatusModelCopyWithImpl<$Res, $Val extends MemberStatusModel>
    implements $MemberStatusModelCopyWith<$Res> {
  _$MemberStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? role = freezed}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberStatusModelImplCopyWith<$Res>
    implements $MemberStatusModelCopyWith<$Res> {
  factory _$$MemberStatusModelImplCopyWith(
    _$MemberStatusModelImpl value,
    $Res Function(_$MemberStatusModelImpl) then,
  ) = __$$MemberStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String? role});
}

/// @nodoc
class __$$MemberStatusModelImplCopyWithImpl<$Res>
    extends _$MemberStatusModelCopyWithImpl<$Res, _$MemberStatusModelImpl>
    implements _$$MemberStatusModelImplCopyWith<$Res> {
  __$$MemberStatusModelImplCopyWithImpl(
    _$MemberStatusModelImpl _value,
    $Res Function(_$MemberStatusModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? role = freezed}) {
    return _then(
      _$MemberStatusModelImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberStatusModelImpl implements _MemberStatusModel {
  const _$MemberStatusModelImpl({required this.status, required this.role});

  factory _$MemberStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberStatusModelImplFromJson(json);

  @override
  final String status;
  // 'member', 'invited', 'pending', 'none'
  @override
  final String? role;

  @override
  String toString() {
    return 'MemberStatusModel(status: $status, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberStatusModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, role);

  /// Create a copy of MemberStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberStatusModelImplCopyWith<_$MemberStatusModelImpl> get copyWith =>
      __$$MemberStatusModelImplCopyWithImpl<_$MemberStatusModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberStatusModelImplToJson(this);
  }
}

abstract class _MemberStatusModel implements MemberStatusModel {
  const factory _MemberStatusModel({
    required final String status,
    required final String? role,
  }) = _$MemberStatusModelImpl;

  factory _MemberStatusModel.fromJson(Map<String, dynamic> json) =
      _$MemberStatusModelImpl.fromJson;

  @override
  String get status; // 'member', 'invited', 'pending', 'none'
  @override
  String? get role;

  /// Create a copy of MemberStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberStatusModelImplCopyWith<_$MemberStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
