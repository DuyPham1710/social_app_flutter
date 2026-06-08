import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityPostApprovedNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String time;
  final bool isRead;
  final String? message;
  final VoidCallback? onUserTap;
  final VoidCallback? onViewPost;
  final VoidCallback? onCommunityTap;
  final String actionText;

  const CommunityPostApprovedNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.communityName,
    required this.time,
    required this.isRead,
    this.message,
    this.onUserTap,
    this.onViewPost,
    this.onCommunityTap,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewPost,
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
                  // Icon overlay for approved
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.check_circle,
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
                      final msg = actionText;

                      final List<TextSpan> spans = [];

                      //message bấm vào là xem bài viết
                      spans.add(
                        TextSpan(
                          text: '$msg ',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onViewPost,
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
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_horiz, color: AppColors.iconPrimary),
          ],
        ),
      ),
    );
  }
}
