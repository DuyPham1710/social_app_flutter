import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/post/domain/entities/post_translation_entity.dart';

part 'post_translation_model.freezed.dart';
part 'post_translation_model.g.dart';

@freezed
class PostTranslationModel extends PostTranslationEntity
    with _$PostTranslationModel {
  const factory PostTranslationModel({
    required String originalCaption,
    required String translatedCaption,
    required String sourceLang,
    required String targetLang,
    @Default(false) bool translationNotNeeded,
  }) = _PostTranslationModel;

  factory PostTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$PostTranslationModelFromJson(json);
}
