import 'package:social_app_fe/features/post/domain/entities/caption_translation_eligibility_entity.dart';

/// Kết quả kiểm tra có cần dịch caption hay không (ngôn ngữ nguồn vs ngôn ngữ máy).
class CaptionTranslationEligibilityModel
    extends CaptionTranslationEligibilityEntity {
  const CaptionTranslationEligibilityModel({
    required super.translationNotNeeded,
    required super.sourceLang,
    required super.targetLang,
  });

  factory CaptionTranslationEligibilityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CaptionTranslationEligibilityModel(
      translationNotNeeded: json['translationNotNeeded'] as bool? ?? false,
      sourceLang: json['sourceLang'] as String? ?? 'und',
      targetLang: json['targetLang'] as String? ?? 'en',
    );
  }
}
