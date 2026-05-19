import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';

class CommunityPostPendingNotificationItem extends StatelessWidget {
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
  final VoidCallback? onReviewTap;

  const CommunityPostPendingNotificationItem({
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
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewPost,
      child: Container(
        color: isRead
            ? AppColors.background
            : (s1<AppPreferences>().isDarkMode
                ? const Color(0xFFE6A23C).withOpacity(0.15)
                : const Color(0xFFFFF7E8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onUserTap,
              child: Stack(
                children: [
                  ClipOval(
                    child: (avatarUrl.isEmpty || !avatarUrl.startsWith('http'))
                        ? CircleAvatar(
                            radius: 29,
                            backgroundColor: AppColors.secondBackground,
                            child: Icon(Icons.person, color: AppColors.iconPrimary),
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
                                child: Icon(Icons.person, color: AppColors.iconPrimary),
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
                      backgroundColor: const Color.fromARGB(255, 218, 135, 12),
                      child: const Icon(
                        Icons.hourglass_top,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      final msg =
                          message ?? ' gửi yêu cầu đăng bài vào cộng đồng';
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
                          text: msg,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
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
                      //text căn 2 bên
                      return RichText(
                        text: TextSpan(children: spans),
                        textAlign: TextAlign.justify,
                      );
                    },
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        time == "0 phút" ? "Vừa xong" : time,
                        style: TextStyle(color: AppColors.textSecondary),
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
