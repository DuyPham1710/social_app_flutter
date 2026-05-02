import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewPost,
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
                      final msg =
                          message ?? 'đã gửi yêu cầu đăng bài vào cộng đồng';
                      final quotedMatch = RegExp(r'"([^"]+)"').firstMatch(msg);

                      final List<TextSpan> spans = [];

                      // User name (bold + tappable)
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

                      if (quotedMatch != null) {
                        final before = msg.substring(0, quotedMatch.start);
                        final quotedText = quotedMatch.group(1) ?? '';
                        final after = msg.substring(quotedMatch.end);

                        if (before.trim().isNotEmpty) {
                          spans.add(
                            TextSpan(
                              text: ' ${before.trimLeft()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }

                        spans.add(
                          TextSpan(
                            text: quotedText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
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
                                fontSize: 15,
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
                              fontSize: 15,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
