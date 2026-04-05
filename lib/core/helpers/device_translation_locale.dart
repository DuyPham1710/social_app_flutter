import 'dart:ui' show PlatformDispatcher, Locale;

/// Mã ngôn ngữ đích gửi lên API dịch (BCP 47), theo locale hệ thống.
String deviceTranslationTargetLang() {
  final locale = PlatformDispatcher.instance.locale;
  return localeToTranslationTarget(locale);
}

/// Ánh xạ [Locale] sang mã gần với Google Cloud Translation `target`.
String localeToTranslationTarget(Locale locale) {
  final tag = locale.toLanguageTag();
  if (tag.isNotEmpty) {
    return tag;
  }
  final lang = locale.languageCode;
  if (lang.isEmpty) return 'en';
  return lang;
}
