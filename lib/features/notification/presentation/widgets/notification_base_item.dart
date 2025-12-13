import 'package:flutter/material.dart';

class NotificationBaseItem extends StatelessWidget {
  final String avatarUrl;
  final Widget iconOverlay;
  final Widget title;
  final String? preview;
  final String time;
  final bool isRead;

  const NotificationBaseItem({
    super.key,
    required this.avatarUrl,
    required this.iconOverlay,
    required this.title,
    this.preview,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead ? Colors.white : const Color(0xFFEAF3FF), // chưa đọc
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      // ignore: sort_child_properties_last
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + icon
          Stack(
            children: [
              ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(bottom: 0, right: 0, child: iconOverlay),
            ],
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,

                if (preview != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      preview!,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                const SizedBox(height: 4),
                Text(
                  time == "0 phút" ? "Vừa xong" : time,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const Icon(Icons.more_horiz),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 2),
    );
  }
}
