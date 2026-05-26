import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/component/add_friend_button.dart';

class ReactActionButton extends StatelessWidget {
  final String userId;
  final bool? isFriend;
  final bool isSend;
  final String? requestId;
  final Function(
    String userId,
    String userAvatar,
    String? parentId,
    String userDisplayName,
  )?
  onMention;
  final String userDisplayName;
  final String userAvatar;

  const ReactActionButton({
    super.key,
    required this.userId,
    this.isFriend,
    required this.isSend,
    this.requestId,
    this.onMention,
    required this.userDisplayName,
    required this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
    if (isFriend == null) {
      return SizedBox.shrink();
    }

    if (!isFriend!) {
      return AddFriendButton(
        userId: userId,
        isSend: isSend,
        requestId: requestId,
      );
    }

    return OutlinedButton(
      onPressed: () {
        // Gọi callback onMention và đóng ReactionDetailsPage
        if (onMention != null) {
          onMention!(userId, userDisplayName, null, userDisplayName);
          Navigator.pop(context);
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.divider),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        context.l10n.postMention,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      ),
    );
  }
}
