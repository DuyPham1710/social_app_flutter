import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommunityNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String time;
  final bool isRead;
  final String notificationType;
  final VoidCallback? onUserTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const CommunityNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.communityName,
    required this.time,
    required this.isRead,
    required this.notificationType,
    this.onUserTap,
    this.onAccept,
    this.onReject,
  });

  String _getNotificationTitle() {
    switch (notificationType) {
      case 'COMMUNITY_JOIN_REQUEST':
        return '$userName đã gửi yêu cầu tham gia cộng đồng';
      case 'COMMUNITY_INVITE':
        return '$userName đã mời bạn tham gia cộng đồng';
      case 'COMMUNITY_POST_REJECTED':
        return 'Bài viết của bạn đã bị từ chối';
      case 'COMMUNITY_POST_APPROVED':
        return 'Bài viết của bạn đã được duyệt';
      case 'COMMUNITY_NEW_POST':
        return 'Có bài viết mới trong nhóm';
      default:
        return 'Thông báo từ cộng đồng';
    }
  }

  bool _hasActionButtons() {
    return notificationType == 'COMMUNITY_INVITE' ||
        notificationType == 'COMMUNITY_JOIN_REQUEST';
  }

  String _getAcceptButtonText() {
    if (notificationType == 'COMMUNITY_JOIN_REQUEST') {
      return 'Phê duyệt';
    }
    return 'Chấp nhận';
  }

  String _getRejectButtonText() {
    if (notificationType == 'COMMUNITY_JOIN_REQUEST') {
      return 'Từ chối';
    }
    return 'Xóa';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFEAF3FF), // màu nền khi chưa đọc
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + icon overlay
          GestureDetector(
            onTap: onUserTap,
            child: Stack(
              children: [
                ClipOval(
                  child: Image.network(
                    avatarUrl,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return CircleAvatar(
                        radius: 29,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person),
                      );
                    },
                  ),
                ),
                if (_hasActionButtons())
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        notificationType == 'COMMUNITY_INVITE'
                            ? Icons.group_add
                            : Icons.check,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _getNotificationTitle(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = onUserTap,
                      ),
                      TextSpan(
                        text: ' • $communityName',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  time == "0 phút" ? "Vừa xong" : time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                if (_hasActionButtons()) ...[
                  const SizedBox(height: 12),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            _getAcceptButtonText(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: onReject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            _getRejectButtonText(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 5),
          const Icon(Icons.more_horiz),
        ],
      ),

      // khoảng cách giữa các item
      margin: const EdgeInsets.only(bottom: 4),
    );
  }
}
