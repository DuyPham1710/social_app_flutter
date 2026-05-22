import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendMessageSuggestionItem extends StatelessWidget {
  final String avatar;
  final String name;
  final VoidCallback onTap;

  const FriendMessageSuggestionItem({
    super.key,
    required this.avatar,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 20.r,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontSize: 16.sp,
        ),
      ),
      trailing: Text(
        context.l10n.profileMessage,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
      onTap: onTap,
    );
  }
}
