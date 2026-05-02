import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CommunityPostRejectedNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String time;
  final bool isRead;
  final String? rejectionReason;
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
    this.rejectionReason,
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

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bài viết bị từ chối',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: communityName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
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

                  // Status message with reason
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade200),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bài viết không được phê duyệt',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.orange.shade700,
                            ),
                          ],
                        ),
                        if (rejectionReason != null &&
                            rejectionReason!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Lý do: $rejectionReason',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
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
