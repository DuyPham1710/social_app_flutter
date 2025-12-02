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

  String formatTimeHeader() {
    final now = DateTime.now();
    final time = DateFormat('HH:mm').format(this);

    // Kiểm tra xem có phải là hôm nay không
    final isToday = year == now.year && month == now.month && day == now.day;

    // NẾU LÀ HÔM NAY: Chỉ trả về giờ
    if (isToday) {
      return time;
    }

    // NẾU LÀ NGÀY KHÁC: Trả về Thứ + LÚC + Giờ
    String weekday = '';
    switch (this.weekday) {
      case 1:
        weekday = 'T.2';
      case 2:
        weekday = 'T.3';
      case 3:
        weekday = 'T.4';
      case 4:
        weekday = 'T.5';
      case 5:
        weekday = 'T.6';
      case 6:
        weekday = 'T.7';
      case 7:
        weekday = 'CN';
    }

    return "$weekday LÚC $time";
  }
}
