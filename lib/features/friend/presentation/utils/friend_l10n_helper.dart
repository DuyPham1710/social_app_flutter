import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedFriendTimeAgo(AppLocalizations l10n, DateTime? time) {
  if (time == null) return l10n.postJustNow;

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

String localizedFriendActionMessage(AppLocalizations l10n, String message) {
  switch (message) {
    case 'Đã gửi lời mời kết bạn':
      return l10n.friendRequestSent;
    case 'Đã chấp nhận lời mời kết bạn':
      return l10n.friendRequestAccepted;
    case 'Đã từ chối lời mời kết bạn':
      return l10n.friendRequestRejected;
    case 'Đã hủy yêu cầu':
      return l10n.friendRequestCancelled;
    case 'Không thể tải danh sách bạn bè':
      return l10n.friendLoadFriendsFailed;
    case 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.':
      return l10n.commonSessionExpired;
    case 'Lỗi máy chủ. Vui lòng thử lại sau.':
      return l10n.commonServerErrorRetryLater;
    case 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.':
      return l10n.commonUnexpectedErrorRetry;
    case 'Lỗi không xác định khi tải gợi ý bạn bè':
      return l10n.friendLoadSuggestionsUnknownError;
    case 'Lỗi không xác định':
      return l10n.commonUnknownError;
    default:
      return message;
  }
}
