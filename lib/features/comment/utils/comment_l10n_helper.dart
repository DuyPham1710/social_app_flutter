import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedReactionLabel(AppLocalizations l10n, String message) {
  final trimmed = message.trim();
  //lower case để so sánh, nhưng vẫn giữ nguyên message gốc để trả về nếu không khớp
  final lowerCaseMessage = trimmed.toLowerCase();
  switch (lowerCaseMessage) {
    case 'thích':
      return l10n.reactionLike;
    case 'like':
      return l10n.reactionLike;
    case 'yêu thích':
      return l10n.reactionLove;
    case 'love':
      return l10n.reactionLove;
    case 'haha':
      return l10n.reactionHaha;
    case 'wow':
      return l10n.reactionWow;
    case 'buồn':
      return l10n.reactionSad;
    case 'sad':
      return l10n.reactionSad;
    case 'phẫn nộ':
      return l10n.reactionAngry;
    case 'angry':
      return l10n.reactionAngry;
    default:
      return message; // Trả về nguyên bản nếu không khớp
  }
}