import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommunityJoinRequestNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String time;
  final bool isRead;
  final String? message;
  final VoidCallback? onUserTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCommunityTap;

  const CommunityJoinRequestNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.communityName,
    this.message,
    required this.time,
    required this.isRead,
    this.onUserTap,
    this.onAccept,
    this.onReject,
    this.onCommunityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                // Icon overlay for join request
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: const Color.fromARGB(255, 247, 177, 112),
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

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: userName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = onUserTap,
                      ),
                      TextSpan(
                        text: ' ${message ?? "đã gửi yêu cầu tham gia"} ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: communityName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onCommunityTap,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  time == "0 phút" ? "Vừa xong" : time,
                  style: TextStyle(color: Colors.grey.shade700),
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
                        child: const Text(
                          'Phê duyệt',
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                        child: const Text(
                          'Từ chối',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
