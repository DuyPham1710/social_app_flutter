class PostTranslationEntity {
  final String originalCaption;
  final String translatedCaption;
  final String sourceLang;
  final String targetLang;

  const PostTranslationEntity({
    required this.originalCaption,
    required this.translatedCaption,
    required this.sourceLang,
    required this.targetLang,
  });
}

