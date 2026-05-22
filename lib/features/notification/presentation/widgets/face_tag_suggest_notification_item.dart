import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FaceTagSuggestNotificationItem extends StatelessWidget {
  final String message;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;

  const FaceTagSuggestNotificationItem({
    super.key,
    required this.message,
    required this.time,
    required this.isRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: 'assets/icons/logo.jpg',
      userId: null,
      onAvatarTap: null,
      isImageAsset: true,
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
      time: time,
      iconOverlay: const CircleAvatar(
        radius: 12,
        backgroundColor: Color(0xFF339AF0),
        child: Icon(Icons.local_offer, color: Colors.white, size: 14),
      ),
    );
  }
}
