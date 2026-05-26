import 'package:social_app_fe/l10n/generated/app_localizations.dart';

String localizedCommunityTimeAgo(AppLocalizations l10n, DateTime? value) {
  if (value == null) {
    return l10n.postUnknownTime;
  }

  final diff = DateTime.now().difference(value.toLocal());

  if (diff.inSeconds < 60) {
    return l10n.postJustNow;
  }
  if (diff.inMinutes < 60) {
    return l10n.timeMinutesAgo(diff.inMinutes);
  }
  if (diff.inHours < 24) {
    return l10n.timeHoursAgo(diff.inHours);
  }
  if (diff.inDays < 7) {
    return l10n.timeDaysAgo(diff.inDays);
  }

  final date = value.toLocal();
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String localizedCommunityMessage(AppLocalizations l10n, String message) {
  final trimmed = message.trim();

  switch (trimmed) {
    case 'Tạo cộng đồng thành công':
      return l10n.communityCreateSuccess;
    case 'Cập nhật cộng đồng thành công':
      return l10n.communityUpdateSuccess;
    case 'Đã gửi yêu cầu tham gia cộng đồng':
      return l10n.communityJoinRequestSent;
    case 'Đã rời khỏi cộng đồng':
      return l10n.communityLeaveSuccess;
    case 'Đã hủy yêu cầu tham gia':
      return l10n.communityCancelRequestSuccess;
    case 'Đã chấp nhận lời mời':
      return l10n.notificationInviteAccepted;
    case 'Đã từ chối lời mời':
      return l10n.notificationInviteRejected;
    case 'Đã xóa cộng đồng thành công':
      return l10n.communityDeleteSuccess;
    case 'Không thể tải lời mời':
      return l10n.communityLoadInvitesFailed;
    case 'Không thể xử lý lời mời':
      return l10n.communityHandleInviteFailed;
    case 'Đã chấp nhận yêu cầu':
      return l10n.communityJoinRequestAccepted;
    case 'Đã từ chối yêu cầu':
      return l10n.communityJoinRequestRejected;
    case 'Đã duyệt bài viết':
      return l10n.communityPostApprovedSuccess;
    case 'Đã từ chối bài viết':
      return l10n.communityPostRejectedSuccess;
    case 'Đã xóa thành viên':
      return l10n.communityMemberRemoved;
    case 'Đã nâng quyền thành viên':
      return l10n.communityMemberPromoted;
    case 'Đã hạ quyền admin':
      return l10n.communityAdminDemoted;
    case 'Lỗi khi tải danh sách bạn bè':
      return l10n.communityLoadFriendsFailed;
    case 'Đã gửi lời mời thành công':
      return l10n.communityInviteSentSuccess;
    case 'Không thể gửi lời mời':
      return l10n.communityInviteSendFailed;
    case 'Đã xảy ra lỗi':
      return l10n.commonUnknownError;
    default:
      if (trimmed.startsWith('Đã xảy ra lỗi: ')) {
        return l10n.commonErrorWithMessage(
          trimmed.substring('Đã xảy ra lỗi: '.length),
        );
      }
      return message;
  }
}
