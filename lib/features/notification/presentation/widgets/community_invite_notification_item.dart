import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

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
                    final msg = message ?? 'đã mời bạn tham gia';

                    final List<TextSpan> spans = [];
                    spans.add(
                      TextSpan(
                        text: userName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = onUserTap,
                      ),
                    );
                    spans.add(
                      TextSpan(
                        text: ' $msg ',
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      ),
                    );
                    spans.add(
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
                    );
                    return RichText(text: TextSpan(children: spans));
                  },
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
                          'Chấp nhận',
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
                          'Xóa',
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
