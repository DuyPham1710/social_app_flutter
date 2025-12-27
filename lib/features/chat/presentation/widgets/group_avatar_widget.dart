import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class GroupAvatarWidget extends StatelessWidget {
  final List<String> avatarUrls;
  final int totalParticipants;
  final double size;

  const GroupAvatarWidget({
    super.key,
    required this.avatarUrls,
    required this.totalParticipants,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy tối đa 4 avatar đầu tiên
    final displayAvatars = avatarUrls.take(4).toList();
    final extraCount = totalParticipants - displayAvatars.length;

    if (displayAvatars.length == 1) {
      // Hiển thị 1 avatar như bình thường
      return CircleAvatar(
        radius: (size / 2).r,
        backgroundImage: NetworkImage(displayAvatars[0]),
        backgroundColor: AppColors.textSecondary.withOpacity(0.1),
      );
    }

    // Hiển thị grid 2x2 cho nhiều avatar
    return SizedBox(
      width: size.r,
      height: size.r,
      child: Stack(
        children: [
          // Container nền
          Container(
            width: size.r,
            height: size.r,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
          // Grid layout cho avatars
          if (displayAvatars.length == 2)
            _buildTwoAvatars(displayAvatars, extraCount),
          if (displayAvatars.length == 3)
            _buildThreeAvatars(displayAvatars, extraCount),
          if (displayAvatars.length >= 4)
            _buildFourAvatars(displayAvatars, extraCount),
        ],
      ),
    );
  }

  Widget _buildTwoAvatars(List<String> avatars, int extraCount) {
    final avatarSize = (size / 1.8).r;
    return Stack(
      children: [
        // Avatar 1 - top left
        Positioned(
          left: 2.r,
          top: 2.r,
          child: _buildSmallAvatar(avatars[0], avatarSize),
        ),
        // Avatar 2 - bottom right
        Positioned(
          right: 2.r,
          bottom: 2.r,
          child: extraCount > 0
              ? _buildCountBadge(extraCount + 1, avatarSize)
              : _buildSmallAvatar(avatars[1], avatarSize),
        ),
      ],
    );
  }

  Widget _buildThreeAvatars(List<String> avatars, int extraCount) {
    final avatarSize = (size / 2.2).r;
    return Stack(
      children: [
        // Avatar 1 - top left
        Positioned(
          left: 1.r,
          top: 4.r,
          child: _buildSmallAvatar(avatars[0], avatarSize),
        ),
        // Avatar 2 - top right
        Positioned(
          right: 1.r,
          top: 4.r,
          child: _buildSmallAvatar(avatars[1], avatarSize),
        ),
        // Avatar 3 or count badge - bottom center
        Positioned(
          left: (size / 2 - avatarSize / 2).r,
          bottom: 1.r,
          child: extraCount > 0
              ? _buildCountBadge(extraCount + 1, avatarSize)
              : _buildSmallAvatar(avatars[2], avatarSize),
        ),
      ],
    );
  }

  Widget _buildFourAvatars(List<String> avatars, int extraCount) {
    final avatarSize = (size / 2.5).r;
    return Stack(
      children: [
        // Avatar 1 - top left
        Positioned(
          left: 1.r,
          top: 1.r,
          child: _buildSmallAvatar(avatars[0], avatarSize),
        ),
        // Avatar 2 - top right
        Positioned(
          right: 1.r,
          top: 1.r,
          child: _buildSmallAvatar(avatars[1], avatarSize),
        ),
        // Avatar 3 - bottom left
        Positioned(
          left: 1.r,
          bottom: 1.r,
          child: _buildSmallAvatar(avatars[2], avatarSize),
        ),
        // Avatar 4 or count badge - bottom right
        Positioned(
          right: 1.r,
          bottom: 1.r,
          child: extraCount > 0
              ? _buildCountBadge(extraCount + 1, avatarSize)
              : _buildSmallAvatar(avatars[3], avatarSize),
        ),
      ],
    );
  }

  Widget _buildSmallAvatar(String url, double avatarSize) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: 1.5),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCountBadge(int count, double avatarSize) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textSecondary.withOpacity(0.8),
        border: Border.all(color: AppColors.background, width: 1.5),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: Colors.white,
            fontSize: (avatarSize / 2.5).sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
