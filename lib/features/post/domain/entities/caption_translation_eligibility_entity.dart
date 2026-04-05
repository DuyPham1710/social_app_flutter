class CaptionTranslationEligibilityEntity {
  final bool translationNotNeeded;
  final String sourceLang;
  final String targetLang;

  const CaptionTranslationEligibilityEntity({
    required this.translationNotNeeded,
    required this.sourceLang,
    required this.targetLang,
  });
}
