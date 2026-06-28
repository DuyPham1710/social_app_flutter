import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedPostTime(AppLocalizations l10n, DateTime? time) {
  if (time == null) return l10n.postUnknownTime;

  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inDays <= 30) {
    if (diff.inMinutes <= 0) return l10n.postJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    return l10n.timeDaysAgo(diff.inDays);
  }

  String dayStr = time.day.toString();
  String monthStr = time.month.toString();

  if (l10n.localeName == 'en') {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    monthStr = months[time.month - 1];
    
    if (time.day >= 11 && time.day <= 13) {
      dayStr = '${time.day}th';
    } else {
      switch (time.day % 10) {
        case 1: dayStr = '${time.day}st'; break;
        case 2: dayStr = '${time.day}nd'; break;
        case 3: dayStr = '${time.day}rd'; break;
        default: dayStr = '${time.day}th'; break;
      }
    }
  }

  if (time.year < now.year) {
    return l10n.timeDayMonthYear(
      time.day.toString().padLeft(2, '0'),
      time.month.toString().padLeft(2, '0'),
      time.year.toString(),
    );
  }

  return l10n.timeDayMonth(dayStr, monthStr);
}
