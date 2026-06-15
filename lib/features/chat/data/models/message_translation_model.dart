import '../../domain/entities/message_translation_entity.dart';

class MessageTranslationModel extends MessageTranslationEntity {
  const MessageTranslationModel({
    required super.originalText,
    required super.translatedText,
    required super.sourceLang,
    required super.targetLang,
    required super.translationNotNeeded,
  });

  factory MessageTranslationModel.fromJson(Map<String, dynamic> json) {
    return MessageTranslationModel(
      originalText: json['originalText'] as String? ?? '',
      translatedText: json['translatedText'] as String? ?? '',
      sourceLang: json['sourceLang'] as String? ?? '',
      targetLang: json['targetLang'] as String? ?? '',
      translationNotNeeded: json['translationNotNeeded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'originalText': originalText,
        'translatedText': translatedText,
        'sourceLang': sourceLang,
        'targetLang': targetLang,
        'translationNotNeeded': translationNotNeeded,
      };
}
