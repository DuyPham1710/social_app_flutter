import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/group_avatar_widget.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;

class ProfileHeader extends StatelessWidget {
  final bool isGroup;
  final String? groupName;
  final String? groupAvatar;
  final List<UserEntity>? participants;
  final UserEntity? friendInfo;

  const ProfileHeader({
    super.key,
    this.isGroup = false,
    this.groupName,
    this.groupAvatar,
    this.participants,
    this.friendInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (isGroup) {
      // Group chat profile
      final displayName = groupName ?? 'Group Chat';
      final displayAvatar = groupAvatar ?? 'https://i.pravatar.cc/200';
      final memberCount = participants?.length ?? 0;
      return Container(
        padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
        width: double.infinity,
        child: Column(
          children: [
            // Group avatar - dùng GroupAvatarWidget nếu có nhiều participants
            if (participants != null && participants!.length > 1)
              GroupAvatarWidget(
                avatarUrls: participants!
                    .where(
                      (p) => p.avatarUrl != null && p.avatarUrl!.isNotEmpty,
                    )
                    .map((p) => p.avatarUrl!)
                    .toList(),
                totalParticipants: participants!.length,
                size: 90,
              )
            else
              CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(displayAvatar),
              ),
            SizedBox(height: 12.h),

            // Tên nhóm
            Text(
              displayName,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Số thành viên
            Text(
              '$memberCount thành viên',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),

            SizedBox(height: 16.h),

            // Danh sách thành viên (hiển thị tối đa 3)
            if (participants != null && participants!.isNotEmpty)
              Column(
                children: [
                  ...participants!
                      .take(3)
                      .map(
                        (participant) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 12.r,
                                backgroundImage: participant.avatarUrl != null
                                    ? NetworkImage(participant.avatarUrl!)
                                    : null,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                participant.fullName ??
                                    participant.username ??
                                    'User',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (participants!.length > 3)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        'và ${participants!.length - 3} người khác',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),

            SizedBox(height: 16.h),

            // Nút Xem thông tin nhóm
            Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Xem thông tin nhóm",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 1-1 chat profile (giữ nguyên logic cũ)
    return Container(
      padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: NetworkImage(
              friendInfo?.avatarUrl ??
                  "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
            ),
          ),
          SizedBox(height: 12.h),

          // Tên hiển thị
          Text(
            friendInfo?.fullName ?? friendInfo?.username ?? "Unknown User",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Username nhỏ
          Text(
            friendInfo?.username != null
                ? "@${friendInfo!.username}"
                : "@unknown",
            style: TextStyle(
              color: AppColors.textSecondary, // Màu xám nhạt
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 12.h),

          // Dòng thông tin context (Bạn bè chung, v.v.)
          Text(
            "Các bạn là bạn bè trên Facebook",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),

          // Text(
          //   "1 bạn chung: Hùng Nguyễn",
          //   style: TextStyle(
          //     color: AppColors.textSecondary,
          //     fontSize: 12.sp,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          SizedBox(height: 16.h),

          // Nút Xem trang cá nhân
          Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => di.s1<OtherProfileBloc>()
                        ..add(
                          LoadOtherUserProfileEvent(userId: friendInfo!.userId),
                        ),
                      child: OtherProfilePage(userId: friendInfo!.userId),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "Xem trang cá nhân",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Status footer
          Text(
            "Bạn và ${friendInfo?.fullName?.split(' ').last ?? 'bạn này'} hiện đã là bạn bè.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
