// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostTranslationModelImpl _$$PostTranslationModelImplFromJson(
  Map<String, dynamic> json,
) => _$PostTranslationModelImpl(
  originalCaption: json['originalCaption'] as String,
  translatedCaption: json['translatedCaption'] as String,
  sourceLang: json['sourceLang'] as String,
  targetLang: json['targetLang'] as String,
);

Map<String, dynamic> _$$PostTranslationModelImplToJson(
  _$PostTranslationModelImpl instance,
) => <String, dynamic>{
  'originalCaption': instance.originalCaption,
  'translatedCaption': instance.translatedCaption,
  'sourceLang': instance.sourceLang,
  'targetLang': instance.targetLang,
};
