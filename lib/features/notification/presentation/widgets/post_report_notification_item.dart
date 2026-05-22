import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class PostReportNotificationItem extends StatelessWidget {
  final String message;
  final String? note;
  final String time;
  final bool isRead;
  final String? postId;
  final VoidCallback? onTap;

  const PostReportNotificationItem({
    super.key,
    required this.message,
    this.note,
    required this.time,
    required this.isRead,
    this.postId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl:
          'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg', // System/Admin avatar
      userId: null,
      onAvatarTap: null, // Không có action cho avatar
      title: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          children: [
            TextSpan(
              text: '${context.l10n.commonSystem} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: message,
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
      preview: note != null && note!.isNotEmpty ? note : null,
      time: time,
      iconOverlay: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.red,
        child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 16),
      ),
    );
  }
}
