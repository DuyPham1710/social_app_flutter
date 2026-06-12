import 'package:equatable/equatable.dart';

class MessageTranslationEntity extends Equatable {
  final String originalText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final bool translationNotNeeded;

  const MessageTranslationEntity({
    required this.originalText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.translationNotNeeded,
  });

  @override
  List<Object?> get props => [
        originalText,
        translatedText,
        sourceLang,
        targetLang,
        translationNotNeeded,
      ];
}
