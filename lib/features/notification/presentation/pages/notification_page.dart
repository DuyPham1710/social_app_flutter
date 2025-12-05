import 'package:flutter/material.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/comment_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/friend_request_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/message_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/share_notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Thông báo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [
          Icon(Icons.more_horiz, size: 28),
          SizedBox(width: 16),
          Icon(Icons.search, size: 28),
          SizedBox(width: 16),
        ],
      ),

      body: ListView(
        children: [
          const NotificationSectionTitle(title: "Mới"),

          // ======= NEW NOTIFICATIONS =======
          FriendRequestNotificationItem(
            avatarUrl: "https://picsum.photos/200?10",
            userName: "Duy Phạm",
            time: "38 phút",
            isRead: false,
            mutualFriends: "33 bạn chung",
            onAccept: () {},
            onRemove: () {},
          ),

          MessageNotificationItem(
            isRead: false,
            avatarUrl: "https://picsum.photos/200?1",
            title: "Mê Tiki: Ủa, sao Tiki biết mấy con mọt sách như tui...",
            time: "24 phút",
          ),

          CommentNotificationItem(
            isRead: false,
            avatarUrl: "https://picsum.photos/200?2",
            title: "Võ Trung Tuấn Kiệt đã bình luận về bài viết của bạn...",
            preview: "\"Hồ ở đâu ạ\"",
            time: "1 giờ",
          ),

          ShareNotificationItem(
            isRead: false,
            avatarUrl: "https://picsum.photos/200?3",
            title: "BLV Anh Quân - News gần đây đã chia sẻ 1 bài viết.",
            time: "1 giờ",
          ),

          const SizedBox(height: 12),
          const NotificationSectionTitle(title: "Trước đó"),

          // ======= OLD NOTIFICATIONS =======
          MessageNotificationItem(
            isRead: true,
            avatarUrl: "https://picsum.photos/200?4",
            title: "Gia Sư Nhân Văn đã đăng một cập nhật: Lớp cần gia sư...",
            time: "5 giờ",
          ),

          MessageNotificationItem(
            isRead: true,
            avatarUrl: "https://picsum.photos/200?5",
            title: "Gia Sư Nhân Văn đã đăng một cập nhật: Lớp cần gia sư...",
            time: "6 giờ",
          ),

          CommentNotificationItem(
            isRead: true,
            avatarUrl: "https://picsum.photos/200?6",
            title:
                "Andy Thái Bùi và Minh Đức đã bình luận về bài viết của bạn...",
            preview: "Andy: \"Ib em với\"",
            time: "7 giờ",
          ),
        ],
      ),
    );
  }
}

class NotificationSectionTitle extends StatelessWidget {
  final String title;
  const NotificationSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
