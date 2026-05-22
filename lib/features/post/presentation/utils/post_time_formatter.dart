import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedPostTime(AppLocalizations l10n, DateTime? time) {
  if (time == null) return l10n.postUnknownTime;

  final diff = DateTime.now().difference(time);
  if (diff.inMinutes <= 0) return l10n.postJustNow;
  if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
  return l10n.timeDaysAgo(diff.inDays);
}
