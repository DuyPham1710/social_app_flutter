import 'package:flutter/material.dart';

class NotificationBaseItem extends StatelessWidget {
  final String avatarUrl;
  final Widget iconOverlay;
  final String title;
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
      color: isRead
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFEAF3FF), // màu nền khi chưa đọc
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + icon overlay
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

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

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

                Text(time, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),

          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
