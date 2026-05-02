import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CommunityJoinRejectedNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String communityName;
  final String time;
  final bool isRead;
  final VoidCallback? onUserTap;
  final VoidCallback? onCommunityTap;
  final String? message;

  const CommunityJoinRejectedNotificationItem({
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
                // Icon overlay for rejected
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.red,
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
                Builder(
                  builder: (context) {
                    final msg = message ?? 'đã từ chối yêu cầu';
                    final quotedCommunity = '"$communityName"';

                    int idx = -1;
                    int communityLength = 0;
                    if (msg.contains(quotedCommunity)) {
                      idx = msg.indexOf(quotedCommunity);
                      communityLength = quotedCommunity.length;
                    } else if (msg.contains(communityName)) {
                      idx = msg.indexOf(communityName);
                      communityLength = communityName.length;
                    }

                    final hasCommunityInline = idx != -1;

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

                    if (hasCommunityInline) {
                      final before = msg.substring(0, idx);
                      final after = msg.substring(idx + communityLength);

                      spans.add(
                        TextSpan(
                          text: ' ${before.trimLeft()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );

                      spans.add(
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
                      );

                      if (after.trim().isNotEmpty) {
                        spans.add(
                          TextSpan(
                            text: ' ${after.trim()}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }
                    } else {
                      spans.add(
                        TextSpan(
                          text: ' $msg',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    }

                    return RichText(text: TextSpan(children: spans));
                  },
                ),

                const SizedBox(height: 6),

                Text(
                  time == "0 phút" ? "Vừa xong" : time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 8),

                // Status message
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Yêu cầu tham gia đã bị từ chối',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
