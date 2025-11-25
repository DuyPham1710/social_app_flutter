import 'package:intl/intl.dart';

extension ChatTimeFormat on DateTime {
  String formatChatTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final date = DateTime(year, month, day);

    if (date == today) {
      // hôm nay -> hh:mm
      return DateFormat('HH:mm').format(this);
    } else if (date == yesterday) {
      return 'Hôm qua';
    } else {
      // khác -> T2, T3,... CN
      final weekdayMap = {
        DateTime.monday: 'T2',
        DateTime.tuesday: 'T3',
        DateTime.wednesday: 'T4',
        DateTime.thursday: 'T5',
        DateTime.friday: 'T6',
        DateTime.saturday: 'T7',
        DateTime.sunday: 'CN',
      };
      return weekdayMap[weekday] ?? '';
    }
  }
}
