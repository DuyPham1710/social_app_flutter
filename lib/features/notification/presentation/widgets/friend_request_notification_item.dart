import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendRequestNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String time;
  final bool isRead;
  final String? mutualFriends;
  final VoidCallback? onUserTap;
  final VoidCallback? onAccept;
  final VoidCallback? onRemove;

  const FriendRequestNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.time,
    required this.isRead,
    this.mutualFriends,
    this.onUserTap,
    this.onAccept,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead
          ? AppColors.background
          : (s1<AppPreferences>().isDarkMode
                ? AppColors.primary.withOpacity(0.12)
                : const Color(0xFFEAF3FF)), // màu nền khi chưa đọc
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      // ignore: sort_child_properties_last
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + icon overlay
          GestureDetector(
            onTap: onUserTap,
            child: Stack(
              children: [
                ClipOval(
                  child: (avatarUrl.isEmpty || !avatarUrl.startsWith('http'))
                      ? Container(
                          width: 58,
                          height: 58,
                          color: AppColors.secondBackground,
                          child: Icon(
                            Icons.person,
                            color: AppColors.iconPrimary,
                            size: 28,
                          ),
                        )
                      : Image.network(
                          avatarUrl,
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 58,
                              height: 58,
                              color: AppColors.secondBackground,
                              child: Icon(
                                Icons.person,
                                color: AppColors.iconPrimary,
                                size: 28,
                              ),
                            );
                          },
                        ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.person_add,
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
                        text: userName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = onUserTap,
                      ),
                      TextSpan(
                        text: context.l10n.notificationFriendRequestMessage,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print('Tapped on action text'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      time == "0 phút" ? context.l10n.postJustNow : time,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),

                if (mutualFriends != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      mutualFriends!,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),

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
                          context.l10n.commonConfirm,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: onRemove,
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
                            fontSize: 16,
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

      //khoảng cách giữa các item
      margin: const EdgeInsets.only(bottom: 4),
    );
  }
}
