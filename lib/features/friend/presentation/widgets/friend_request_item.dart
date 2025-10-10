import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class FriendRequestItem extends StatelessWidget {
  final String name;
  final int mutualFriends;
  final String timeAgo;
  final String avatarUrl;

  const FriendRequestItem({
    super.key,
    required this.name,
    required this.mutualFriends,
    required this.timeAgo,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 28.r, backgroundImage: NetworkImage(avatarUrl)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _mutualGroupAvatars(),
                    SizedBox(width: 6.w),
                    Text(
                      '$mutualFriends bạn chung',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'Xác nhận',
                        background: AppColors.primary,
                        foreground: Colors.white,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildActionButton(
                        label: 'Xóa',
                        background: const Color(0xFFE7E7E7),
                        foreground: Colors.black,
                        onTap: () {},
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _mutualGroupAvatars() {
    return SizedBox(
      width: 48.w,
      height: 20.h,
      child: Stack(
        children: [
          _smallAvatar('https://i.pravatar.cc/40?img=1', left: 0),
          _smallAvatar('https://i.pravatar.cc/40?img=2', left: 16.w),
          _smallAvatar('https://i.pravatar.cc/40?img=3', left: 32.w),
        ],
      ),
    );
  }

  Widget _smallAvatar(String url, {required double left}) {
    return Positioned(
      left: left,
      child: Container(
        width: 20.r,
        height: 20.r,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }
}



