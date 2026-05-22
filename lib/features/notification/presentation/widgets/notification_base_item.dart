import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class NotificationBaseItem extends StatelessWidget {
  final String avatarUrl;
  final Widget iconOverlay;
  final Widget title;
  final String? preview;
  final String time;
  final bool isRead;
  final String? userId;
  final VoidCallback? onAvatarTap;
  final bool? isImageAsset;

  const NotificationBaseItem({
    super.key,
    required this.avatarUrl,
    required this.iconOverlay,
    required this.title,
    this.preview,
    required this.time,
    required this.isRead,
    this.userId,
    this.onAvatarTap,
    this.isImageAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead
          ? AppColors.background
          : (s1<AppPreferences>().isDarkMode
                ? AppColors.primary.withOpacity(0.12)
                : const Color(0xFFEAF3FF)), // chưa đọc
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      // ignore: sort_child_properties_last
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + icon
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                ClipOval(
                  child: isImageAsset == true
                      ? Image.asset(
                          avatarUrl,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        )
                      : (avatarUrl.isEmpty || !avatarUrl.startsWith('http')
                            ? Container(
                                width: 55,
                                height: 55,
                                color: AppColors.secondBackground,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.iconPrimary,
                                  size: 26,
                                ),
                              )
                            : Image.network(
                                avatarUrl,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 55,
                                    height: 55,
                                    color: AppColors.secondBackground,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.iconPrimary,
                                      size: 26,
                                    ),
                                  );
                                },
                              )),
                ),
                Positioned(bottom: 0, right: 0, child: iconOverlay),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,

                if (preview != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      preview!,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                const SizedBox(height: 4),
                Text(
                  time == "0 phút" ? context.l10n.postJustNow : time,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          Icon(Icons.more_horiz, color: AppColors.iconPrimary),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 2),
    );
  }
}
