import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ConversationItem extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String preview;
  final bool isUnread;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.preview,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      leading: CircleAvatar(
        radius: 26.r,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        preview,
        style: TextStyle(
          color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
        ),
      ),

      // Chỉ hiện chấm xanh nếu chưa đọc
      trailing: isUnread
          ? Icon(Icons.circle, color: AppColors.primary, size: 10.r)
          : null,

      onTap: onTap,
    );
  }
}
