import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
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
        overlayColor: AppColors.primary.withValues(alpha: 0.1),
        side: BorderSide(color: AppColors.divider),
        padding: EdgeInsets.symmetric(
          horizontal: 16.rs(context),
          vertical: 8.rsh(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.rsr(context)),
        ),
      ),
      child: Text(
        context.l10n.postMention,
        style: TextStyle(
          fontSize: 14.rsp(context),
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
