import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/post/presentation/helpers/tag_helper.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';

class PostHeader extends StatelessWidget {
  final UserEntity user;
  final DateTime? createdAt;
  final VoidCallback? onReportTap;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onSaveTap;
  final bool? isSaved;
  final List<UserEntity>? taggedUsers;
  final List<String>? visibleOnProfileUserIds;
  final Function(bool)? onTagVisibilityTap;
  final VoidCallback? onRemoveTagTap;

  const PostHeader({
    super.key,
    required this.user,
    this.createdAt,
    this.onReportTap,
    this.onOptionsTap,
    this.onSaveTap,
    this.isSaved,
    this.taggedUsers,
    this.visibleOnProfileUserIds,
    this.onTagVisibilityTap,
    this.onRemoveTagTap,
  });

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes == 0) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  Future<String?> _getCurrentUserId() async {
    final userData = await TokenStorage.getUserData();
    return userData?['id'];
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

  Widget _buildTitleText(BuildContext context) {
    final ownerName = user.fullName ?? "Người dùng";
    final taggedNames =
        taggedUsers?.map((u) => u.fullName ?? "Người dùng").toList() ?? [];

    return TagHelper.buildTitleWithTags(
      ownerName: ownerName,
      taggedNames: taggedNames,
    );
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
                  child: _buildTitleText(context),
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
          FutureBuilder<String?>(
            future: _getCurrentUserId(),
            builder: (context, snapshot) {
              final currentUserId = snapshot.data;
              final isOwner = currentUserId == user.userId;

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
                  onSelected: (value) async {
                    if (value == 'report') {
                      onReportTap?.call();
                    } else if (value == 'share') {
                      // TODO: Thêm logic chia sẻ bài viết nếu cần
                    } else if (value == 'save') {
                      onSaveTap?.call();
                    } else if (value == 'toggle_tag_visibility') {
                      final isVisible =
                          visibleOnProfileUserIds?.contains(currentUserId) ??
                          false;
                      onTagVisibilityTap?.call(!isVisible);
                    } else if (value == 'remove_tag') {
                      onRemoveTagTap?.call();
                    }
                  },
                  itemBuilder: (context) =>
                      _buildPopupMenuItems(context, currentUserId),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(
    BuildContext context,
    String? currentUserId,
  ) {
    return [
      const PopupMenuItem(
        value: 'share',
        child: Row(
          children: [
            Icon(Icons.share, size: 18),
            SizedBox(width: 8),
            Text('Chia sẻ'),
          ],
        ),
      ),

      PopupMenuItem(
        value: 'save',
        child: Row(
          children: [
            Icon(
              isSaved == true
                  ? Icons.bookmark_remove_outlined
                  : Icons.bookmark_border,
              size: 18,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(isSaved == true ? 'Bỏ lưu bài viết' : 'Lưu bài viết'),
          ],
        ),
      ),

      const PopupMenuItem(
        value: 'report',
        child: Row(
          children: [
            Icon(Icons.flag_outlined, size: 18, color: Colors.red),
            SizedBox(width: 8),
            Text('Báo cáo bài viết'),
          ],
        ),
      ),

      // Thêm các option cho người được tag
      ..._buildTagOptions(currentUserId),
    ];
  }

  List<PopupMenuEntry<String>> _buildTagOptions(String? currentUserId) {
    if (currentUserId == null) return [];

    // Kiểm tra xem current user có trong danh sách taggedUsers không
    final isTagged =
        taggedUsers?.any((u) => u.userId == currentUserId) ?? false;
    if (!isTagged) return [];

    final isVisible = visibleOnProfileUserIds?.contains(currentUserId) ?? false;

    return [
      PopupMenuItem(
        value: 'toggle_tag_visibility',
        child: Row(
          children: [
            Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
            ),
            SizedBox(width: 8.w),
            Text(
              isVisible ? 'Ẩn khỏi trang cá nhân' : 'Hiển thị ở trang cá nhân',
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'remove_tag',
        child: Row(
          children: [
            Icon(Icons.person_remove_outlined, size: 18, color: Colors.red),
            SizedBox(width: 8.w),
            Text('Gỡ gắn thẻ', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ];
  }
}
