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

class FriendRequestItem extends StatelessWidget {
  final dynamic userId;
  final String name;
  final int mutualFriends;
  final String timeAgo;
  final String avatarUrl;
  final List<String>? mutualFriendAvatars;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool isAccepted;
  final bool isRejected;

  const FriendRequestItem({
    super.key,
    required this.userId,
    required this.name,
    required this.mutualFriends,
    required this.timeAgo,
    required this.avatarUrl,
    this.mutualFriendAvatars,
    this.onAccept,
    this.onReject,
    this.isAccepted = false,
    this.isRejected = false,
  });

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    if (!context.mounted) return;
    final currentUserId = userData?['id'];
    final String targetUserId = userId is Map
        ? (userId['_id'] ?? userId['id'] ?? '').toString()
        : userId.toString();

    // Nếu là user hiện tại → My Profile
    if (currentUserId == targetUserId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
            child: ProfilePage(),
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
                  ..add(LoadOtherUserProfileEvent(userId: targetUserId)),
            child: OtherProfilePage(userId: targetUserId),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rs(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar lớn hơn
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              radius: 32.rsr(context),
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
          SizedBox(width: 16.rs(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người dùng và thời gian
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _navigateToProfile(context),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.rsp(context),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.rs(context)),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12.rsp(context),
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.rsh(context)),
                // Bạn chung với avatars - chỉ hiển thị khi có bạn chung
                if (mutualFriends > 0)
                  Row(
                    children: [
                      if (mutualFriendAvatars != null &&
                          mutualFriendAvatars!.isNotEmpty)
                        _buildMutualFriendAvatars(context)
                      else
                        Container(
                          padding: EdgeInsets.all(4.rs(context)),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.rsr(context)),
                          ),
                          child: Icon(
                            CupertinoIcons.person_2,
                            size: 14.rsr(context),
                            color: AppColors.primary,
                          ),
                        ),
                      SizedBox(width: 6.rs(context)),
                      Text(
                        context.l10n.friendMutualCount(mutualFriends),
                        style: TextStyle(
                          fontSize: 13.rsp(context),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.rsh(context)),
                // Nút hành động hoặc thông báo
                if (isAccepted)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.rsh(context),
                      horizontal: 16.rs(context),
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8.rsr(context)),
                      border: Border.all(color: Colors.green[200]!, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                          size: 16.rsr(context),
                        ),
                        SizedBox(width: 8.rs(context)),
                        Text(
                          context.l10n.friendBecameFriends,
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 13.rsp(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isRejected)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.rsh(context),
                      horizontal: 16.rs(context),
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.secondBackground,
                      borderRadius: BorderRadius.circular(8.rsr(context)),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 16.rsr(context),
                        ),
                        SizedBox(width: 8.rs(context)),
                        Text(
                          context.l10n.friendRequestRemoved,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.rsp(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          label: context.l10n.friendAccept,
                          background: AppColors.primary,
                          foreground: Colors.white,
                          onTap: onAccept ?? () {},
                        ),
                      ),
                      SizedBox(width: 12.rs(context)),
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          label: context.l10n.friendDelete,
                          background: AppColors.secondBackground,
                          foreground: AppColors.textPrimary,
                          onTap: onReject ?? () {},
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
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

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.rsh(context)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8.rsr(context)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 12.rsp(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
