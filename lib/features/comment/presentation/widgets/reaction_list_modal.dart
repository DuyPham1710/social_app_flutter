// reaction_list_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/comment/domain/entities/react_comment_entity.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ReactionListModal extends StatelessWidget {
  final List<ReactCommentEntity> reacts;
  final String? currentUserId;
  final Function(String) onUserTap;

  const ReactionListModal({
    super.key,
    required this.reacts,
    required this.currentUserId,
    required this.onUserTap,
  });

  static void show(
    BuildContext context,
    List<ReactCommentEntity> reacts,
    String? currentUserId,
    Function(String) onUserTap,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => ReactionListModal(
        reacts: reacts,
        currentUserId: currentUserId,
        onUserTap: onUserTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      height: 400.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Text(
            context.l10n.commentReactionsTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.separated(
              itemCount: reacts.length,
              separatorBuilder: (context, index) =>
                  Divider(color: AppColors.divider, height: 1, thickness: 1),
              itemBuilder: (context, index) {
                final react = reacts[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.secondBackground,
                      backgroundImage: NetworkImage(
                        react.user.avatarUrl ??
                            'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                      ),
                    ),
                    title: Text(
                      react.user.userId == currentUserId
                          ? context.l10n.chatYou
                          : react.user.fullName ?? context.l10n.commonUnknown,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.secondBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        react.emoji.icon,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    onTap: () => onUserTap(react.user.userId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
