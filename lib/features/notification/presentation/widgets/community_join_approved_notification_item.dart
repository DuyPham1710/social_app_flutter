import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CommunityJoinApprovedNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String communityName;
  final String time;
  final bool isRead;
  final VoidCallback? onCommunityTap;
  final String? message;

  const CommunityJoinApprovedNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.communityName,
    this.message,
    required this.time,
    required this.isRead,
    this.onCommunityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead ? const Color(0xFFFFFFFF) : const Color(0xFFEAF3FF),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      // ignore: sort_child_properties_last
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with icon overlay
          Stack(
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
                      child: const Icon(Icons.group),
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
                    Icons.diversity_1,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final msg =
                        message ??
                        'Yêu cầu tham gia cộng đồng của bạn đã được phê duyệt';
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: msg,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: ' $communityName',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onCommunityTap,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 6),

                Text(
                  time == "0 phút" ? "Vừa xong" : time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
