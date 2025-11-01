import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReactActionButton extends StatelessWidget {
  final String userId;
  final bool? isFriend;
  final bool isSend;
  final String? requestId;

  const ReactActionButton({
    super.key,
    required this.userId,
    this.isFriend,
    required this.isSend,
    this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    if (isFriend == null) {
      return SizedBox.shrink();
    }

    if (!isFriend!) {
      return GestureDetector(
        onTap: () {
          if (!isSend) {
            context.read<FriendBloc>().add(
              SendFriendRequest(receiverId: userId),
            );
          } else {
            final idToCancel = requestId ?? userId;

            context.read<FriendBloc>().add(
              CancelSentFriendRequest(requestId: idToCancel),
            );
          }
        },

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSend ? Colors.grey[200] : AppColors.primary,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: isSend
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.person_badge_minus,
                      color: AppColors.textSecondary,
                      size: 16.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Hủy lời mời',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Thêm bạn bè',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    }

    return OutlinedButton(
      onPressed: () {
        // TODO: Xử lý nhắc đến
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade400),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        'Nhắc đến',
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
      ),
    );
  }
}
