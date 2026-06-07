import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendItem extends StatelessWidget {
  final String friendId;
  final String name;
  final int mutualFriends;
  final String? avatarUrl;
  final List<String>? mutualFriendAvatars;
  final bool? isOnline;
  final DateTime? lastSeen;
  final bool onMyFriend;
  final VoidCallback? onMessage;
  final VoidCallback? onMoreOptions;

  const FriendItem({
    super.key,
    required this.friendId,
    required this.name,
    required this.mutualFriends,
    this.avatarUrl,
    this.mutualFriendAvatars,
    this.isOnline,
    this.lastSeen,
    required this.onMyFriend,
    this.onMessage,
    this.onMoreOptions,
  });

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    if (!context.mounted) return;
    final currentUserId = userData?['id'];

    // Nếu là user hiện tại → My Profile
    if (currentUserId == friendId) {
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
                  ..add(LoadOtherUserProfileEvent(userId: friendId)),
            child: OtherProfilePage(userId: friendId),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 12.rsh(context),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              GestureDetector(
                onTap: () => _navigateToProfile(context),
                child: CircleAvatar(
                  radius: 30.rsr(context),
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: avatarUrl == null
                      ? Icon(
                          CupertinoIcons.person_fill,
                          size: 30.rsr(context),
                          color: AppColors.unselectedIcon,
                        )
                      : null,
                ),
              ),
              // Online indicator hoặc last seen
              if (_shouldShowIndicator(context))
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: _buildStatusIndicator(context),
                ),
            ],
          ),
          SizedBox(width: 12.rs(context)),
          // Name and mutual friends
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.rsp(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.rsh(context)),
                // Hiển thị trạng thái online hoặc last seen
                if (_shouldShowIndicator(context) && !_isOnline())
                  Text(
                    _getLastSeenText(context),
                    style: TextStyle(
                      fontSize: 12.rsp(context),
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                // Chỉ hiển thị khi có bạn chung và không có last seen
                else if (mutualFriends > 0)
                  Row(
                    children: [
                      // Hiển thị avatars bạn chung hoặc icon mặc định
                      if (mutualFriendAvatars != null &&
                          mutualFriendAvatars!.isNotEmpty)
                        _buildMutualFriendAvatars(context)
                      else
                        Container(
                          width: 16.rsr(context),
                          height: 16.rsr(context),
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.person_2_fill,
                            size: 10.rsr(context),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      SizedBox(width: 6.rs(context)),
                      Text(
                        context.l10n.friendMutualCount(mutualFriends),
                        style: TextStyle(
                          fontSize: 13.rsp(context),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Action buttons
          onMyFriend
              ? Row(
                  children: [
                    // Message button
                    GestureDetector(
                      onTap: onMessage,
                      child: Container(
                        width: 36.rsr(context),
                        height: 36.rsr(context),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.chat_bubble_fill,
                          size: 18.rsr(context),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.rs(context)),
                    // More options button
                    GestureDetector(
                      onTap: onMoreOptions,
                      child: Container(
                        width: 36.rsr(context),
                        height: 36.rsr(context),
                        decoration: BoxDecoration(
                          color: AppColors.secondBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          size: 20.rsr(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildMutualFriendAvatars(BuildContext context) {
    // Nếu không có avatars hoặc không có bạn chung, return empty widget
    if (mutualFriends == 0 ||
        mutualFriendAvatars == null ||
        mutualFriendAvatars!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 48.rs(context),
      height: 20.rsh(context),
      child: Stack(
        children: List.generate(
          mutualFriendAvatars!.length.clamp(0, 3),
          (index) => Positioned(
            left: index * 16.rs(context),
            child: Container(
              width: 20.rsr(context),
              height: 20.rsr(context),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.background, width: 2),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(mutualFriendAvatars![index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Kiểm tra xem có nên hiển thị indicator không
  bool _shouldShowIndicator(BuildContext context) {
    // Hiển thị nếu online
    if (_isOnline()) return true;

    // Hiển thị nếu có lastSeen và trong vòng 1 ngày
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);
      return difference.inDays < 1;
    }

    return false;
  }

  /// Kiểm tra user có đang online không
  bool _isOnline() {
    return isOnline == true;
  }

  /// Build indicator (chấm xanh hoặc xám)
  Widget _buildStatusIndicator(BuildContext context) {
    if (_isOnline()) {
      // Chấm xanh cho online
      return Container(
        width: 14.rsr(context),
        height: 14.rsr(context),
        decoration: BoxDecoration(
          color: const Color(0xFF2CD45C),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.background, width: 2),
        ),
      );
    } else if (lastSeen != null) {
      // Chấm xám cho offline nhưng có last seen
      return Container(
        width: 14.rsr(context),
        height: 14.rsr(context),
        decoration: BoxDecoration(
          color: AppColors.unselectedIcon,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.background, width: 2),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Lấy text hiển thị thời gian last seen
  String _getLastSeenText(BuildContext context) {
    if (lastSeen == null) return '';

    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);

    // Nếu quá 1 ngày, không hiển thị
    if (difference.inDays >= 1) return '';

    // Nếu dưới 1 phút
    if (difference.inMinutes < 1) {
      return l10n.friendJustActive;
    }

    // Nếu dưới 1 giờ
    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return l10n.timeMinutesAgo(minutes);
    }

    // Nếu dưới 1 ngày
    final hours = difference.inHours;
    return l10n.timeHoursAgo(hours);
  }
}
