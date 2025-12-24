import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeader extends StatelessWidget {
  final UserEntity user;
  final DateTime? createdAt;
  final VoidCallback? onReportTap;
  final VoidCallback? onOptionsTap;
  const PostHeader({
    super.key,
    required this.user,
    this.createdAt,
    this.onReportTap,
    this.onOptionsTap,
  });

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes == 0) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  Future<bool> _isCurrentUser() async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];
    return currentUserId == user.userId;
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
      //Nếu là người khác → Other Profile
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                user.avatarUrl ??
                    "https://randomuser.me/api/portraits/men/1.jpg",
              ),
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Text(
                    user.fullName ?? "Người dùng",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Text(
                  createdAt != null
                      ? _timeAgo(createdAt!)
                      : "Không rõ thời gian",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          FutureBuilder<bool>(
            future: _isCurrentUser(),
            builder: (context, snapshot) {
              final isOwner = snapshot.data ?? false;

              if (isOwner) {
                // Nếu là chủ sở hữu, hiển thị icon để mở options
                return IconButton(
                  icon: Icon(Icons.more_horiz, size: 20.sp),
                  onPressed: onOptionsTap,
                );
              } else {
                // Nếu không phải chủ sở hữu, hiển thị menu report/share
                return PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz, size: 20.sp),
                  color: AppColors.background,
                  onSelected: (value) {
                    if (value == 'report') {
                      onReportTap?.call();
                    } else if (value == 'share') {
                      // TODO: Thêm logic chia sẻ bài viết nếu cần
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          const Icon(Icons.share, size: 18),
                          SizedBox(width: 8.w),
                          const Text('Chia sẻ'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flag_outlined,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8.w),
                          const Text('Báo cáo bài viết'),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
