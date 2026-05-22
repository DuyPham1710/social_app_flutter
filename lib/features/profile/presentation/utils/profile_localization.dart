import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedRelationshipStatus(AppLocalizations l10n, String? value) {
  switch (value) {
    case 'Độc thân':
      return l10n.relationshipSingle;
    case 'Hẹn hò':
      return l10n.relationshipDating;
    case 'Đang hẹn hò':
      return l10n.relationshipInRelationship;
    case 'Đã kết hôn':
      return l10n.relationshipMarried;
    case 'Phức tạp':
      return l10n.relationshipComplicated;
    case 'Mối quan hệ mở':
      return l10n.relationshipOpen;
    case 'Ly hôn':
      return l10n.relationshipDivorced;
  }
  return value ?? '';
}
