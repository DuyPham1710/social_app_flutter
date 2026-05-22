import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_profile_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SearchResultItem extends StatelessWidget {
  final UserEntity user;

  const SearchResultItem({super.key, required this.user});

  Future<void> _navigateToProfile(BuildContext context) async {
    if (!context.mounted) return;

    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    if (!context.mounted) return;

    // Lưu người dùng đã xem vào lịch sử tìm kiếm (chỉ khi không phải chính mình)
    if (currentUserId != user.userId) {
      try {
        final searchRepository = di.s1<SearchRepository>();
        await searchRepository.saveViewedUser(viewedUserId: user.userId);
      } catch (e) {
        // Không hiển thị lỗi nếu không lưu được lịch sử
        // Chỉ log để debug
        debugPrint('Error saving viewed user to search history: $e');
      }
    }

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
                  ..add(LoadOtherUserProfileEvent(userId: user.userId!)),
            child: OtherProfilePage(userId: user.userId!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: InkWell(
        onTap: () => _navigateToProfile(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 32.r,
              backgroundImage:
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 32.r,
                      color: AppColors.textSecondary,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            // Thông tin user
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName ?? user.username ?? context.l10n.commonUser,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (user.username != null && user.username!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Icon mũi tên
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
