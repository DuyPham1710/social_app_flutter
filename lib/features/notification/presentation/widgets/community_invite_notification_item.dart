import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityInviteNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String? message;
  final String time;
  final bool isRead;
  final VoidCallback? onUserTap;
  final VoidCallback? onCommunityTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const CommunityInviteNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.communityName,
    this.message,
    required this.time,
    required this.isRead,
    this.onUserTap,
    this.onCommunityTap,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCommunityTap,
      child: Container(
        color: isRead
            ? AppColors.background
            : (s1<AppPreferences>().isDarkMode
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : const Color(0xFFEAF3FF)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with icon overlay
          GestureDetector(
            onTap: onUserTap,
            child: Stack(
              children: [
                ClipOval(
                  child: (avatarUrl.isEmpty || !avatarUrl.startsWith('http'))
                      ? CircleAvatar(
                          radius: 29,
                          backgroundColor: AppColors.secondBackground,
                          child: Icon(
                            Icons.person,
                            color: AppColors.iconPrimary,
                          ),
                        )
                      : Image.network(
                          avatarUrl,
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              radius: 29,
                              backgroundColor: AppColors.secondBackground,
                              child: Icon(
                                Icons.person,
                                color: AppColors.iconPrimary,
                              ),
                            );
                          },
                        ),
                ),
                // Icon overlay for invite
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.mail_outline,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final msg = context.l10n.notificationInviteMessage;

                    final List<TextSpan> spans = [];
                    spans.add(
                      TextSpan(
                        text: userName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = onUserTap,
                      ),
                    );
                    spans.add(
                      TextSpan(
                        text: ' $msg ',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    );
                    spans.add(
                      TextSpan(
                        text: communityName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onCommunityTap,
                      ),
                    );
                    return RichText(text: TextSpan(children: spans));
                  },
                ),

                const SizedBox(height: 6),

                Text(
                  time == "0 phút" ? context.l10n.postJustNow : time,
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 12),

                // Action buttons
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
                          context.l10n.friendAccept,
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
                          backgroundColor: AppColors.secondBackground,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          context.l10n.friendDelete,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),
          Icon(Icons.more_horiz, color: AppColors.iconPrimary),
        ],
      ),
    ),
    );
  }
}
