import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedReactionLabel(AppLocalizations l10n, String message) {
  final trimmed = message.trim();

  switch (trimmed) {
    case 'Thích':
      return l10n.reactionLike;
    case 'Yêu thích':
      return l10n.reactionLove;
    case 'Haha':
      return l10n.reactionHaha;
    case 'Wow':
      return l10n.reactionWow;
    case 'Buồn':
      return l10n.reactionSad;
    case 'Phẫn nộ':
      return l10n.reactionAngry;
    default:
      return message; // Trả về nguyên bản nếu không khớp
  }
}