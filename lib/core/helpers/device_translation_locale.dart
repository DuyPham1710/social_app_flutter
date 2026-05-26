import 'package:flutter/material.dart' show BuildContext, Localizations, Locale;
import 'dart:ui' show PlatformDispatcher;

/// Mã ngôn ngữ đích gửi lên API dịch (BCP 47), theo locale hệ thống.
String deviceTranslationTargetLang() {
  final locale = PlatformDispatcher.instance.locale;
  return localeToTranslationTarget(locale);
}

/// Mã ngôn ngữ đích gửi lên API dịch (BCP 47), theo locale của app.
String appTranslationTargetLang(BuildContext context) {
  final locale = Localizations.localeOf(context);
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
