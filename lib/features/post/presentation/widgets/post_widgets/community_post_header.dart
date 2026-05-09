import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/community/domain/entities/community_entity.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_detail_page.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';

/// Community Post Header
/// Shows: Community Badge > Community Name + Avatar | User Name | Time
/// Used for posts within communities (always public by default)
class CommunityPostHeader extends StatelessWidget {
  final CommunityEntity? community;
  final UserEntity user;
  final DateTime? createdAt;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onReportTap;
  final bool showCommunityInfo; // Ẩn info nhóm khi xem trong community detail

  const CommunityPostHeader({
    super.key,
    required this.community,
    required this.user,
    this.createdAt,
    this.onOptionsTap,
    this.onReportTap,
    this.showCommunityInfo = true, // Default: hiển thị info nhóm
  });

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes == 0) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  Future<void> _navigateToCommunity(BuildContext context) async {
    if (community == null) return;
    Navigator.push(
      context,
      CommunityDetailPage.route(communityId: community!.id),
    );
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // Nếu là user hiện tại → My Profile
    if (currentUserId == user.userId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
            child: const ProfilePage(),
          ),
        ),
      );
    } else {
      // Nếu là người khác → Other Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<OtherProfileBloc>()
                  ..add(LoadOtherUserProfileEvent(userId: user.userId)),
            child: OtherProfilePage(userId: user.userId),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Community Avatar (large with border) + Community Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Community Avatar with User Avatar overlay (chỉ hiển thị nếu showCommunityInfo = true)
              if (community != null && showCommunityInfo)
                GestureDetector(
                  onTap: () => _navigateToCommunity(context),
                  child: Stack(
                    children: [
                      // Large Community Avatar with border
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1.5.w,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: community!.avatar != null
                              ? Image.network(
                                  community!.avatar!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.group,
                                      size: 24.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // User Avatar overlay (bottom-right, 50% border)
                      Positioned(
                        bottom: -6.h,
                        right: -6.h,
                        child: GestureDetector(
                          onTap: () => _navigateToProfile(context),
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.background,
                                width: 2.5.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.avatarUrl ??
                                    "https://randomuser.me/api/portraits/men/1.jpg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (showCommunityInfo) SizedBox(width: 12.w),
              // Community Name + User Info (chỉ hiển thị community name nếu showCommunityInfo = true)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showCommunityInfo) ...[
                      SizedBox(height: 4.h),
                      // Community Name
                      GestureDetector(
                        onTap: () => _navigateToCommunity(context),
                        child: Text(
                          community?.name ?? "Community",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ] else
                      SizedBox(height: 4.h),
                    // User Name
                    GestureDetector(
                      onTap: () => _navigateToProfile(context),
                      child: Row(
                        children: [
                          Text(
                            user.fullName ?? user.username ?? "Unknown",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '·',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.groups_rounded,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Time · Visibility
                    Row(
                      children: [
                        Text(
                          createdAt != null ? _timeAgo(createdAt!) : "Vừa xong",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Menu
              if (onOptionsTap != null || onReportTap != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'options' && onOptionsTap != null) {
                      onOptionsTap!();
                    } else if (value == 'report' && onReportTap != null) {
                      onReportTap!();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    if (onOptionsTap != null)
                      const PopupMenuItem(
                        value: 'options',
                        child: Text('Tùy chọn'),
                      ),
                    if (onReportTap != null)
                      const PopupMenuItem(
                        value: 'report',
                        child: Text('Báo cáo'),
                      ),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 18.sp,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
