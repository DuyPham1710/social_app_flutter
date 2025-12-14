import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class FriendRequestNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String time;
  final bool isRead;
  final String? mutualFriends;
  final VoidCallback? onAccept;
  final VoidCallback? onRemove;

  const FriendRequestNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.time,
    required this.isRead,
    this.mutualFriends,
    this.onAccept,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFEAF3FF), // màu nền khi chưa đọc
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      // ignore: sort_child_properties_last
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + icon overlay
          Stack(
            children: [
              ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.person_add,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Nội dung
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
                      ),
                      const TextSpan(
                        text: " đã gửi cho bạn lời mời kết bạn.",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      time == "0 phút" ? "Vừa xong" : time,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),

                if (mutualFriends != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      mutualFriends!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),

                const SizedBox(height: 12),

                // Buttons
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
                          "Xác nhận",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: onRemove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Xóa",
                          style: TextStyle(fontSize: 16, color: Colors.black),
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

      //khoảng cách giữa các item
      margin: const EdgeInsets.only(bottom: 4),
    );
  }
}
