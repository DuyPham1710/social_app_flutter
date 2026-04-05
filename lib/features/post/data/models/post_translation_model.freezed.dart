// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostTranslationModel _$PostTranslationModelFromJson(Map<String, dynamic> json) {
  return _PostTranslationModel.fromJson(json);
}

/// @nodoc
mixin _$PostTranslationModel {
  String get originalCaption => throw _privateConstructorUsedError;
  String get translatedCaption => throw _privateConstructorUsedError;
  String get sourceLang => throw _privateConstructorUsedError;
  String get targetLang => throw _privateConstructorUsedError;
  bool get translationNotNeeded => throw _privateConstructorUsedError;

  /// Serializes this PostTranslationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostTranslationModelCopyWith<PostTranslationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostTranslationModelCopyWith<$Res> {
  factory $PostTranslationModelCopyWith(
    PostTranslationModel value,
    $Res Function(PostTranslationModel) then,
  ) = _$PostTranslationModelCopyWithImpl<$Res, PostTranslationModel>;
  @useResult
  $Res call({
    String originalCaption,
    String translatedCaption,
    String sourceLang,
    String targetLang,
    bool translationNotNeeded,
  });
}

/// @nodoc
class _$PostTranslationModelCopyWithImpl<
  $Res,
  $Val extends PostTranslationModel
>
    implements $PostTranslationModelCopyWith<$Res> {
  _$PostTranslationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalCaption = null,
    Object? translatedCaption = null,
    Object? sourceLang = null,
    Object? targetLang = null,
    Object? translationNotNeeded = null,
  }) {
    return _then(
      _value.copyWith(
            originalCaption: null == originalCaption
                ? _value.originalCaption
                : originalCaption // ignore: cast_nullable_to_non_nullable
                      as String,
            translatedCaption: null == translatedCaption
                ? _value.translatedCaption
                : translatedCaption // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceLang: null == sourceLang
                ? _value.sourceLang
                : sourceLang // ignore: cast_nullable_to_non_nullable
                      as String,
            targetLang: null == targetLang
                ? _value.targetLang
                : targetLang // ignore: cast_nullable_to_non_nullable
                      as String,
            translationNotNeeded: null == translationNotNeeded
                ? _value.translationNotNeeded
                : translationNotNeeded // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostTranslationModelImplCopyWith<$Res>
    implements $PostTranslationModelCopyWith<$Res> {
  factory _$$PostTranslationModelImplCopyWith(
    _$PostTranslationModelImpl value,
    $Res Function(_$PostTranslationModelImpl) then,
  ) = __$$PostTranslationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String originalCaption,
    String translatedCaption,
    String sourceLang,
    String targetLang,
    bool translationNotNeeded,
  });
}

/// @nodoc
class __$$PostTranslationModelImplCopyWithImpl<$Res>
    extends _$PostTranslationModelCopyWithImpl<$Res, _$PostTranslationModelImpl>
    implements _$$PostTranslationModelImplCopyWith<$Res> {
  __$$PostTranslationModelImplCopyWithImpl(
    _$PostTranslationModelImpl _value,
    $Res Function(_$PostTranslationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalCaption = null,
    Object? translatedCaption = null,
    Object? sourceLang = null,
    Object? targetLang = null,
    Object? translationNotNeeded = null,
  }) {
    return _then(
      _$PostTranslationModelImpl(
        originalCaption: null == originalCaption
            ? _value.originalCaption
            : originalCaption // ignore: cast_nullable_to_non_nullable
                  as String,
        translatedCaption: null == translatedCaption
            ? _value.translatedCaption
            : translatedCaption // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceLang: null == sourceLang
            ? _value.sourceLang
            : sourceLang // ignore: cast_nullable_to_non_nullable
                  as String,
        targetLang: null == targetLang
            ? _value.targetLang
            : targetLang // ignore: cast_nullable_to_non_nullable
                  as String,
        translationNotNeeded: null == translationNotNeeded
            ? _value.translationNotNeeded
            : translationNotNeeded // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostTranslationModelImpl implements _PostTranslationModel {
  const _$PostTranslationModelImpl({
    required this.originalCaption,
    required this.translatedCaption,
    required this.sourceLang,
    required this.targetLang,
    this.translationNotNeeded = false,
  });

  factory _$PostTranslationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostTranslationModelImplFromJson(json);

  @override
  final String originalCaption;
  @override
  final String translatedCaption;
  @override
  final String sourceLang;
  @override
  final String targetLang;
  @override
  @JsonKey()
  final bool translationNotNeeded;

  @override
  String toString() {
    return 'PostTranslationModel(originalCaption: $originalCaption, translatedCaption: $translatedCaption, sourceLang: $sourceLang, targetLang: $targetLang, translationNotNeeded: $translationNotNeeded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostTranslationModelImpl &&
            (identical(other.originalCaption, originalCaption) ||
                other.originalCaption == originalCaption) &&
            (identical(other.translatedCaption, translatedCaption) ||
                other.translatedCaption == translatedCaption) &&
            (identical(other.sourceLang, sourceLang) ||
                other.sourceLang == sourceLang) &&
            (identical(other.targetLang, targetLang) ||
                other.targetLang == targetLang) &&
            (identical(other.translationNotNeeded, translationNotNeeded) ||
                other.translationNotNeeded == translationNotNeeded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    originalCaption,
    translatedCaption,
    sourceLang,
    targetLang,
    translationNotNeeded,
  );

  /// Create a copy of PostTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostTranslationModelImplCopyWith<_$PostTranslationModelImpl>
  get copyWith =>
      __$$PostTranslationModelImplCopyWithImpl<_$PostTranslationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PostTranslationModelImplToJson(this);
  }
}

abstract class _PostTranslationModel implements PostTranslationModel {
  const factory _PostTranslationModel({
    required final String originalCaption,
    required final String translatedCaption,
    required final String sourceLang,
    required final String targetLang,
    final bool translationNotNeeded,
  }) = _$PostTranslationModelImpl;

  factory _PostTranslationModel.fromJson(Map<String, dynamic> json) =
      _$PostTranslationModelImpl.fromJson;

  @override
  String get originalCaption;
  @override
  String get translatedCaption;
  @override
  String get sourceLang;
  @override
  String get targetLang;
  @override
  bool get translationNotNeeded;

  /// Create a copy of PostTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostTranslationModelImplCopyWith<_$PostTranslationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
