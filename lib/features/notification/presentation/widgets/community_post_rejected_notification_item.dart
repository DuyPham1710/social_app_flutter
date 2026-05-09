import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommunityPostRejectedNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String time;
  final bool isRead;
  final String? message;
  final VoidCallback? onUserTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onCommunityTap;

  const CommunityPostRejectedNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.communityName,
    required this.time,
    required this.isRead,
    this.message,
    this.onUserTap,
    this.onViewDetails,
    this.onCommunityTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        color: isRead ? const Color(0xFFFFFFFF) : const Color(0xFFEAF3FF),
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
                  // Icon overlay for rejected
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.orange,
                      child: const Icon(
                        Icons.cancel,
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
                      final msg = message ?? 'đã gửi yêu cầu đăng bài vào cộng đồng';

                      final List<TextSpan> spans = [];

                      //message bấm vào là xem bài viết
                      spans.add(
                        TextSpan(
                          text: '$msg ',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                        ),
                      );
                      spans.add(
                        TextSpan(
                          text: communityName,
                          style: const TextStyle(
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
                    time == "0 phút" ? "Vừa xong" : time,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),
            const Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
