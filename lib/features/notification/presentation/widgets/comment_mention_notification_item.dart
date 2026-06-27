import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommentMentionNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String content;
  final String time;
  final bool isRead;
  final String? actionText;
  final VoidCallback? onUserTap;
  final VoidCallback? onMessageTap;

  const CommentMentionNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.content,
    required this.time,
    required this.isRead,
    this.actionText,
    this.onUserTap,
    this.onMessageTap,
  });
  List<InlineSpan> _parseContent(String text) {
    final List<InlineSpan> spans = [];

    final RegExp regex = RegExp(r"@\[([^\]]+)\]\(([^)]+)\)");
    final Iterable<RegExpMatch> matches = regex.allMatches(text);

    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: TextStyle(color: AppColors.textPrimary), // Style text thường
          ),
        );
      }

      spans.add(
        TextSpan(
          text: '@${match.group(1)}', // Lấy tên trong group 1
          style: TextStyle(
            fontWeight: FontWeight.bold, // In đậm mention
            color: AppColors.primary,
          ),
        ),
      );

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: TextStyle(color: AppColors.textPrimary),
        ),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedActionText =
        actionText ?? context.l10n.notificationCommentedOnYourPost;
    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: avatarUrl,
      userId: userId,
      onAvatarTap: onUserTap,
      onItemTap: onMessageTap,
      title: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          children: [
            TextSpan(
              text: userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = onUserTap,
            ),
            TextSpan(
              text: ' $resolvedActionText ',
              recognizer: TapGestureRecognizer()..onTap = onMessageTap,
            ),
            ...[
              for (final span in _parseContent(content))
                if (span is TextSpan)
                  TextSpan(
                    text: span.text,
                    style: span.style,
                    recognizer: TapGestureRecognizer()..onTap = onMessageTap,
                  )
                else
                  span,
            ],
          ],
        ),
      ),
      preview: null, // content đã nằm trong title
      time: time,
      iconOverlay: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: Icon(Icons.chat_bubble, color: Colors.white, size: 14),
      ),
    );
  }
}
